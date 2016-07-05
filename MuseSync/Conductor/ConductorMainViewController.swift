//
//  ConductorMainViewController.swift
//  MuseSync
//
//  Created by Fan Chen on 7/3/16.
//  Copyright © 2016 Fan Chen. All rights reserved.
//

import UIKit

class ConductorMainViewController: UIViewController {

    @IBOutlet weak var bigButton: UIButton!

    override func viewDidLoad() {

        super.viewDidLoad()
        bigButton.cornerRadius()
        setupPeripheral()
    }

    private func setupPeripheral() {

        PeripheralViewController.sharedInstance
    }
}
