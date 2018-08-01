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
    @IBOutlet weak var eventImage: UIImageView!
    
    func configure() {
        titleLabel.text = "Test Successful"
        locationLabel.text = "Test Successful"
        dateTimeLabel.text = "Test Successful"
        eventImage.backgroundColor = .blue
    }
    
}
