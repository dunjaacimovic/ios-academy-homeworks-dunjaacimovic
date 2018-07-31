//
//  IndexPathTableViewCell.swift
//  TVShows
//
//  Created by Infinum Student Academy on 26/07/2018.
//  Copyright © 2018 Dunja Acimovic. All rights reserved.
//

import Foundation
import Kingfisher

import UIKit

//struct IndexPathItem{
//    let tvShow: TVShow
//    let index: IndexPath
//}

class IndexPathTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var indexPathLabel: UILabel!
    @IBOutlet weak var tvShowImageView: UIImageView!
    
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        indexPathLabel.text = nil
    }
    
    func configure(with item: TVShow){
        indexPathLabel.text = item.title
        
        let url = URL(string: "https://api.infinum.academy" + item.imageUrl)
        tvShowImageView.kf.setImage(with: url)
        
    }
}
