//
//  PlayerManager.swift
//  MuseSync
//
//  Created by Fan Chen on 5/15/16.
//  Copyright © 2016 Fan Chen. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class PlayerController: NSObject {

    private var kvoContext: UInt8 = 1

    var playerItem:AVPlayerItem?
    var player:AVPlayer?


    var url: NSURL?
    let kObserverKeyPlayerStatus = "status"
    let kAssetKeys = ["duration", "playable"]
    let kAssetDurationKey = "duration"
    let kAssetPlayableKey = "playable"

    // MARK: - Lifecycle
    override init() {

        super.init()
        let url = NSURL(string: "https://s3.amazonaws.com/kargopolov/BlueCafe.mp3")
        playerItem = AVPlayerItem(URL: url!)
        player=AVPlayer(playerItem: playerItem!)
        player?.addObserver(self, forKeyPath: kObserverKeyPlayerStatus, options: [.New, .Initial], context: &kvoContext)
    }

    deinit {

        player?.removeObserver(self, forKeyPath: "status")
        playerItem?.removeObserver(self, forKeyPath: "status")
        print("player died.")
    }

    func playOrPause() {
        if player?.rate == 0
        {
            player!.play()
            //   playButton.setImage(UIImage(named: "player_control_pause_50px.png"), forState: UIControlState.Normal)
        } else {
            player!.pause()
            //    playButton.setImage(UIImage(named: "player_control_play_50px.png"), forState: UIControlState.Normal)
        }

    }

    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {

        // guard let player = player else { return }
        if player!.status == AVPlayerStatus.ReadyToPlay {
            // player!.play()
            print("...and we are ready to play..")
        }
    }
}
