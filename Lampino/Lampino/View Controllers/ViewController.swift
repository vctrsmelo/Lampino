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
    private var lampsManager: LampsManager!
    
    private var loadingComponent: LoadingComponent!
    
    private var lastValue: Float = 0
    
    @IBOutlet weak var mySlider: UISlider!
    
    var vai = true
    
    // MARK: - View Controller Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadingComponent = LoadingComponent()
        self.loadingComponent.addLoadingIndicator(to: self.view)
        self.lampsManager = LampsManager(delegate: self)
        
    }
    
    @IBAction func changedSlider(_ sender: UISlider) {
        let newValue = sender.value
        
        if abs(newValue - lastValue) >= 0.1 || newValue == 0 || newValue == 1 {
            lastValue = newValue
            lampsManager.updateBrightness(0, newBrightness: UInt8(lastValue * 255))
            //            lastValue = newValue
            //            var bytes: [UInt8] = Array("A".utf8)
            //            bytes.append(UInt8(lastValue * 255))
            //            lampsManager.updateBrightness("A", newBrightness: UInt8(lastValue * 255))
        }
    }
    
    // MARK: - Actions
    @IBAction func updateTrafficLight(_ sender: UIButton) {
        //Send code that signifies arduino to update its state
        if lastValue > 0 {
            lampsManager.updateBrightness(0, newBrightness: UInt8(0))
            lastValue = 0
        } else {
            lampsManager.updateBrightness(0, newBrightness: UInt8(255))
            lastValue = 255
        }
        mySlider.setValue(lastValue, animated: true)
    }
}

extension ViewController: LampsManagerDelegate {
    
    func didConnectToCommunicator() {
        self.loadingComponent.removeLoadingIndicators(from: self.view)
    }
    
}

