//
//  ViewController.swift
//  BluetoothTest
//
//  Created by Nicolas Nascimento on 15/12/17.
//  Copyright © 2017 Nicolas Nascimento. All rights reserved.
//

import UIKit
import CoreBluetooth

final class ViewController: UIViewController {
    // MARK: - Private Properties
    private var communicator: ArduinoCommunicator!
    
    private var loadingComponent: LoadingComponent!
    
    private var lastValue: Float = 0
    
    @IBOutlet weak var mySlider: UISlider!
    
    var selectedLed = "A"
    
    // MARK: - View Controller Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadingComponent = LoadingComponent()
        
        self.communicator = ArduinoCommunicator(delegate: self)
        
        self.loadingComponent.addLoadingIndicator(to: self.view)
    }
    
    @IBAction func changedSlider(_ sender: UISlider) {
        let newValue = sender.value
        
        if abs(newValue - lastValue) >= 0.1 || newValue == 0 || newValue == 1 {
            lastValue = newValue
            var bytes: [UInt8] = Array(selectedLed.utf8)
            bytes.append(UInt8(lastValue * 255))
            self.communicator.send(value: Data(bytes: bytes))
        }
    }
    
    // MARK: - Actions
    @IBAction func updateTrafficLight(_ sender: UIButton) {
        //Send code that signifies arduino to update its state
        if lastValue > 0 {
            self.communicator.send(value: UInt8(0))
            lastValue = 0
        } else {
            self.communicator.send(value: UInt8(255))
            lastValue = 255
        }
        mySlider.setValue(lastValue, animated: true)
    }
    
    @IBAction func redLedSelected(_ sender: Any) {
        selectedLed = "A"
    }
    
    @IBAction func greenLedSelected(_ sender: Any) {
        selectedLed = "B"
    }
    
    @IBAction func yellowLedSelected(_ sender: Any) {
        selectedLed = "C"
    }
}

extension ViewController: ArduinoCommunicatorDelegate {
    func communicatorDidConnect(_ communicator: ArduinoCommunicator) {
        self.loadingComponent.removeLoadingIndicators(from: self.view)
    }
    
    func communicator(_ communicator: ArduinoCommunicator, didRead data: Data) {
        print(#function)
        print(String(data: data, encoding: .utf8)!)
    }
    func communicator(_ communicator: ArduinoCommunicator, didWrite data: Data) {
        print(#function)
        print(String(data: data, encoding: .utf8)!)
    }
}
