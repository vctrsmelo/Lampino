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
    
    private static var defaultNames = ["Alpha", "Bravo", "Charlie", "Delta", "Echo", "Foxtrot", "Golf", "Hotel", "India", "Juliet", "Kilo", "Lima", "Mike", "November", "Oscar", "Papa", "Quebec", "Romeo", "Sierra", "Tango", "Uniform", "Victor", "Whiskey", "X-ray", "Yankee", "Zulu"]
    
    init(id: UInt8, name: String? = nil, brightness: UInt8 = 0) {
        
        self.id = id
        self.name = name ?? Lamp.defaultNames[Int(id)]
        self.brightness = brightness
    }
}
