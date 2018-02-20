//
//  ArduinoPeripheral.swift
//  Lampino
//
//  Created by Victor S Melo on 20/02/18.
//  Copyright © 2018 Lampino Organization. All rights reserved.
//

import Foundation
import CoreBluetooth

class ArduinoPeripheral: NSObject {
    
    private var peripheral: CBPeripheral?
    private var characterist: CBCharacteristic?
    
    private let expectedPeripheralName = "BLE-LinkV1.8"
    private let expectedCharacteristicUUIDString = "DFB1"

    private(set) var isReady: Bool = false
}

extension ArduinoPeripheral: CBPeripheralDelegate {
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
