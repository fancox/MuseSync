//
//  ConductorPlayerViewController.swift
//  MuseSync
//
//  Created by Fan Chen on 7/3/16.
//  Copyright © 2016 Fan Chen. All rights reserved.
//

import AVFoundation
import CoreBluetooth
import UIKit

class ConductorPlayerViewController: UIViewController {

    var songTitle: String?

    @IBOutlet weak var playButton: UIButton!

    let kSecToDelay: NSTimeInterval = 0.5

    private var playerController: PlayerController?

    override func viewDidLoad() {

        super.viewDidLoad()
        setupUI()
        setupPlayer()
    }

    private func setupUI() {

        playButton.cornerRadius()
        playButton.enabled = false
        playButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        playButton.setTitleColor(UIColor.grayColor(), forState: .Disabled)
        title = songTitle
    }

    private func setupPlayer() {

        playerController = PlayerController()
        playerController?.delegate = self
    }

    // MARK: - IBActions
    @IBAction func didTapPlay(sender: AnyObject) {

        guard let playerController = playerController else { return }
        playButton.enabled = false
        let playDate = NSDate(timeIntervalSinceNow: kSecToDelay)
        playerController.playOrPause(atDate: playDate)
        PeripheralViewController.sharedInstance.updateCentrals(timestamp: playDate)
    }

    // MARK: - Presentation
    static func presentScreen(withSongTitle: String, fromController: UIViewController) {
        guard
            let navigationController = fromController.navigationController,
            let controller = UIViewController.loadViewControllerFromStoryboard(ConductorPlayerViewController)
            else { return }

        controller.songTitle = withSongTitle
        navigationController.pushViewController(controller, animated: true)
    }
}

extension ConductorPlayerViewController: PlayerControllerDelegate {

    func onPlayerReady() {

        playButton.enabled = true
    }

    func onPlayerPlayed() {

        playButton.enabled = true
        playButton.setImage(UIImage(named: "Pause"), forState: .Normal)
    }

    func onPlayerPaused() {

        playButton.enabled = true
        playButton.setImage(UIImage(named: "Play"), forState: .Normal)
    }
}
