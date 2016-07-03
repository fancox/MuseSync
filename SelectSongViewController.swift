//
//  SelectSongViewController.swift
//  MuseSync
//
//  Created by Fan Chen on 7/3/16.
//  Copyright © 2016 Fan Chen. All rights reserved.
//

import UIKit

class SelectSongViewController: UITableViewController {

    let data = ["Love on top", "Mercy", "I want you back"]

}

// MARK: - UITableViewDataSource
extension SelectSongViewController {

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 1
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = UITableViewCell()
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SelectSongViewController {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        PlaySongViewController.presentScreen(data[indexPath.row], fromController: self)
    }
}
