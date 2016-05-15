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
    }

    deinit {
        player?.removeObserver(self, forKeyPath: "status")
        playerItem?.removeObserver(self, forKeyPath: "status")

    }

    func play() {

        guard let url = url else { return }

        let asset = AVURLAsset(URL: url)
        asset.loadValuesAsynchronouslyForKeys(kAssetKeys, completionHandler: { [weak self] () -> Void in

            guard let strongSelf = self where asset.playable else { return }

            for key in strongSelf.kAssetKeys {

                switch key {
                case strongSelf.kAssetDurationKey:
                    dispatch_async(dispatch_get_main_queue(), { [weak self] () -> Void in
                        //self?.playerProtocol?.setupScrubber(asset.duration)
                        })
                    break

                case strongSelf.kAssetPlayableKey:
                    dispatch_async(dispatch_get_main_queue(), { [weak self] () -> Void in
                        strongSelf.playerItem = AVPlayerItem(asset: asset)
                        strongSelf.playerItem!.addObserver(strongSelf, forKeyPath: strongSelf.kObserverKeyPlayerStatus, options: [.New, .Initial], context: &strongSelf.kvoContext)
                        })
                    break

                default:
                    return
                }
            }
            })


//        playerItem = AVPlayerItem(URL: url)
//        playerItem!.addObserver(self, forKeyPath: kObserverKeyPlayerStatus, options: [.New, .Initial], context: &kvoContext)
//        player = AVPlayer(playerItem: playerItem!)
//        player?.addObserver(self, forKeyPath: kObserverKeyPlayerStatus, options: [.New, .Initial], context: &kvoContext)
//        player?.play()
    }

    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {

        print("Change at keyPath = \(keyPath) for \(object), \(change), \(player?.status)")
        guard let player = player else { return }
        print(player.currentItem?.asset.tracks)
        if player.status == AVPlayerStatus.ReadyToPlay {
            player.play()
        }
    }
}
