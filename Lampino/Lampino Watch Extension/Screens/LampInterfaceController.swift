//
//  LampInterfaceController.swift
//  Lampino Watch Extension
//
//  Created by Victor S Melo on 07/03/18.
//  Copyright © 2018 Lampino Organization. All rights reserved.
//

import WatchKit

class WKLampsManager {
    
    /// is true when the watch extension has already loaded the lamps into UI.
    static var alreadyLoaded = false
}

class LampInterfaceController: WKInterfaceController {
    
    @IBOutlet var nameLabel: WKInterfaceLabel!
    @IBOutlet var onOffButton: WKInterfaceButton!
    @IBOutlet var brightnessSlider: WKInterfaceSlider!
    
    private var _currentBrightnessValue: Float!
    
    private var isOn: Bool! {
        didSet {
            if oldValue == isOn {
                return
            }
            
            if isOn {
                onOffButton.setBackgroundImageNamed("ON")
                brightnessSlider.setColor(UIColor.onColor)
                

                if var _currentBrightnessValue = _currentBrightnessValue {
                    if _currentBrightnessValue == 0 {
                        _currentBrightnessValue = 10
                        brightnessSlider.setValue(_currentBrightnessValue)
                    }
                    lamp.brightness = UInt8(_currentBrightnessValue*Float(Lamp.maxBrightness)/10.0)
                    LampsManager.sharedInstance.setBrightness(lamp.brightness, to: lamp.id)
                }
                
            } else {
                onOffButton.setBackgroundImageNamed("OFF")
                brightnessSlider.setColor(UIColor.offColor)
                lamp.brightness = 0
                LampsManager.sharedInstance.setBrightness(lamp.brightness, to: lamp.id)
            }
        }
    }
    
    var lamp: Lamp! {
        didSet {
            nameLabel.setText(lamp.name)
        }
    }

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        self.setTitle("Lamps")
        
        if let lamp = context as? Lamp {
            self.lamp = lamp
            _currentBrightnessValue = Float(lamp.brightnessPercentage)/10.0
            brightnessSlider.setValue(_currentBrightnessValue)
            isOn = (lamp.brightness > 0)
        }
        
        if WKLampsManager.alreadyLoaded {
            return
        }
        
        WKLampsManager.alreadyLoaded = true
        
        let namesAndContexts = LampsManager.sharedInstance.lamps.map { return (name: "LampPage", context: $0 as AnyObject)}
        WKInterfaceController.reloadRootControllers(withNamesAndContexts: namesAndContexts)

    }
    
    override func willActivate() {
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }
    
    @IBAction func didChangeSlider(_ value: Float) {
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
