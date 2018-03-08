//
//  LampInterfaceController.swift
//  Lampino Watch Extension
//
//  Created by Victor S Melo on 07/03/18.
//  Copyright © 2018 Lampino Organization. All rights reserved.
//

import WatchKit

class LampInterfaceController: WKInterfaceController {
    
    @IBOutlet private weak var noLampsLabel: WKInterfaceLabel!
    @IBOutlet private weak var lampGroup: WKInterfaceGroup!
    
    @IBOutlet private weak var nameLabel: WKInterfaceLabel!
    @IBOutlet private weak var onOffButton: WKInterfaceButton!
    @IBOutlet private weak var brightnessSlider: WKInterfaceSlider!
    
    private var _currentBrightnessValue: Float = 0
    private var lampId: UInt8 = 0
    
    private var isOn: Bool! {
        didSet {
            
            if isOn {
                onOffButton.setBackgroundImageNamed("ON")
                brightnessSlider.setColor(UIColor.onColor)
                
                if _currentBrightnessValue == 0 {
                    _currentBrightnessValue = 10
                    brightnessSlider.setValue(_currentBrightnessValue)
                }
                
                let brightness = UInt8(_currentBrightnessValue * Float(Lamp.maxBrightness) / 10.0)
                LampsManager.sharedInstance.setBrightness(brightness, to: self.lampId)
                
            } else {
                onOffButton.setBackgroundImageNamed("OFF")
                brightnessSlider.setColor(UIColor.offColor)
                let brightness = UInt8(0)
                LampsManager.sharedInstance.setBrightness(brightness, to: self.lampId)
            }
        }
    }

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        self.setTitle("Lamps")
        crownSequencer.delegate = self
        LampsManager.sharedInstance.delegate = self
                
        if let lamp = context as? Lamp {
            self.noLampsLabel.setHidden(true)
            self.lampGroup.setHidden(false)
            
            self.lampId = lamp.id
            nameLabel.setText(lamp.name)
            
            _currentBrightnessValue = Float(lamp.brightnessPercentage) / 10.0
            brightnessSlider.setValue(_currentBrightnessValue)
            isOn = (lamp.brightness > 0)
            
        } else {
            self.noLampsLabel.setHidden(false)
            self.lampGroup.setHidden(true)
        }
    }
    
    override func willActivate() {
        super.willActivate()
        
        crownSequencer.focus()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    private func reloadData() {
        print(#function)
        let namesAndContexts = LampsManager.sharedInstance.lamps.map { return (name: "LampPage", context: $0 as AnyObject)}
        
        if namesAndContexts.isEmpty {
            WKInterfaceController.reloadRootControllers(withNamesAndContexts: [(name: "LampPage", context: "nothing" as AnyObject)])
            
        } else {
            WKInterfaceController.reloadRootControllers(withNamesAndContexts: namesAndContexts)
        }
    }
    
    @IBAction func didChangeSlider(_ value: Float) {
        print(value)
        _currentBrightnessValue = value
        isOn = (value != 0.0)
    }
    
    @IBAction func onOffButtonTouched() {
        isOn = !isOn
    }
}

extension UIColor {
    static var onColor: UIColor {
        return UIColor(red: 241/255, green: 196/255, blue: 0/255, alpha: 1)
    }
    
    static var offColor: UIColor {
        return UIColor(red: 236/255, green: 240/255, blue: 241/255, alpha: 1)
    }
}

extension LampInterfaceController: WKCrownDelegate {
    func crownDidRotate(_ crownSequencer: WKCrownSequencer?, rotationalDelta: Double) {
        let currentValue = self._currentBrightnessValue
        
        if rotationalDelta > 0.1 && currentValue < 10 {
            self.brightnessSlider.setValue(currentValue + 1)
            self.didChangeSlider(currentValue + 1)
            
        } else if rotationalDelta < -0.1 && currentValue > 0 {
            self.brightnessSlider.setValue(currentValue - 1)
            self.didChangeSlider(currentValue - 1)
        }
    }
}

extension LampInterfaceController: LampsManagerDelegate {
    func didConnect() {
        print(#function)
        self.reloadData()
    }
    
    func didDisconnect() {
        print(#function)
        self.reloadData()
    }
    
    func didReceiveNewBrightness() {
        print(#function)
        self.reloadData()
    }
}
