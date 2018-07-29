//
//  DarkSearchBar.swift
//  EventSearch
//
//  Created by Tyler Poland on 7/28/18.
//  Copyright © 2018 Tyler Poland. All rights reserved.
//

import UIKit

class CustomSearchBar: UISearchBar {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        // Without setting both barTint and background colors,
        // the background color renders significantly lighter than the status bar color.
        barTintColor = .darkBlue
        backgroundColor = .darkBlue
        tintColor = .white
        
        // Sets the interior search text field to a lighter blue shade
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = .lightBlueSearchBackground

        
        showsCancelButton = true
    }
}
