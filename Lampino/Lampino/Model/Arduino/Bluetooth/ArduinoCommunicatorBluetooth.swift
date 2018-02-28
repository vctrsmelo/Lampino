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
    
    private let expectedPeripheralName = "BRUNO2"
    private let expectedCharacteristicUUIDString = "DFB1"
    
    private var arduinoPeripheral: CBPeripheral?
    private var characteristic: CBCharacteristic?
    
    
    var delegate: ArduinoCommunicatorDelegate?
    
    // MARK: - Private Properties
    private var centralManager: CBCentralManager?
    
    // MARK: - Private Methods
    override private init() {
        super.init()
        
        // Begin looking for elements
        centralManager = CBCentralManager(delegate: self, queue: nil)
        centralManager?.scanForPeripherals(withServices: nil)
    }
    
}

extension ArduinoCommunicatorBluetooth: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOff:
            centralManager?.stopScan()
            print("Bluetooth off")
        case .poweredOn:
            print("Bluetooth on")
            centralManager?.scanForPeripherals(withServices: nil)
        default:
            print("State not supported: \(central.state)")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if peripheral.name == self.expectedPeripheralName {
            print("Discovered peripheral: \(peripheral.name ?? "ERROR")")
            arduinoPeripheral = peripheral
            peripheral.delegate = self
            central.connect(peripheral, options: nil)
            delegate?.communicatorDidConnect(self)
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
                self.characteristic = characteristic
                
//                if characteristic.properties.contains(.read) {
//                    peripheral.readValue(for: characteristic)
//                }
                
                if characteristic.properties.contains(.notify) {
                    peripheral.setNotifyValue(true, for: characteristic)
                }
                
                self.delegate?.communicatorDidDiscoverCharacteristics(self)
                
            }
        }
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        switch characteristic.uuid.uuidString {
        case expectedCharacteristicUUIDString:
            
            print("Received")
            let data = characteristic.value
            
            print(String(data: data!, encoding: .utf8) ?? "Not string")
            print([UInt8](data!))
            
        default:
            print("Unhandled Characteristic UUID: \(characteristic.uuid)")
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
        let data = characteristic?.value
        print("Updated")
        print(String(data: data!, encoding: .utf8)!)
    }
    
}


extension ArduinoCommunicatorBluetooth: ArduinoCommunicator {
    func getNumberOfLamps() {
        guard let arduino = arduinoPeripheral else { return }
        guard let characteristic = characteristic else { return }
        
        print("Get number of lamps")
        arduino.writeValue(Data(bytes: [150, 198]), for: characteristic, type: .withResponse)
    }
    
    func sendBrightness(lampId: UInt8?, brightness: UInt8) {
        guard let arduino = arduinoPeripheral else { return }
        guard let characteristic = characteristic else { return }
        
        let bytes: [UInt8]
        
        if let lampId = lampId {
            bytes = [170, brightness, lampId + 200, 198]
        } else {
            bytes = [170, brightness, 198]
        }
        
        print("Send brightness for \(lampId as Any)")
        arduino.writeValue(Data(bytes: bytes), for: characteristic, type: .withResponse)
    }
    
    func getBrightness(lampId: UInt8?) {
        guard let arduino = arduinoPeripheral else { return }
        guard let characteristic = characteristic else { return }
        
        let bytes: [UInt8]
        
        if let lampId = lampId {
            bytes = [160, lampId + 200, 198]
        } else {
            bytes = [160, 198]
        }
        
        print("Get brightness for \(lampId as Any)")
        arduino.writeValue(Data(bytes: bytes), for: characteristic, type: .withResponse)
    }
    
}
