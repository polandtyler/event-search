//
//  TableViewDataSource.swift
//  EventSearch
//
//  Created by Tyler Poland on 7/28/18.
//  Copyright © 2018 Tyler Poland. All rights reserved.
//

import Foundation
import UIKit

extension TypeaheadVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as? EventCell else { return UITableViewCell() }
        cell.configure()
        return cell
    }
    
    
}
