//
//  SingerPlayerViewController.swift
//  MuseSync
//
//  Created by Fan Chen on 7/4/16.
//  Copyright © 2016 Fan Chen. All rights reserved.
//

import UIKit

class SingerPlayerViewController: UIViewController {

    private var playerController: PlayerController?

    override func viewDidLoad() {

        super.viewDidLoad()
        setupUI()
        setupPlayer()
        addObservers()
    }

    deinit {
        removeObservers()
    }

    private func setupUI() {

    }

    private func setupPlayer() {

        playerController = PlayerController()
    }

    private func addObservers() {

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SingerPlayerViewController.onCharacteristicUpdated(_:)), name: CentralViewController.kCharacteristicValueUpdatedNotification, object: nil)
    }

    private func removeObservers() {

        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    @objc private func onCharacteristicUpdated(notification: NSNotification) {

        guard let info = notification.userInfo?[CentralViewController.kCharacteristicNotificationInfo] as? Bool
            else { return }
        NSLog("SingerPlayerViewController" + "\(info)")
        playerController?.playOrPause()
    }
}
