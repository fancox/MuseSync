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

class CentralViewController: UIViewController {

    var centralManager: CBCentralManager?
    var connetingPeripheral: CBPeripheral?
    var discoveredService: CBService?

    override  func viewDidLoad() {

        super.viewDidLoad()
        centralManager = CBCentralManager(delegate: self, queue: nil, options: nil)
    }

    @IBAction func didTapDiscover(sender: AnyObject) {

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

    @IBAction func didTapStop(sender: AnyObject) {

        centralManager?.stopScan()
    }
}

extension CentralViewController: CBCentralManagerDelegate {

    func centralManagerDidUpdateState(central: CBCentralManager) {

        print("centralManagerDidUpdateState")
    }

    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {

        NSLog("Discovered %@", peripheral)
        connetingPeripheral = peripheral
        guard let connetingPeripheral = connetingPeripheral else { return }
        connetingPeripheral.delegate = self
        central.connectPeripheral(connetingPeripheral, options: nil)
    }

    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {

        NSLog("Connected to peripheral %@", peripheral)
        peripheral.discoverServices([Constants.kUUID])
    }
}

extension CentralViewController: CBPeripheralDelegate {

    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {

        guard let services = peripheral.services else { return }
        for service in services {
            if service.UUID == Constants.kUUID {
                peripheral.discoverCharacteristics([Constants.kUUID], forService: service)
            }
        }
    }

    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {

        guard let characteristics = service.characteristics else { return }
        for characteristic in characteristics {
            NSLog("Found characteristic %@", characteristic)
            let data = characteristic.value
            print(data)
        }
    }
}
