//
//  LoginViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 08/07/2018.
//  Copyright © 2018 Dunja Acimovic. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var checkboxButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    private var isBoxChecked: Bool!
    
    
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
        let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let homeViewController = homeStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        
        navigationController?.pushViewController(homeViewController, animated: true)
        // navigationController?.setViewControllers([homeViewController], animated: true)
    }
}

extension UIViewController : UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
