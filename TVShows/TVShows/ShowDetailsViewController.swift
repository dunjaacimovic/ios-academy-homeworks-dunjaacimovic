//
//  ShowDetailsViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 28/07/2018.
//  Copyright © 2018 Dunja Acimovic. All rights reserved.
//

import UIKit
import Alamofire
import CodableAlamofire
import SVProgressHUD

class ShowDetailsViewController: UIViewController {

    var showID: String = ""
    var token: String = ""
    private var showDetails: ShowDetails?
    private var episodes: [Episode] = []
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var episodeNumber: UILabel!
    @IBOutlet weak var episodeTableView: UITableView!{
        didSet {
            episodeTableView.dataSource = self
            episodeTableView.delegate = self
            episodeTableView.estimatedRowHeight = 60
        }
    }
    
    @IBOutlet weak var tvShowImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        mockDetails()
        loadDetails()
        self.titleLabel.text = self.showDetails?.title
        self.descriptionLabel.text = self.showDetails?.description
        self.episodeNumber.text = String(self.episodes.count)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        if segue.identifier == "EpDetailsSegue",
            let nextScene = segue.destination as? EpDetailsViewController,
            let indexPath = self.episodeTableView.indexPathForSelectedRow{
            let selectedRow = episodes[indexPath.row]
            nextScene.episodeTitle = selectedRow.title
            nextScene.episodeDescription = selectedRow.description
            nextScene.episodeNumber = selectedRow.episodeNumber
            nextScene.seasonNumber = selectedRow.season
            nextScene.episodeImageUrl = selectedRow.imageUrl
            nextScene.token = token
            nextScene.episodeId = selectedRow.id
        }
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addButtonActionHandler(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let addEpisodeViewController = storyboard.instantiateViewController(withIdentifier: "AddEpViewController") as! AddEpViewController
        addEpisodeViewController.token = token
        addEpisodeViewController.showId = showID
        addEpisodeViewController.delegate = self
        
        let navigationController = UINavigationController(rootViewController: addEpisodeViewController)
    
        present(navigationController, animated: true)
    }
}

private extension ShowDetailsViewController {
    
    func mockDetails() {
        showDetails = ShowDetails(type: "type", title: "title", description: "description", id: "id", likesCount: 5 , imageUrl: "imageUrl")
        episodes = [Episode(id: "id", title: "title", description: "description", imageUrl: "imageUrl", episodeNumber: "3", season: "2"),
                    Episode(id: "id", title: "title", description: "description", imageUrl: "imageUrl", episodeNumber: "4", season: "2"),
                    Episode(id: "id", title: "title", description: "description", imageUrl: "imageUrl", episodeNumber: "5", season: "2"),
                    Episode(id: "id", title: "title", description: "description", imageUrl: "imageUrl", episodeNumber: "6", season: "2"),
                    Episode(id: "id", title: "title", description: "description", imageUrl: "imageUrl", episodeNumber: "7", season: "2"),
                    Episode(id: "id", title: "title", description: "description", imageUrl: "imageUrl", episodeNumber: "8", season: "2"),
                    Episode(id: "id", title: "title", description: "description", imageUrl: "imageUrl", episodeNumber: "9", season: "2"),
                    Episode(id: "id", title: "title", description: "description", imageUrl: "imageUrl", episodeNumber: "10", season: "2"),
                    Episode(id: "id", title: "title", description: "description", imageUrl: "imageUrl", episodeNumber: "11", season: "2"),
                    Episode(id: "id", title: "title", description: "description", imageUrl: "imageUrl", episodeNumber: "12", season: "2"),
                    Episode(id: "id", title: "title", description: "description", imageUrl: "imageUrl", episodeNumber: "13", season: "2")]
    }
    
    func loadDetails() {
        let showUrl: String = "https://api.infinum.academy/api/shows/" + showID
        let headers = ["Authorization": token]

        SVProgressHUD.show()
        Alamofire
            .request(showUrl,
                     method: .get,
                     encoding: JSONEncoding.default,
                     headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (response: DataResponse<ShowDetails>) in
                guard let `self` = self else { return }
                switch response.result {
                case .success(let parsedData):
                    
                    self.showDetails = parsedData
                    self.titleLabel.text = self.showDetails?.title
                    self.titleLabel.text = self.showDetails?.description
                    self.loadEpisodes()
                    
                    guard let imageUrl = self.showDetails?.imageUrl else {
                        return
                    }
                    let url = URL(string: "https://api.infinum.academy" + imageUrl)
                    self.tvShowImageView.kf.setImage(with: url)
                    
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
    
    func loadEpisodes() {
        let showUrl: String = "https://api.infinum.academy/api/shows/" + showID
        let episodesUrl: String = showUrl + "/episodes"
        let headers = ["Authorization": token]

        Alamofire
            .request(episodesUrl,
                     method: .get,
                     encoding: JSONEncoding.default,
                     headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (response: DataResponse<[Episode]>) in
                guard let `self` = self else { return }
                switch response.result {
                case .success(let parsedData):
                    
                    self.episodes = parsedData
                    self.episodeNumber.text = String(self.episodes.count)
                    self.episodeTableView.reloadData()
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


extension ShowDetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}

extension ShowDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeTableViewCell", for: indexPath) as! EpisodeTableViewCell
        let item = episodes[indexPath.row]
        cell.configure(with: item)
        
        return cell
    }
}

extension ShowDetailsViewController: AddEpViewControllerDelegate {
    func reloadIsNeeded(_ reloadNeeded: Bool?){
        if (reloadNeeded == true){
            loadEpisodes()
        }
    }
}
   


