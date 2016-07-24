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

protocol PlayerControllerDelegate {

    func onPlayerReady()
    func onPlayerPlayed()
    func onPlayerPaused()
}

class PlayerController: NSObject {

    private var kvoContext: UInt8 = 1

    var playerItem:AVPlayerItem?
    var player:AVPlayer?
    var delegate: PlayerControllerDelegate?

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
       // playerItem?.removeObserver(self, forKeyPath: "status")
        print("player died.")
    }

    func playOrPause(atDate date: NSDate) {

        let timer = NSTimer(fireDate: date, interval: 0.0, target: self, selector: #selector(PlayerController.timerFireMethod(_:)), userInfo: nil, repeats: false)
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
        print("Set up timer:" + "\(NSDate().timeIntervalSinceReferenceDate * 1000)")
    }

    func timerFireMethod(timer: NSTimer) {

        print("Timer fired:" + "\(NSDate().timeIntervalSinceReferenceDate * 1000)")
        if player?.rate == 0 {
            player!.play()
            delegate?.onPlayerPlayed()
        } else {
            player!.pause()
            delegate?.onPlayerPaused()
        }
    }

    func isPlaying() -> Bool {

        guard let player = player else { return false }
        return player.rate != 0
    }

    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {

        // guard let player = player else { return }
        if player!.status == AVPlayerStatus.ReadyToPlay {
            // player!.play()
            print("...and we are ready to play..")
            delegate?.onPlayerReady()
        }
    }
}
