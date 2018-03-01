//
//  LampsManager.swift
//  BluetoothTest
//
//  Created by Victor S Melo on 21/02/18.
//  Copyright © 2018 Nicolas Nascimento. All rights reserved.
//

import Foundation

protocol LampsManagerDelegate: AnyObject {
    func didConnect()
    func didDisconnect()
    func updatedLamps()
}

class LampsManager {
    
    static let sharedInstance = LampsManager()
    
    private(set) var isConnected = false
    private(set) var lamps: [Lamp] = []
    
    weak var delegate: LampsManagerDelegate?
    
    private var communicator: ArduinoCommunicator?
    
    private init() {
        self.communicator = ArduinoCommunicatorBluetooth.sharedInstance
        
        self.communicator?.delegate = self
        self.communicator?.initBluetooth()
    }
    
    func setBrightness(_ brightness: UInt8, to lampId: UInt8?) {
        self.communicator?.setBrightness(brightness, to: lampId)
    }
    
}

extension LampsManager: ArduinoCommunicatorDelegate {
    
    func communicatorDidConnect(_ communicator: ArduinoCommunicator) {
        communicator.getNumberOfLamps()
    }
    
    func communicatorDidDisconnect(_ communicator: ArduinoCommunicator) {
        self.lamps = []
        self.isConnected = false
        self.delegate?.didDisconnect()
    }
    
    func communicator(_ communicator: ArduinoCommunicator, didReceive lampCount: UInt8) {
        communicator.getBrightness(nil)
    }
    
    func communicator(_ communicator: ArduinoCommunicator, didReceive everyBrightness: [UInt8]) {
        
        while self.lamps.count < everyBrightness.count {
            self.lamps.append(Lamp(id: UInt8(self.lamps.count)))
        }
        
        var index = 0
        for brightness in everyBrightness {
            
            var lamp = self.lamps[index]
            lamp.brightness = brightness
            
            self.lamps[index] = lamp // TODO: see if it works
            index += 1
        }
        
        if self.isConnected {
            self.delegate?.updatedLamps()
            
        } else {
            self.isConnected = true
            self.delegate?.didConnect()
        }
    }
}
