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

class PeripheralViewController: UIViewController {

    private var peripheralManager: CBPeripheralManager?
    private var service: CBMutableService?
    private var characteristic: CBMutableCharacteristic?

    override func viewDidLoad() {

        super.viewDidLoad()
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
    }

    @IBAction func didTapAddService(sender: AnyObject) {

        guard let peripheralManager = peripheralManager else { return }
        let data = NSString(string: String("pig flies at @%", NSDate())).dataUsingEncoding(NSUTF8StringEncoding)
        characteristic = CBMutableCharacteristic(type: Constants.kCharacteristicUUID, properties: .Read, value: data, permissions: .Readable)
        service = CBMutableService(type: Constants.kUUID, primary: true)
        service!.characteristics = [characteristic!]
        peripheralManager.addService(service!)
    }

    @IBAction func didTapStartAdvertising(sender: AnyObject) {

        guard let peripheralManager = peripheralManager else { return }
        peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey: [Constants.kUUID]])
    }

    @IBAction func didTapStopAdvertising(sender: AnyObject) {

        peripheralManager?.stopAdvertising()
    }

    @IBAction func didTapRemoveService(sender: AnyObject) {

        peripheralManager?.removeAllServices()
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
}
