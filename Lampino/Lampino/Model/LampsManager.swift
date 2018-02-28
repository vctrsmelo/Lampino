//
//  LampsManager.swift
//  BluetoothTest
//
//  Created by Victor S Melo on 21/02/18.
//  Copyright © 2018 Nicolas Nascimento. All rights reserved.
//

import Foundation

protocol LampsManagerDelegate {
    func didConnectToCommunicator()
}

class LampsManager {
    
    private var numberOfLamps: UInt8 = 0
    private var lamps: [Lamp] = []
    private var communicator: ArduinoCommunicator?
    
    var delegate: LampsManagerDelegate?
    
    func addLamp(_ lampId: UInt8, name: String, brightness: UInt8) {
        self.lamps.append(Lamp(id: lampId, name: name, brightness: brightness))
    }
    
    func updateBrightness(_ lampId: UInt8?, newBrightness brightness: UInt8) {
        communicator?.sendBrightness(lampId: lampId, brightness: brightness)
    }
    
    func getBrightness(lampId: UInt8?) {
        communicator?.getBrightness(lampId: lampId)
    }
    
    init(delegate: LampsManagerDelegate) {
        self.delegate = delegate
        self.communicator = ArduinoCommunicatorBluetooth.sharedInstance
        communicator!.delegate = self
    }
}

extension LampsManager: ArduinoCommunicatorDelegate {
    
    func communicatorDidConnect(_ communicator: ArduinoCommunicator) {
        self.delegate?.didConnectToCommunicator()
    }
    
    func communicatorDidDiscoverCharacteristics(_ communicator: ArduinoCommunicator) {
        communicator.getNumberOfLamps()
    }
    
    func communicator(_ communicator: ArduinoCommunicator, didReceive numberOfLamps: UInt8) {
        self.numberOfLamps = numberOfLamps
    }
    
    func communicator(_ communicator: ArduinoCommunicator, didReadBrightness brightness: UInt8, at lampId: UInt8) {
        guard var lamp = lamps.first(where: {$0.id == lampId}) else { return }
        lamp.brightness = brightness
        print("Leu")
    }
    
    func communicator(_ communicator: ArduinoCommunicator, didWriteBrightness brightness: UInt8, at lampId: UInt8) {
//        guard var lamp = lamps.first(where: {$0.id == lampId}) else { return }
//        lamp.brightness = brightness
        print("Escreveu")

    }
}
