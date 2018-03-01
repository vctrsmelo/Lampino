//
//  Lamp.swift
//  Lampino
//
//  Created by Victor S Melo on 20/02/18.
//  Copyright © 2018 Victor S Melo. All rights reserved.
//

import Foundation

struct Lamp {
    
    static var maxBrightness: Int = 100
    
    let id: UInt8
    var name: String
    var brightness: UInt8
    var brightnessPercentage: Int {
        return Int(brightness)*100/Lamp.maxBrightness
    }
    
    private static var numberFormatter = NumberFormatter()
    
    init(id: UInt8, name: String? = nil, brightness: UInt8 = 0) {
        Lamp.numberFormatter.numberStyle = .spellOut
        
        self.id = id
        self.name = name ?? Lamp.numberFormatter.string(from: NSNumber(value: id + 1))!
        self.brightness = brightness
    }
}
