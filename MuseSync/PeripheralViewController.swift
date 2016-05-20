//
//  PeripheralViewController.swift
//  MuseSync
//
//  Created by Fan Chen on 5/1/16.
//  Copyright © 2016 Fan Chen. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth
import AVFoundation

class PeripheralViewController: UIViewController {

    private var peripheralManager: CBPeripheralManager?
    private var service: CBMutableService?
    private var characteristic: CBMutableCharacteristic?
    private var playerController: PlayerController?

    @IBOutlet weak var textLabel: UILabel!

    override func viewDidLoad() {

        super.viewDidLoad()
        playerController = PlayerController()
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
    }

    // Private methods
    private func updateCentralsWithMessage(message: String) {

        guard let peripheralManager = peripheralManager,
            characteristic = characteristic  else { return }

        if let data = NSString(string: String(format: "%@. (%@)", message, NSDate().descriptionWithLocale(NSLocale.currentLocale())))
            .dataUsingEncoding(NSUTF8StringEncoding) {
            peripheralManager.updateValue(data, forCharacteristic: characteristic, onSubscribedCentrals: nil)
        }
    }

    private func updateCentralsWithMusicInstruction(message: String) {

        guard let peripheralManager = peripheralManager,
            characteristic = characteristic  else { return }

        if let data = NSString(string: message)
            .dataUsingEncoding(NSUTF8StringEncoding) {
            peripheralManager.updateValue(data, forCharacteristic: characteristic, onSubscribedCentrals: nil)
        }
    }


    // IBActions
    @IBAction func didTapStart(sender: AnyObject) {

        // UI change
        textLabel.text = "Started!"

        // set up service and characteristic
        guard let peripheralManager = peripheralManager else { return }
        characteristic = CBMutableCharacteristic(type: Constants.kCharacteristicUUID, properties: [.Read, .Notify], value: nil, permissions: .Readable)
        service = CBMutableService(type: Constants.kUUID, primary: true)
        service!.characteristics = [characteristic!]
        // add service
        peripheralManager.addService(service!)
        // start advertising
        peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey: [Constants.kUUID]])
    }

    @IBAction func didTapPause(sender: AnyObject) {

        updateCentralsWithMessage("Let's pause for a bit.")
    }

    @IBAction func didTapStop(sender: AnyObject) {

        // UI change
        textLabel.text = "Stopped!"

        // stop advertising and service
        peripheralManager?.stopAdvertising()
        peripheralManager?.removeAllServices()
    }

    // Music playing related

    @IBAction func didTapPlay(sender: AnyObject) {

        playerController?.playOrPause()
        updateCentralsWithMusicInstruction("play")
    }

    @IBAction func didTapPauseMusic(sender: AnyObject) {

        playerController?.playOrPause()
        updateCentralsWithMusicInstruction("pause")
    }
}

extension PeripheralViewController: CBPeripheralManagerDelegate {

    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager) {

        print("The peripheral state is @%", peripheral.state)
    }

    func peripheralManager(peripheral: CBPeripheralManager, didAddService service: CBService, error: NSError?) {

        print("Did Add service @%", service)
    }

    func peripheralManagerDidStartAdvertising(peripheral: CBPeripheralManager, error: NSError?) {

        print("Did start advertising @%", peripheral)
    }

    func peripheralManager(peripheral: CBPeripheralManager, didReceiveReadRequest request: CBATTRequest) {

        guard let peripheralManager = peripheralManager,
            characteristic = characteristic,
            value = characteristic.value else { return }
        if request.characteristic.UUID == Constants.kCharacteristicUUID {
            if (request.offset > characteristic.value?.length) {
                peripheralManager.respondToRequest(request, withResult: CBATTError.InvalidOffset)
                return
            }
            request.value = value.subdataWithRange(NSMakeRange(request.offset, value.length - request.offset))
            peripheralManager.respondToRequest(request, withResult: CBATTError.Success)
        }
    }

    func peripheralManager(peripheral: CBPeripheralManager, central: CBCentral, didSubscribeToCharacteristic characteristic: CBCharacteristic) {

        updateCentralsWithMessage("Start rock n roll!")
    }
    
    func peripheralManagerIsReadyToUpdateSubscribers(peripheral: CBPeripheralManager) {
        
        
    }
    
}
