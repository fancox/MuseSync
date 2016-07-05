//
//  SingerJoinSessionViewController.swift
//  MuseSync
//
//  Created by Fan Chen on 5/1/16.
//  Copyright © 2016 Fan Chen. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth

class SingerJoinSessionViewController: UIViewController {


    @IBOutlet weak var joinSessionLabel: UILabel!
    @IBOutlet weak var joinButton: UIButton!

    override func viewDidLoad() {

        super.viewDidLoad()
        joinButton.cornerRadius()
        setupCentral()
    }

    private func setupCentral() {

        CentralViewController.sharedInstance
    }

    @IBAction func didTapJoin(sender: AnyObject) {

        CentralViewController.sharedInstance.joinASession()
    }
}