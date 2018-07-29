//
//  TypeaheadVC.swift
//  EventSearch
//
//  Created by Tyler Poland on 7/28/18.
//  Copyright © 2018 Tyler Poland. All rights reserved.
//

import UIKit

class TypeaheadVC: UIViewController {

    @IBOutlet weak var searchBar: CustomSearchBar!
    @IBOutlet weak var searchResultsTableView: UITableView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNeedsStatusBarAppearanceUpdate()
        UIApplication.shared.statusBarView?.backgroundColor = .darkBlue
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func performSearch(searchText: String) {
        // network or database call
        searchResultsTableView.reloadData()
    }



}

extension TypeaheadVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
}

extension TypeaheadVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchBar.text
    }
    
    
}

