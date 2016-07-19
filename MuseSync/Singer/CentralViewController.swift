//
//  CentralViewController.swift
//  MuseSync
//
//  Created by Fan Chen on 5/1/16.
//  Copyright © 2016 Fan Chen. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth

protocol CentralViewControllerDelegate {

    func onPeripheralDiscovered()
}

class CentralViewController: NSObject {

    static var kCharacteristicValueUpdatedNotification: String = "CharacteristicValueUpdated"
    static var kCharacteristicNotificationInfo: String { return "CharacteristicInfo" }
    static let sharedInstance = CentralViewController()

    var centralManager: CBCentralManager?
    var connetingPeripheral: CBPeripheral?
    var discoveredService: CBService?
    var notificationCenter: NSNotificationCenter?
    var delegate: CentralViewControllerDelegate?

    // MARK: - Life cycle
    private override init() {

        super.init()
        notificationCenter = NSNotificationCenter.defaultCenter()
        centralManager = CBCentralManager(delegate: self, queue: nil, options: nil)
    }

    deinit {
        print("PeripheralViewController died")
    }

    // MARK: - Public Methods
    func scanForPeripheral() {

        guard let centralManager = centralManager else { return }
        let lastPeripherals = centralManager.retrieveConnectedPeripheralsWithServices([Constants.kUUID])

        if lastPeripherals.count > 0{
            if let device = lastPeripherals.last {
                centralManager.connectPeripheral(device, options: nil)
            }
        }
        else {
            centralManager.scanForPeripheralsWithServices([Constants.kUUID], options: nil)
        }
    }

    func joinASession() {

        guard let connetingPeripheral = connetingPeripheral else { return }
        centralManager?.connectPeripheral(connetingPeripheral, options: nil)
    }

    // MARK: - Private Methods
    private func onCharacteristicUpdated(shouldPlay: Bool) {

        postCharacteristicValueUpdatedNotification(shouldPlay)
    }

    private func postCharacteristicValueUpdatedNotification(shouldPlay: Bool) {

        let userInfo = [CentralViewController.kCharacteristicNotificationInfo : shouldPlay]
        self.notificationCenter?.postNotificationName(CentralViewController.kCharacteristicValueUpdatedNotification, object: self, userInfo: userInfo)
    }
}

extension CentralViewController: CBCentralManagerDelegate {

    func centralManagerDidUpdateState(central: CBCentralManager) {

        NSLog("centralManagerDidUpdateState " + "\(central.state.rawValue)")
        scanForPeripheral()
    }

    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {

        NSLog("Discovered %@", peripheral)
        centralManager?.stopScan()
        connetingPeripheral = peripheral
        guard let connetingPeripheral = connetingPeripheral else { return }
        connetingPeripheral.delegate = self
        delegate?.onPeripheralDiscovered()
    }

    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {

        NSLog("Connected to peripheral " + "\(peripheral.name)")
        peripheral.discoverServices([Constants.kUUID])
    }

    func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {

        NSLog("DisconnectPeripheral to peripheral " + "\(peripheral.name)")
    }
}

extension CentralViewController: CBPeripheralDelegate {

    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {

        guard let services = peripheral.services else { return }
        for service in services {
            if service.UUID == Constants.kUUID {
                self.discoveredService = service
                peripheral.discoverCharacteristics(nil, forService: discoveredService!)
            }
        }
    }

    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {

        guard let characteristics = service.characteristics else { return }
        for characteristic in characteristics {
            NSLog("Found characteristic", "\(characteristic)")
            peripheral.setNotifyValue(true, forCharacteristic: characteristic)
        }
    }

    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {

        if let data = characteristic.value {
            let dataString = NSString(data: data, encoding: NSUTF8StringEncoding)?.description
            NSLog("didUpdateValueForCharacteristic: " + "\(dataString!)")

            if dataString == "true" {
                onCharacteristicUpdated(true)
            } else {
                onCharacteristicUpdated(false)
            }
        }
    }

    func peripheral(peripheral: CBPeripheral, didUpdateNotificationStateForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        
        if let error = error {
            print(error)
        }
    }
}