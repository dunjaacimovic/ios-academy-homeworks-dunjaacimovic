//
//  IndexPathTableViewCell.swift
//  TVShows
//
//  Created by Infinum Student Academy on 26/07/2018.
//  Copyright © 2018 Dunja Acimovic. All rights reserved.
//

import Foundation

import UIKit

//struct IndexPathItem{
//    let tvShow: TVShow
//    let index: IndexPath
//}

class IndexPathTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var indexPathLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        indexPathLabel.text = nil
    }
    
    func configure(with item: TVShow){
        indexPathLabel.text = item.title
    }
}
