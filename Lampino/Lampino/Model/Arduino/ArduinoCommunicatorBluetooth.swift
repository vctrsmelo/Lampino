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
    
    // MARK: - Private Properties
    private var centralManager: CBCentralManager?
    private var peripheral: CBPeripheral?
    private var characterist: CBCharacteristic?
    
    private let expectedPeripheralName = "BLE-LinkV1.8"
    private let expectedCharacteristicUUIDString = "DFB1"
    private(set) var isReady: Bool = false
    
    // MARK: - Private Methods
    override private init() {
        super.init()
        
        // Begin looking for elements
        self.centralManager = CBCentralManager(delegate: self, queue: .main)
    }
    
    // MARK: - Public
    
    /// Sends the bytes provided to Arduino using Bluetooth
    private func send<T: DataConvertible>(value: T) {
        if( self.isReady ) {
            guard let characterist = self.characterist else { return }
            self.peripheral?.writeValue(value.data, for: characterist, type: .withResponse)
        }
    }
    
    /// Read data from Arduino Module, if possible
    private func read() {
        if( self.isReady ) {
            guard let characterist = self.characterist else { return }
            self.peripheral?.readValue(for: characterist)
        }
    }
}

extension ArduinoCommunicatorBluetooth: CBCentralManagerDelegate {
    
    // Called once the manager has beed updated
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("State Updated")
        
        switch central.state {
        case .poweredOn:
            print("Began Scanning...")
            self.centralManager?.scanForPeripherals(withServices: nil, options: nil)
        case .poweredOff:
            print("WARNING - Bluetooth is Disabled. Switch it on and try again")
        default:
            print("WARNING: - state not supported \(String.init(describing: central.state))")
        }
    }
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        // We should only try to connect to the peripheral we're interested in
        // In this case, we can use its name
        if( peripheral.name == self.expectedPeripheralName ) {
            print("Discovered \(self.expectedPeripheralName)")
            self.peripheral = peripheral
            
            print("Attemping Connection...")
            // Attemp connection
            central.connect(peripheral, options: nil)
        }
    }
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected")
        // Allow delegate to update status
//        self.delegate?.communicatorDidConnect(self)
        
        // Once connection is stabilished, we can begin discovering services
        peripheral.delegate = self
        
        print("Discovering Services...")
        peripheral.discoverServices(nil)
    }
}

extension ArduinoCommunicatorBluetooth: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        for service in peripheral.services ?? [] {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        for characterist in service.characteristics ?? []  {
            if( characterist.uuid.uuidString == self.expectedCharacteristicUUIDString ) {
                print("Discovered Characteristic \(characterist), for Service \(service)")
                self.characterist = characterist
                self.isReady = true
                peripheral.setNotifyValue(true, for: characterist)
            }
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let characteristOfInterest = self.characterist, let data = characteristOfInterest.value  else { return }
        if( characteristic.uuid.uuidString == characteristOfInterest.uuid.uuidString ) {
            
            // Allows the delegate to handle data exchange (read)
//            self.delegate?.communicator(self, didRead: data)
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        
        guard let characteristOfInterest = self.characterist, let data = characteristOfInterest.value else { return }
        if( characteristic.uuid.uuidString == characteristOfInterest.uuid.uuidString ) {
            
            // Allows the delegate to handle data exchange (write)
//            self.delegate?.communicator(self, didWrite: data)
        }
        
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
    }
    
    
}
