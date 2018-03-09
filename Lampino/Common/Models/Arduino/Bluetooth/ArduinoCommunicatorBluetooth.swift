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
    
    private enum Command {
        case getLampCount
        case getLampBrightness(bytes: [UInt8])
        case setLampBrightness(bytes: [UInt8])
        
        var code: UInt8 {
            switch self {
            case .getLampCount:
                return 150
                
            case .getLampBrightness:
                return 160
                
            case .setLampBrightness:
                return 170
            }
        }
    }
    
    static let sharedInstance: ArduinoCommunicator = ArduinoCommunicatorBluetooth()
    
    weak var delegate: ArduinoCommunicatorDelegate?
    
    // MARK: - Private Properties
    
    private let expectedPeripheralName = "LAMPINO"
    private let expectedServiceCBUUID = CBUUID(string: "DFB0") // TODO: to make more generic should not test for especific uuids
    private let expectedCharacteristicCBUUID = CBUUID(string: "DFB1")
    
    private let sentinel: UInt8 = 198
    private let indexAdd: UInt8 = 200
    private var lastCommand: Command?
    private var answerSoFar: [UInt8] = []
    
    private var arduinoPeripheral: CBPeripheral?
    private var writeCharacteristic: CBCharacteristic?
    
    private var centralManager: CBCentralManager?
    
    // MARK: - Private Methods
    
    private override init() {
        super.init()
    }
    
    private func execute(command: Command) {
        guard let arduino = self.arduinoPeripheral,
            let characteristic = self.writeCharacteristic else {
            print("[Error] Not properly initialized")
            return
        }
        
        var finalData = [command.code]
        
        switch command {
        case .getLampCount:
            break
            
        case .getLampBrightness(bytes: let bytes), .setLampBrightness(bytes: let bytes):
            finalData.append(contentsOf: bytes)
        }
        
        finalData.append(self.sentinel)
        
        self.lastCommand = command
        
        arduino.writeValue(finalData.asData(), for: characteristic, type: .withResponse)
    }
    
    private func parseGetLampCount(_ response: [UInt8]) {
        for byte in response {
            if byte == self.sentinel {
                guard self.answerSoFar.count == 1 else {
                    print("[Error] Invalid answer, trying again...")
                    self.getNumberOfLamps()
                    return
                }
                
                let answer = self.answerSoFar.first!
                
                self.lastCommand = nil
                self.answerSoFar = []
                
                self.delegate?.communicator(self, didReceive: answer)
                
            } else {
                self.answerSoFar.append(byte)
            }
        }
    }
    
    private func parseGetLampBrightness(_ response: [UInt8], originalData: [UInt8]) {
        for byte in response {
            if byte == self.sentinel {
                guard !self.answerSoFar.isEmpty else {
                    print("[Error] Invalid answer, trying again...")
                    self.execute(command: .getLampBrightness(bytes: originalData))
                    return
                }
                
                let answer = self.answerSoFar
                
                self.lastCommand = nil
                self.answerSoFar = []
                
                self.delegate?.communicator(self, didReceive: answer)
                
            } else {
                self.answerSoFar.append(byte)
            }
        }
    }
}

extension ArduinoCommunicatorBluetooth: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOff:
            print("Bluetooth off")
            self.arduinoPeripheral = nil
            
        case .poweredOn:
            print("Bluetooth on")
            centralManager?.scanForPeripherals(withServices: [self.expectedServiceCBUUID])
        default:
            print("State not supported: \(central.state)")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Discovered peripheral: \(peripheral.name ?? "ERROR")")
        
        if peripheral.name == self.expectedPeripheralName {
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
                
                self.delegate?.communicatorDidConnect(self)
            }
        }
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("Received")
        guard let data = characteristic.value else {
            print("[Error] Invalid Data")
            return
        }
        
        let receivedBytes = [UInt8](data)
        print(String(data: data, encoding: .utf8) ?? receivedBytes)
        
        guard let lastCommand = self.lastCommand else {
            print("[Notice] No last command")
            return
        }
        
        switch lastCommand {
        case .getLampCount:
            self.parseGetLampCount(receivedBytes)
            
        case .getLampBrightness(bytes: let originalData):
            self.parseGetLampBrightness(receivedBytes, originalData: originalData)
            
        case .setLampBrightness:
            print("[Notice] Received answer after set brightness") // shouldn't receive answer
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        print(#function) // TODO: check for consistense
    }
}


extension ArduinoCommunicatorBluetooth: ArduinoCommunicator {
    func initBluetooth() {
        self.centralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey: true])
    }
    
    func disconnect() {
        guard let arduino = self.arduinoPeripheral else {
            print("[Notice] No arduino to disconnect")
            return
        }
        
        self.centralManager?.cancelPeripheralConnection(arduino)
        self.arduinoPeripheral = nil
    }
    
    func getNumberOfLamps() {
        print("Get number of lamps")
        self.execute(command: .getLampCount)
    }
    
    func getBrightness(_ lampId: UInt8?) {
        
        let bytes: [UInt8]
        
        if let lampId = lampId {
            bytes = [lampId + self.indexAdd]
            print("Get brightness for \(lampId)")
            
        } else {
            bytes = []
            print("Get brightness for all")
        }
        
        self.execute(command: .getLampBrightness(bytes: bytes))
    }
    
    func setBrightness(_ brightness: UInt8, to lampId: UInt8?) {
        
        let bytes: [UInt8]
        
        if let lampId = lampId {
            bytes = [brightness, lampId + self.indexAdd]
            print("Set \(brightness) brightness for \(lampId)")
            
        } else {
            bytes = [brightness]
            print("Set \(brightness) brightness for all")
        }
        
        self.execute(command: .setLampBrightness(bytes: bytes))
    }
}
