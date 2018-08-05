
//
//  CommentsTableViewCell.swift
//  TVShows
//
//  Created by Infinum Student Academy on 02/08/2018.
//  Copyright © 2018 Dunja Acimovic. All rights reserved.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        usernameLabel.text = nil
        commentLabel.text = nil
    }
    
    func configure(with item: Comment){
        usernameLabel.text = item.userEmail
        commentLabel.text = item.text
    }
}
