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
    @IBOutlet var onOffSwitch: WKInterfaceSwitch!
    
    @IBOutlet var brightnessSlider: WKInterfaceSlider!
    
    var lamp: Lamp! {
        didSet {
            nameLabel.setText(lamp.name)
            
            if lamp.brightness > 0 {
                onOffSwitch.setOn(true)
                onOffSwitch.setTitle("ON")
            } else {
                onOffSwitch.setOn(false)
                brightnessSlider.setHidden(true)
                onOffSwitch.setTitle("OFF")
            }
            brightnessSlider.setValue(Float(lamp.brightness))
        }
    }

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if let lamp = context as? Lamp {
        
            self.lamp = lamp
        
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
    
    @IBAction func didChangeOnOffSwitch(_ value: Bool) {
        if value {
            brightnessSlider.setHidden(false)
            onOffSwitch.setTitle("ON")
            brightnessSlider.setValue(10)
        } else {
            brightnessSlider.setHidden(true)
            onOffSwitch.setTitle("OFF")
            brightnessSlider.setValue(0)
        }
    }
    
    @IBAction func didChangeSlider(_ value: Float) {
        
        if value == 0.0 {
            onOffSwitch.setTitle("OFF")
            onOffSwitch.setOn(false)
        } else {
            onOffSwitch.setTitle("ON")
            onOffSwitch.setOn(true)
        }
    }
}
