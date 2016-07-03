//
//  HelloViewController.swift
//  MuseSync
//
//  Created by Fan Chen on 7/3/16.
//  Copyright © 2016 Fan Chen. All rights reserved.
//

import UIKit

class HelloViewController: UIViewController {

    @IBOutlet weak var bigButton: UIButton!

    override func viewDidLoad() {

        super.viewDidLoad()
        bigButton.cornerRadius()
    }
}
