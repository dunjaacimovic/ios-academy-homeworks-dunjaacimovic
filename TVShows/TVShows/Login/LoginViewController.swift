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
    
    struct User: Codable {
        let email: String
        let type: String
        let id: String
        enum CodingKeys: String, CodingKey {
            case email
            case type
            case id = "_id"
        }
    }
    struct LoginData: Codable {
        let token: String
    }
    private var user: User?
    private var loginData: LoginData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        isBoxChecked = false
        loginButton.layer.cornerRadius = 5
        
    }

    @IBAction func boxTapped(_ sender: Any) {
     
        if isBoxChecked == true {
            isBoxChecked = false
        }else{
            isBoxChecked = true
        }
        
        if isBoxChecked == true{
            checkboxButton.setImage(UIImage(named: "ic-checkbox-filled"), for: UIControlState.normal)
        }else{
            checkboxButton.setImage(UIImage(named: "ic-checkbox-empty"), for: UIControlState.normal)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    @IBAction private func loginButtonActionHandler() {
        
        SVProgressHUD.show()
        
            let parameters: [String: String] = [
                "email": usernameTextField.text!,
                "password": passwordTextField.text!
            ]
        
            Alamofire.request("https://api.infinum.academy/api/users/sessions",
                              method: .post,
                              parameters: parameters,
                              encoding: JSONEncoding.default)
                .validate()
                .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()){
                        (response: DataResponse<LoginData>) in
                    switch response.result {
                        case .success(let parsedData):
                            
                            self.loginData = parsedData
                            
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
                (response: DataResponse<User>) in
                switch response.result {
                case .success(let parsedUser):
                    //print("Success: \(parsedUser)")
                    self.user = parsedUser
                    //print(self.user?.email)
                    //print("Success: \(user)")
                    
                    let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
                    let homeViewController = homeStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                    
                    self.navigationController?.pushViewController(homeViewController, animated: true)
                    // navigationController?.setViewControllers([homeViewController], animated: true)
                    
                case .failure(let error):
                    print("API failure: \(error)")
                }
        }
        SVProgressHUD.dismiss()

        
//        let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
//        let homeViewController = homeStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//
//        navigationController?.pushViewController(homeViewController, animated: true)
    }
}


extension UIViewController : UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
