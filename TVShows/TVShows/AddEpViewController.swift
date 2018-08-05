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
    weak var delegate: AddEpViewControllerDelegate?
    var tvShowImage: UIImage?
    var mediaId: String = ""

    @IBOutlet weak var epTitleTextField: UITextField!
    @IBOutlet weak var seasonNumberTextField: UITextField!
    @IBOutlet weak var epNumberTextField: UITextField!
    @IBOutlet weak var epDescriptionTextField: UITextField!
    
    
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
        uploadImageOnAPI(token: token)
    }
        
        
    
    
    @IBAction func uploadImageButtonTapped(_ sender: UIButton) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK:  - UIImagePickerControllerDelegate

}

//MARK: - API calls

extension AddEpViewController {
    
    func uploadImageOnAPI(token: String) {
        let headers = ["Authorization": token]
        let imageByteData = UIImagePNGRepresentation(tvShowImage!)!
        Alamofire
            .upload(multipartFormData: { multipartFormData in
                multipartFormData.append(imageByteData,
                                         withName: "file",
                                         fileName: "image.png",
                                         mimeType: "image/png")
            }, to: "https://api.infinum.academy/api/media",
               method: .post,
               headers: headers){ [weak self] result in
                switch result {
                case .success(let uploadRequest, _, _):
                    self?.processUploadRequest(uploadRequest)
                case .failure(let encodingError):
                    print(encodingError)
                }
            }
    }
    
    func processUploadRequest(_ uploadRequest: UploadRequest) {
            uploadRequest
                .responseDecodableObject(keyPath: "data") { [weak self](response:
                    DataResponse<Media>) in
                    guard let `self` = self else { return }
                    
                switch response.result {
                case .success(let media):
                    self.mediaId = media.id
                    self.addEpisode()
                case .failure(let error):
                    print("FAILURE: \(error)")
                }
            }
    }
    
    func addEpisode(){
        
        let parameters: [String: String] = [
            "showId": showId,
            "mediaId": mediaId,
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
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (response: DataResponse<Episode>) in
                guard let `self` = self else { return }
                
                switch response.result {
                case .success(_):
                    self.delegate?.reloadIsNeeded(true)
                    self.dismiss(animated: true)
                case .failure(_):
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

extension AddEpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            tvShowImage = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
}
