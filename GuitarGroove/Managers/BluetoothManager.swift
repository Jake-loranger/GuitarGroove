//
//  BluetoothManager.swift
//  GuitarGroove
//
//  Created by Jacob  Loranger on 7/15/24.
//

import Foundation
import CoreBluetooth

class BluetoothManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    var centralManager: CBCentralManager!
    var discoveredPeripherals: [CBPeripheral] = []
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print("powered on")
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        case .poweredOff, .resetting, . unauthorized, .unsupported, .unknown:
            print("Error")
            break
        @unknown default:
            fatalError()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Discovered \(peripheral.name ?? "unknown device")")
        
        discoveredPeripherals.append(peripheral)
        centralManager.stopScan()
        centralManager.connect(peripheral, options: nil)
    }
}
