//
//  ConductorSelectSongViewController.swift
//  MuseSync
//
//  Created by Fan Chen on 7/3/16.
//  Copyright © 2016 Fan Chen. All rights reserved.
//

import UIKit

class ConductorSelectSongViewController: UITableViewController {

    let data = ["Love on top", "Mercy", "I want you back"]

}

// MARK: - UITableViewDataSource
extension ConductorSelectSongViewController {

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return data.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = UITableViewCell()
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ConductorSelectSongViewController {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        ConductorPlayerViewController.presentScreen(data[indexPath.row], fromController: self)
    }
}
