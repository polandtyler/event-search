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
    
    // Set a light status bar tint so that status bar text shows white on the blue background
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // force re-render of the status bar (engages the lightContent var)
        setNeedsStatusBarAppearanceUpdate()
        
        // set a new statusBar in order to change the color
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        statusBarView.backgroundColor = .darkBlue
        view.addSubview(statusBarView)

        // hide the navigation bar for this controller
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        searchBar.delegate = self
        searchResultsTableView.delegate = self
        searchResultsTableView.dataSource = self
        
        searchResultsTableView.estimatedRowHeight = 96
        searchResultsTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func performSearch(searchText: String) {
        // network or database call
    }
}

extension TypeaheadVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Row was selected at \(indexPath)")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

extension TypeaheadVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
}

extension TypeaheadVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

