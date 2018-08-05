//
//  HomeViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 18/07/2018.
//  Copyright © 2018 Dunja Acimovic. All rights reserved.
//

import UIKit
import Alamofire
import CodableAlamofire
import SVProgressHUD



class HomeViewController: UIViewController {
    
    private var TVShows: [TVShow] = []
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.estimatedRowHeight = 60
        }
    }
    private var _token: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        loadShows(token: _token)
        
        let logoutItem = UIBarButtonItem.init(image: UIImage(named: "ic-logout"),
                                              style: .plain,
                                              target: self,
                                              action: #selector(_logoutActionHandler))
        navigationItem.leftBarButtonItem = logoutItem
    }
    
    @objc private func _logoutActionHandler() {
        UserDefaults.standard.removeObject(forKey: "TVShows.email")
        UserDefaults.standard.removeObject(forKey: "TVShows.password")

        
        let loginStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let loginViewController = loginStoryboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        
        navigationController?.pushViewController(loginViewController, animated: true)
    }
    
}

extension HomeViewController {
    
    func configure(with token: String) {
        _token = token
    }
}

private extension HomeViewController {
    
    func loadShows(token: String) {
        SVProgressHUD.show()
        let headers = ["Authorization": token]
        
        Alamofire
            .request("https://api.infinum.academy/api/shows",
                     method: .get,
                     encoding: JSONEncoding.default,
                     headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data") { [weak self] (response: DataResponse<[TVShow]>) in
                SVProgressHUD.dismiss()

                guard let `self` = self else { return }

                switch response.result {
                case .success(let parsedData):
                    
                    self.TVShows = parsedData
                    self.tableView.reloadData()
                case .failure:
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


extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TVShows.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "IndexPathTableViewCell", for: indexPath) as! IndexPathTableViewCell
        let itemTVShow = TVShows[indexPath.row]
        cell.configure(with: itemTVShow)
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.performSegue(withIdentifier: "ShowDetailsSegue", sender: self)
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "ShowDetailsSegue",
        let nextScene = segue.destination as? ShowDetailsViewController,
        let indexPath = self.tableView.indexPathForSelectedRow{
            let selectedRow = TVShows[indexPath.row]
            nextScene.showID = selectedRow.id
            nextScene.token = _token
        }
    }
}


