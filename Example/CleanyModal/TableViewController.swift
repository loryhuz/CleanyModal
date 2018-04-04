//
//  TableViewController.swift
//  CleanyModal_Example
//
//  Created by Lory Huz on 02/04/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        cell.textLabel?.text = "Title N°\(indexPath.row)"
        cell.detailTextLabel?.text = "Subtitle N°\(indexPath.row)"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.parent?.dismiss(animated: true, completion: nil)
    }
}
