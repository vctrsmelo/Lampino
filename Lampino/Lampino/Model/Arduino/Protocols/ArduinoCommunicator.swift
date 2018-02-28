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
    func communicatorDidDiscoverCharacteristics(_ communicator: ArduinoCommunicator)
    func communicator(_ communicator: ArduinoCommunicator, didReceive numberOfLamps: UInt8)
    func communicator(_ communicator: ArduinoCommunicator, didReadBrightness brightness: UInt8, at lampId: UInt8)
    func communicator(_ communicator: ArduinoCommunicator, didWriteBrightness brightness: UInt8, at lampId: UInt8)
}

protocol ArduinoCommunicator {
    var delegate: ArduinoCommunicatorDelegate? { get set }
    func sendBrightness(lampId: UInt8?, brightness: UInt8)
    func getBrightness(lampId: UInt8?)
    func getNumberOfLamps()
}
