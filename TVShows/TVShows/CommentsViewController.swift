//
//  CommentsViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 02/08/2018.
//  Copyright © 2018 Dunja Acimovic. All rights reserved.
//

import UIKit
import Alamofire
import CodableAlamofire
import SVProgressHUD

class CommentsViewController: UIViewController {

    var token: String = ""
    var episodeId: String = ""
    var comments: [Comment] = []
    
    @IBOutlet weak var commentsTableView: UITableView!{
        didSet {
            commentsTableView.dataSource = self
            commentsTableView.delegate = self
            commentsTableView.estimatedRowHeight = 60
//            commentsTableView.rowHeight = UITableViewAutomaticDimension
        }
    }
    
    @IBOutlet weak var addCommentTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        SVProgressHUD.show()
        
        loadComments()
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
    
            self.view.frame.origin.y = -(keyboardHeight)// Move view upward
            }
        
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0 // Move view to original position
    }

    @IBAction func backButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func postButton(_ sender: UIButton) {
        
        let parameters: [String : String] = [
            "text": addCommentTextField.text!,
            "episodeId": episodeId]
        let headers = ["Authorization": token]
        
        Alamofire.request("https://api.infinum.academy/api/comments",
                          method: .post,
                          parameters: parameters,
                          encoding: JSONEncoding.default,
                          headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()){[weak self] (response: DataResponse<CommentPostResponse>) in
                guard let `self` = self else { return }
                    switch response.result {
                    case .success:
                        self.loadComments()
                        self.addCommentTextField.text = ""
    
                    case .failure:
                        let alertController = UIAlertController(title: "Comment error", message: "Could not post comment.", preferredStyle: .alert)
                        let action1 = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
                            print("You've pressed cancel");
                        }
                        alertController.addAction(action1)
                        self.present(alertController, animated: true)
                    }
    
                    SVProgressHUD.dismiss()
        }
        
    }
}

extension CommentsViewController{
    
    func loadComments(){
        
        let commentsUrl: String = "https://api.infinum.academy/api/episodes/" + episodeId +  "/comments"
        let headers = ["Authorization": token]
        
        Alamofire
            .request(commentsUrl,
                     method: .get,
                     encoding: JSONEncoding.default,
                     headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (response: DataResponse<[Comment]>) in
                guard let `self` = self else { return }
                switch response.result {
                case .success(let parsedData):
                    self.comments = parsedData
                    self.commentsTableView.reloadData()
                    
                case .failure:
                    let alertController = UIAlertController(title: "Data reaching error", message: "Could not show data.", preferredStyle: .alert)
                    let action1 = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
                        print("You've pressed cancel");
                    }
                    alertController.addAction(action1)
                    self.present(alertController, animated: true)
                }
                
                SVProgressHUD.dismiss()
        }
    }
}

extension CommentsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    
}

extension CommentsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsTableViewCell", for: indexPath) as! CommentsTableViewCell
        let item = comments[indexPath.row]
        cell.configure(with: item)
        
        return cell
    }
}

