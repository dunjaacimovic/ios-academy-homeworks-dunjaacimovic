//
//  LoginViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 08/07/2018.
//  Copyright © 2018 Dunja Acimovic. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import CodableAlamofire

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var checkboxButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    
    private var isBoxChecked: Bool!
    
    private var user: User?
    private var loginData: LoginData?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        isBoxChecked = false
        loginButton.layer.cornerRadius = 5
        
        loginRememberedUser()
    }
    
    @IBAction func boxTapped(_ sender: Any) {
        
        isBoxChecked = !isBoxChecked
        
        if isBoxChecked {
            checkboxButton.setImage(UIImage(named: "ic-checkbox-filled"), for: UIControlState.normal)
        } else {
            checkboxButton.setImage(UIImage(named: "ic-checkbox-empty"), for: UIControlState.normal)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    @IBAction private func loginButtonActionHandler() {
        
        SVProgressHUD.show()
        
        let parameters: [String: String] = [
            "email": usernameTextField.text!,
            "password": passwordTextField.text!
        ]
        
        login(parameters: parameters)
    }
    
    
    @IBAction private func createAccountActionHandler() {
        
        
        let parameters: [String: String] = [
            "email": usernameTextField.text!,
            "password": passwordTextField.text!
        ]
        
        Alamofire.request("https://api.infinum.academy/api/users",
                          method: .post,
                          parameters: parameters,
                          encoding: JSONEncoding.default)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()){
                [weak self]
                (response: DataResponse<User>) in
                guard let `self` = self else { return }
                
                switch response.result {
                case .success(let parsedUser):
                    
                    self.user = parsedUser
                    
                    let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
                    let homeViewController = homeStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                    
                    
                    self.navigationController?.pushViewController(homeViewController, animated: true)
                    // navigationController?.setViewControllers([homeViewController], animated: true)
                    
                case .failure(let error):
                    print("API failure: \(error)")
                }
        }
        SVProgressHUD.dismiss()
    }
}

extension LoginViewController {
    
    func login(parameters: [String:String]){
        
        Alamofire.request("https://api.infinum.academy/api/users/sessions",
                          method: .post,
                          parameters: parameters,
                          encoding: JSONEncoding.default)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()){
                [weak self]
                (response: DataResponse<LoginData>) in
                guard let `self` = self else { return }
                
                switch response.result {
                case .success(let parsedData):
                    
                    self.loginData = parsedData
                    
                    let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
                    let homeViewController = homeStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                    homeViewController.configure(with: parsedData.token)
                    self.navigationController?.pushViewController(homeViewController, animated: true)
                    
                    if(self.isBoxChecked){
                        if let email = self.usernameTextField.text, let password = self.passwordTextField.text {
                            UserDefaults.standard.set(email, forKey: "TVShows.email")
                            UserDefaults.standard.set(password, forKey: "TVShows.password")
                        }
                    }
                    
                case .failure(let error):
                    print("API failure: \(error)")
                    self.alert()
                }
        }
        SVProgressHUD.dismiss()
    }
    
    func loginRememberedUser(){
        if
            let email = UserDefaults.standard.string(forKey: "TVShows.email"),
            let password = UserDefaults.standard.string(forKey: "TVShows.password"){
            let rememberedParameters: [String: String] = [
                "email": email,
                "password": password
            ]
            login(parameters: rememberedParameters)
        }
    }
    
    func shakeTextField(_ textfield: UITextField){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: textfield.center.x - 10, y: textfield.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: textfield.center.x + 10, y: textfield.center.y))
        textfield.layer.add(animation, forKey: "position")
    }
    
    func alert() {
        let alertController = UIAlertController(title: "Login error", message: "Wrong e-mail or password.", preferredStyle: .alert)
        let action = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in print("You've pressed cancel"); }
        alertController.addAction(action)
        self.present(alertController, animated: true)
        self.shakeTextField(self.passwordTextField)
    }
}


extension UIViewController : UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
