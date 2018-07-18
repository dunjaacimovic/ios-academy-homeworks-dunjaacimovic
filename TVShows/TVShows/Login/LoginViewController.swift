//
//  LoginViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 08/07/2018.
//  Copyright © 2018 Dunja Acimovic. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var checkbox: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    private var isBoxChecked: Bool!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isBoxChecked = false
        
    }

    @IBAction func boxTapped(_ sender: Any) {
     
        if isBoxChecked == true {
            isBoxChecked = false
        }else{
            isBoxChecked = true
        }
        
        if isBoxChecked == true{
            checkbox.setImage(UIImage(named: "ic-checkbox-filled"), for: UIControlState.normal)
        }else{
            checkbox.setImage(UIImage(named: "ic-checkbox-empty"), for: UIControlState.normal)
        }
    }
    
   
}
