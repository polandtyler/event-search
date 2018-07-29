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
        let interiorSearchField = self.value(forKey: "searchField") as? UITextField
        let glassIconView = interiorSearchField?.leftView as? UIImageView
        
        
        barTintColor = .darkBlue
        tintColor = .white
        glassIconView?.tintColor = .white
        interiorSearchField?.backgroundColor = .lightBlueSearchBackground
        
        showsCancelButton = true
    }
}
