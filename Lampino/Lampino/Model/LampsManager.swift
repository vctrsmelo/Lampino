//
//  LampsManager.swift
//  BluetoothTest
//
//  Created by Victor S Melo on 21/02/18.
//  Copyright © 2018 Nicolas Nascimento. All rights reserved.
//

import Foundation

protocol LampsManagerDelegate: AnyObject {
    func updatedLamps()
}

class LampsManager {
    
    private var numberOfLamps: UInt8 = 0
    private(set) var lamps: [Lamp] = []
    private var communicator: ArduinoCommunicator?
    
    internal weak var delegate: LampsManagerDelegate?
    
//    func addLamp(_ lampId: UInt8, name: String, brightness: UInt8) {
//        self.lamps.append(Lamp(id: lampId, name: name, brightness: brightness))
//    }
    
    func setBrightness(_ lampId: UInt8?, newBrightness brightness: UInt8) {
        communicator?.setBrightness(lampId: lampId, brightness: brightness)
    }
    
    func getBrightness(lampId: UInt8?) {
        communicator?.getBrightness(lampId: lampId)
    }
    
    init(delegate: LampsManagerDelegate) {
        self.delegate = delegate
        
        self.communicator = ArduinoCommunicatorBluetooth.sharedInstance
        
        self.communicator?.delegate = self
        self.communicator?.initBluetooth()
    }
    
    init() {
        self.communicator = ArduinoCommunicatorBluetooth.sharedInstance
        communicator!.delegate = self
        self.communicator?.initBluetooth()
    }
}

extension LampsManager: ArduinoCommunicatorDelegate {
    func communicatorDidDiscoverCharacteristics(_ communicator: ArduinoCommunicator) {
        communicator.getNumberOfLamps()
    }
    
    func communicatorDidDisconnect(_ communicator: ArduinoCommunicator) {
        self.lamps = []
        self.delegate?.updatedLamps()
    }
    
    func communicator(_ communicator: ArduinoCommunicator, didReceive numberOfLamps: UInt8) {
        self.numberOfLamps = numberOfLamps
        communicator.getBrightness(lampId: nil)
    }
    
    func communicator(_ communicator: ArduinoCommunicator, didReadBrightness brightness: UInt8, at lampId: UInt8) {
        guard var lamp = lamps.first(where: {$0.id == lampId}) else { return }
        lamp.brightness = brightness
        print("Leu")
    }
}
