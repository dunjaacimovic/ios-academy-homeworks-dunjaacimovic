//
//  EpisodeTableViewCell.swift
//  TVShows
//
//  Created by Infinum Student Academy on 30/07/2018.
//  Copyright © 2018 Dunja Acimovic. All rights reserved.
//

import UIKit

class EpisodeTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var episodeLabel: UILabel!
    @IBOutlet weak var episodeTitleLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        episodeLabel.text = nil
        episodeTitleLabel.text = nil
    }
    
    func configure(with item: Episode){
        episodeLabel.text = "S" + item.season + " Ep" + item.episodeNumber
        episodeTitleLabel.text = item.title
    }
}
