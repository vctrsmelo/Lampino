//
//  ArduinoCommunicator.swift
//  Lampino
//
//  Created by Victor S Melo on 20/02/18.
//  Copyright © 2018 Victor S Melo. All rights reserved.
//

import Foundation

protocol ArduinoCommunicatorDelegate: AnyObject {
    func communicatorDidConnect(_ communicator: ArduinoCommunicator)
    func communicatorDidDisconnect(_ communicator: ArduinoCommunicator)
    func communicator(_ communicator: ArduinoCommunicator, didReceive lampCount: UInt8)
    func communicator(_ communicator: ArduinoCommunicator, didReceive everyBrightness: [UInt8])
//    func communicator(_ communicator: ArduinoCommunicator, didReceive brightness: UInt8, for lampId: UInt8) // Not needed for now
}

protocol ArduinoCommunicator: AnyObject {
    var delegate: ArduinoCommunicatorDelegate? { get set }
    func initBluetooth()
    func getNumberOfLamps()
    func getBrightness(_ lampId: UInt8?)
    func setBrightness(_ brightness: UInt8, to lampId: UInt8?)
}
