//
//  ArduinoCommunicatorMock.swift
//  Lampino
//
//  Created by Victor S Melo on 07/03/18.
//  Copyright © 2018 Lampino Organization. All rights reserved.
//

import Foundation

class ArduinoCommunicatorMock: ArduinoCommunicator {
    var delegate: ArduinoCommunicatorDelegate?
    
    var lamps: [Lamp] = [
            Lamp(id: 0, name: "Alpha", brightness: 100),
            Lamp(id: 1, name: "Bravo", brightness: 80)
    ]
    
    func initBluetooth() {
        delegate?.communicatorDidConnect(self)
    }
    
    func getNumberOfLamps() {
        delegate?.communicator(self, didReceive: UInt8(lamps.count))
    }
    
    func getBrightness(_ lampId: UInt8?) {
        let brightness = lamps.map { return $0.brightness }
        delegate?.communicator(self, didReceive: brightness)
    }
    
    func setBrightness(_ brightness: UInt8, to lampId: UInt8?) {
        if lampId == nil {
            
            for i in 0 ..< lamps.count {
                var lamp = lamps[i]
                lamp.brightness = brightness
                lamps[i] = lamp
            }
            
        } else {
            
            for i in 0 ..< lamps.count where lamps[i].id == lampId {
                var lamp = lamps[i]
                lamp.brightness = brightness
                lamps[i] = lamp
            }
            
        }
        
    }
    
    
}
