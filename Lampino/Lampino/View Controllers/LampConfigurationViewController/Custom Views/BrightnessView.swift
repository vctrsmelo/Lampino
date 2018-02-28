//
//  BrightnessView.swift
//  Lampino
//
//  Created by Victor S Melo on 27/02/18.
//  Copyright © 2018 Lampino Organization. All rights reserved.
//

import UIKit

struct BrightnessColor {
    static let on = UIColor(red: 241/255, green: 196/255, blue: 0, alpha: 1)
    static let off = UIColor.clear
}

class BrightnessView: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1.5
        turnOff()
    }
    
    func turnOn() {
        self.backgroundColor = BrightnessColor.on
    }
    
    func turnOff() {
        self.backgroundColor = BrightnessColor.off
    }
    
}
