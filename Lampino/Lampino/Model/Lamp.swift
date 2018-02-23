//
//  Lamp.swift
//  Lampino
//
//  Created by Victor S Melo on 20/02/18.
//  Copyright © 2018 Victor S Melo. All rights reserved.
//

struct Lamp {
    
    static var maxBrightness: Int = 100
    
    var id: UInt8
    var name: String
    var brightness: UInt8
    var brightnessPercentage: Int {
        return Int(brightness)*100/Lamp.maxBrightness
    }
}
