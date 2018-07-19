//
//  LoginViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 08/07/2018.
//  Copyright © 2018 Dunja Acimovic. All rights reserved.
//

import UIKit
import Alamofire

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        isBoxChecked = false
        loginButton.layer.cornerRadius = 5
        
        let parameters: [String: String] = [
            "email": email,
            "password": password
        ]
        Alamofire.request("https://api.infinum.academy/api/users", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseDecodableObject(keyPath: "data", decoder: JSONDecoder()){
                (response: DataResponse<User>) in
            switch response.result {
                case .success(let user):
                    print("Success: \(user)")
                case .failure(let error):
                    print("API failure: \(error)")
            }
        }
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
        let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let homeViewController = homeStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        
        navigationController?.pushViewController(homeViewController, animated: true)
        // navigationController?.setViewControllers([homeViewController], animated: true)
    }
    
    
    @IBAction private func createAccountActionHandler() {
        let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let homeViewController = homeStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        
        navigationController?.pushViewController(homeViewController, animated: true)
    }
}


extension UIViewController : UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
