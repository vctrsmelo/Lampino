//
//  Lamp.swift
//  Lampino
//
//  Created by Victor S Melo on 20/02/18.
//  Copyright © 2018 Victor S Melo. All rights reserved.
//

import Foundation

fileprivate let BrightnessValidValues = 0.0...1.0

struct Lamp {

    private var _brightness: Double
    
    /**
     A value between 0.0 and 1.0, including them.
    */
    var brightness: Double {
        get {
            return _brightness
        }
        set {
            if BrightnessValidValues.contains(newValue) {
                _brightness = newValue
            }
        }
    }
}
