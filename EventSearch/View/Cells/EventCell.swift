//
//  EventCell.swift
//  EventSearch
//
//  Created by Tyler Poland on 7/28/18.
//  Copyright © 2018 Tyler Poland. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.textColor = .boldText
        locationLabel.textColor = .lightText
        dateTimeLabel.textColor = .lightText
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
