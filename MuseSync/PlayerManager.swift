//
//  PlayerManager.swift
//  MuseSync
//
//  Created by Fan Chen on 5/15/16.
//  Copyright © 2016 Fan Chen. All rights reserved.
//

import Foundation
import AVFoundation

class PlayerManager: NSObject {

    private var kvoContext: UInt8 = 1

    var playerItem:AVPlayerItem?
    var player:AVPlayer?
    var url: NSURL?
    let kObserverKeyPlayerStatus = "status"
    let kAssetKeys = ["duration", "playable"]
    let kAssetDurationKey = "duration"
    let kAssetPlayableKey = "playable"


    init (urlString: String) {

        url = NSURL(string: urlString)
        AVAudioSession.sharedInstance()
    }

    deinit {

        player?.removeObserver(self, forKeyPath: "status")
        playerItem?.removeObserver(self, forKeyPath: "status")
        print("player died.")
    }

    func play() {

        guard let url = url else { return }
        player = AVPlayer(URL: url)
        player?.addObserver(self, forKeyPath: kObserverKeyPlayerStatus, options: [.New, .Initial], context: &kvoContext)
    }

    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {

        // guard let player = player else { return }
        if player!.status == AVPlayerStatus.ReadyToPlay {
            player!.play()
            print("...and we are playing..")
        }
    }
}
