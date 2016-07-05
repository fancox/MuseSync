//
//  WelcomeViewController.swift
//  MuseSync
//
//  Created by Fan Chen on 7/3/16.
//  Copyright © 2016 Fan Chen. All rights reserved.
//

import UIKit

public class WelcomeViewController: UIViewController {

    @IBOutlet weak var conductorButton: UIButton!
    @IBOutlet weak var singerButton: UIButton!


    override public func viewDidLoad() {

        super.viewDidLoad()
        conductorButton.cornerRadius()
        singerButton.cornerRadius()
    }
}
