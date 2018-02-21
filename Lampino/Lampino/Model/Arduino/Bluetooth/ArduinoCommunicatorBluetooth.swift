//
//  ArduinoCommunicatorBluetooth.swift
//  Lampino
//
//  Created by Victor S Melo on 20/02/18.
//  Copyright © 2018 Lampino Organization. All rights reserved.
//

import Foundation

import Foundation
import CoreBluetooth

protocol DataConvertible {
    var data: Data { get }
}

extension Data: DataConvertible {
    var data: Data { return self }
}
extension String : DataConvertible {
    var data: Data { return self.data(using: .utf8) ?? Data() }
}

extension UInt8: DataConvertible {
    var data: Data {
        return Data.init(bytes: [self])
    }
}

class ArduinoCommunicatorBluetooth: NSObject {
    
    static let sharedInstance: ArduinoCommunicator = ArduinoCommunicatorBluetooth()
    
    private let expectedPeripheralName = "KIT1"
    private let expectedCharacteristicUUIDString = "DFB1"
    
    private var lamps: [(peripheral: CBPeripheral,characteristic: CBCharacteristic)] = []
    
    // MARK: - Private Properties
    private var centralManager: CBCentralManager?
    
    // MARK: - Private Methods
    override private init() {
        super.init()
        
        // Begin looking for elements
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
}

extension ArduinoCommunicatorBluetooth: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOff:
            centralManager?.stopScan()
        case .poweredOn:
            centralManager?.scanForPeripherals(withServices: nil)
        default:
            print("State not supported: \(central.state)")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Discovered peripheral: \(peripheral.name ?? "ERROR")")
        if peripheral.name == self.expectedPeripheralName {
            central.connect(peripheral, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices(nil)
    }
}

extension ArduinoCommunicatorBluetooth: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        
        for service in services {
            print(service)
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            if (characteristic.uuid.uuidString == expectedCharacteristicUUIDString) {
                print("Discovered characteristic \(characteristic), for Service \(service)")
                lamps.append((peripheral,characteristic))
                
                if characteristic.properties.contains(.read) {
                    peripheral.readValue(for: characteristic)
                }
                
                if characteristic.properties.contains(.notify) {
                    peripheral.setNotifyValue(true, for: characteristic)
                }
                
                //read current brightness value
                
            }
        }
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        switch characteristic.uuid {
        case expectedCharacteristicUUIDString:
            print(characteristic.value ?? "no value")
        default:
            print("Unhandled Characteristic UUID: \(characteristic.uuid)")
        }
    }
    
    /// Sends the bytes provided to Arduino using Bluetooth
    func send(value: Int, peripheral: CBPeripheral) {
        guard let lamp = lamps.filter({$0.peripheral == peripheral}).first else { return }
        var valueToData = value
        lamp.peripheral.writeValue(Data(bytes: &valueToData, count: MemoryLayout<Int>.size), for: lamp.characteristic, type: .withResponse)
    }
    
}


extension ArduinoCommunicatorBluetooth: ArduinoCommunicator {
    
    func getLamp(atIndex: Int) -> Lamp? {
        // TODO: implement
        return nil
    }
    
    func numberOfLamps() -> Int {
        // TODO: implement
        return 0
    }
    
    func setBrightness(lampId: Int, brightness: Double) {
        // TODO: implement
    }
    
    func getBrightness(lampId: Int) -> Double? {
        // TODO: implement
        return nil
    }
}
