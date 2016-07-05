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

class PeripheralViewController: NSObject {

    static let sharedInstance = PeripheralViewController()

    private var peripheralManager: CBPeripheralManager?
    private var service: CBMutableService?
    private var characteristic: CBMutableCharacteristic?


    private override init() {
        super.init()
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
    }

    deinit {
        print("PeripheralViewController died")
    }

    // MARK: - Public Methods
    func onPeripheralPoweredOn() {

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

    func updateCentrals(shouldPlay shouldPlay: Bool) {

        guard let peripheralManager = peripheralManager,
            characteristic = characteristic  else { return }


        if let data = NSString(string: shouldPlay.description)
            .dataUsingEncoding(NSUTF8StringEncoding) {
            peripheralManager.updateValue(data, forCharacteristic: characteristic, onSubscribedCentrals: nil)
        }
    }


    //    // Private methods
    //    private func updateCentralsWithMessage(message: String) {
    //
    //        guard let peripheralManager = peripheralManager,
    //            characteristic = characteristic  else { return }
    //
    //        if let data = NSString(string: String(format: "%@. (%@)", message, NSDate().descriptionWithLocale(NSLocale.currentLocale())))
    //            .dataUsingEncoding(NSUTF8StringEncoding) {
    //            peripheralManager.updateValue(data, forCharacteristic: characteristic, onSubscribedCentrals: nil)
    //        }
    //    }

}

extension PeripheralViewController: CBPeripheralManagerDelegate {

    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager) {

        NSLog("The peripheral state is " + "\(peripheral.state.rawValue)")
        onPeripheralPoweredOn()
    }

    func peripheralManager(peripheral: CBPeripheralManager, didAddService service: CBService, error: NSError?) {

        NSLog("Did Add service " + "\(service)")
    }

    func peripheralManagerDidStartAdvertising(peripheral: CBPeripheralManager, error: NSError?) {

        NSLog("Did start advertising " + "\(peripheral)")
    }

    func peripheralManager(peripheral: CBPeripheralManager, didReceiveReadRequest request: CBATTRequest) {

        NSLog("Did received read request.")
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

          NSLog("didSubscribeToCharacteristic " + "\(central)")
    }
}