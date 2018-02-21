//
//  ArduinoCommunicator.swift
//  Lampino
//
//  Created by Victor S Melo on 20/02/18.
//  Copyright © 2018 Victor S Melo. All rights reserved.
//

import Foundation

protocol ArduinoCommunicatorDelegate {
    func communicatorDidConnect(_ communicator: ArduinoCommunicator)
    func communicator(_ communicator: ArduinoCommunicator, didRead data: Data)
    func communicator(_ communicator: ArduinoCommunicator, didWrite data: Data)
}

protocol ArduinoCommunicator {
    var delegate: ArduinoCommunicatorDelegate? { get set }
    func getLamp(atIndex: Int) -> Lamp?
    func numberOfLamps() -> Int
    func setBrightness(lampId: Character, brightness: Double)
    func getBrightness(lampId: Int) -> Double?
}
