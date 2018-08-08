//
//  EpDetailsViewController.swift
//  TVShows
//
//  Created by Infinum Student Academy on 02/08/2018.
//  Copyright © 2018 Dunja Acimovic. All rights reserved.
//

import UIKit

class EpDetailsViewController: UIViewController {

    @IBOutlet weak var epImage: UIImageView!
    @IBOutlet weak var epTitle: UILabel!
    @IBOutlet weak var epNumber: UILabel!
    @IBOutlet weak var epDescription: UILabel!
    
    var episodeImageUrl: String?
    var episodeTitle: String?
    var episodeNumber: String = ""
    var seasonNumber: String = ""
    var episodeDescription: String?
    var token: String = ""
    var episodeId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        epTitle.text = episodeTitle
        epNumber.text = "S" + seasonNumber + " Ep" + episodeNumber
        epDescription.text = episodeDescription
        
        guard let imageUrl = self.episodeImageUrl else {
            return
        }
        let url = URL(string: "https://api.infinum.academy" + imageUrl)
        epImage.kf.setImage(with: url)
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    @IBAction func backButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func commentsButtonActionHandler(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let commentsViewController = storyboard.instantiateViewController(withIdentifier: "CommentsViewController") as! CommentsViewController
        commentsViewController.token = token
        commentsViewController.episodeId = episodeId
        
        let navigationController = UINavigationController(rootViewController: commentsViewController)
        
        present(navigationController, animated: true)
    }
}
