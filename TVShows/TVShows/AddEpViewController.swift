//
//  AddEpViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 30/07/2018.
//  Copyright © 2018 Dunja Acimovic. All rights reserved.
//

import UIKit
import Alamofire
import CodableAlamofire

protocol AddEpViewControllerDelegate: class {
    func reloadIsNeeded(_ reloadNeeded: Bool?)
}

class AddEpViewController: UIViewController {
    

    var showId: String = ""
    var token: String = ""
    
    @IBOutlet weak var epTitleTextField: UITextField!
    @IBOutlet weak var seasonNumberTextField: UITextField!
    @IBOutlet weak var epNumberTextField: UITextField!
    @IBOutlet weak var epDescriptionTextField: UITextField!
    
    weak var delegate: AddEpViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        let navigationController = UINavigationController.init(rootViewController: AddEpViewController)
//        present(navigationController, animated: true, completion: nil)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didSelectCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(didSelectAddShow))
    }
    
    
    @objc func didSelectCancel() {
        dismiss(animated: true)
    }
    
    @objc func didSelectAddShow() {
        
        let parameters: [String: String] = [
            "showId": showId,
            "mediaId": "",
            "title": epTitleTextField.text!,
            "description": epDescriptionTextField.text!,
            "episodeNumber": epNumberTextField.text!,
            "season": seasonNumberTextField.text!
        ]
        
        let headers = ["Authorization": token]
        
        Alamofire
                    .request("https://api.infinum.academy/api/episodes",
                             method: .post,
                             parameters: parameters,
                             encoding: JSONEncoding.default,
                             headers: headers)
                    .validate()
                    .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { (response: DataResponse<Episode>) in
                        switch response.result {
                        case .success(let passedData):
        
                            self.delegate?.reloadIsNeeded(true)
                            self.dismiss(animated: true)
                        case .failure(let error):
                            let alertController = UIAlertController(title: "Data reaching error", message: "Could not show data.", preferredStyle: .alert)
                            let action1 = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
                                print("You've pressed cancel");
                            }
                            alertController.addAction(action1)
                            self.present(alertController, animated: true)
                        }
                    }
    }
}

//extension UIViewController : UITextFieldDelegate {
//
//    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//}
