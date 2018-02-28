//
//  ArduinoCommunicatorBluetooth.swift
//  Lampino
//
//  Created by Victor S Melo on 20/02/18.
//  Copyright © 2018 Lampino Organization. All rights reserved.
//

import CoreBluetooth

extension Array where Element == UInt8 {
    func asData() -> Data {
        return Data(bytes: self)
    }
}

class ArduinoCommunicatorBluetooth: NSObject {
    
    private enum Command: UInt8 {
        case getLampCount = 150
        case getLampBrightness = 160
        case setLampBrightness = 170
        
        case sentinel = 198
    }
    
    static let sharedInstance: ArduinoCommunicator = ArduinoCommunicatorBluetooth()
    
    weak var delegate: ArduinoCommunicatorDelegate?
    
    // MARK: - Private Properties
    
    private let expectedPeripheralName = "LAMPINO"
    private let expectedServiceCBUUID = CBUUID(string: "DFB0") // TODO: to make more generic should not test for especific uuids
    private let expectedCharacteristicCBUUID = CBUUID(string: "DFB1")
    
    private var lastCommand: Command?
    
    private var arduinoPeripheral: CBPeripheral?
    private var writeCharacteristic: CBCharacteristic?
    
    private var centralManager: CBCentralManager?
    
    // MARK: - Private Methods
    
    override private init() {
        super.init()
    }
    
    private func execute(command: Command, with data: [UInt8]?) {
        guard let arduino = self.arduinoPeripheral,
            let characteristic = self.writeCharacteristic else {
            print("[Error] Not properly initialized")
            return
        }
        
        var finalData = [command.rawValue]
        if let data = data {
            finalData.append(contentsOf: data)
        }
        finalData.append(Command.sentinel.rawValue)
        
        self.lastCommand = command
        
        arduino.writeValue(finalData.asData(), for: characteristic, type: .withResponse)
    }
}

extension ArduinoCommunicatorBluetooth: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOff:
            print("Bluetooth off")
            centralManager?.stopScan()
        case .poweredOn:
            print("Bluetooth on")
            centralManager?.scanForPeripherals(withServices: [self.expectedServiceCBUUID])
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
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices([self.expectedServiceCBUUID])
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        self.delegate?.communicatorDidDisconnect(self)
    }
}

extension ArduinoCommunicatorBluetooth: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else {
            print("[Error] Found no services")
            return
        }
        
        for service in services {
            print(service)
            peripheral.discoverCharacteristics([self.expectedCharacteristicCBUUID], for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else {
            print("[Error] Found no characteristics")
            return
        }
        
        for characteristic in characteristics {
            if (characteristic.uuid == self.expectedCharacteristicCBUUID) {
                print("Discovered characteristic \(characteristic), for Service \(service)")
                self.writeCharacteristic = characteristic
                
                if characteristic.properties.contains(.notify) {
                    peripheral.setNotifyValue(true, for: characteristic)
                }
                
                self.delegate?.communicatorDidDiscoverCharacteristics(self)
            }
        }
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("Received")
        let data = characteristic.value
        
        print(String(data: data!, encoding: .utf8) ?? "Not string")
        print([UInt8](data!))
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        print(#function) // TODO: check for consistense
    }
}


extension ArduinoCommunicatorBluetooth: ArduinoCommunicator {
    func initBluetooth() {
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func getNumberOfLamps() {
        print("Get number of lamps")
        self.execute(command: .getLampCount, with: nil)
    }
    
    func getBrightness(lampId: UInt8?) {
        guard let arduino = arduinoPeripheral else { return }
        guard let characteristic = writeCharacteristic else { return }
        
        let bytes: [UInt8]
        
        if let lampId = lampId {
            bytes = [160, lampId + 200, 198]
        } else {
            bytes = [160, 198]
        }
        
        print("Get brightness for \(lampId as Any)")
        arduino.writeValue(Data(bytes: bytes), for: characteristic, type: .withResponse)
    }
    
    func setBrightness(lampId: UInt8?, brightness: UInt8) {
        guard let arduino = arduinoPeripheral else { return }
        guard let characteristic = writeCharacteristic else { return }
        
        let bytes: [UInt8]
        
        if let lampId = lampId {
            bytes = [170, brightness, lampId + 200, 198]
        } else {
            bytes = [170, brightness, 198]
        }
        
        print("Send brightness for \(lampId as Any)")
        arduino.writeValue(Data(bytes: bytes), for: characteristic, type: .withResponse)
    }
}
