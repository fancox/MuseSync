//
//  PlaySongViewController.swift
//  MuseSync
//
//  Created by Fan Chen on 7/3/16.
//  Copyright © 2016 Fan Chen. All rights reserved.
//

import UIKit

class PlaySongViewController: UIViewController {

    var songTitle: String?

    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!

    override func viewDidLoad() {

        super.viewDidLoad()
        playButton.cornerRadius()
        pauseButton.cornerRadius()
        title = songTitle
    }

    // MARK: - Presentation
    static func presentScreen(withSongTitle: String, fromController: UIViewController) {
        guard
            let navigationController = fromController.navigationController,
            let controller = UIViewController.loadViewControllerFromStoryboard(PlaySongViewController)
            else { return }

        controller.songTitle = withSongTitle
        navigationController.pushViewController(controller, animated: true)
    }
}


