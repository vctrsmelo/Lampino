//
//  LampCell.swift
//  Lampino Watch Extension
//
//  Created by Rodrigo Cardoso Buske on 06/03/18.
//  Copyright © 2018 Lampino Organization. All rights reserved.
//

import WatchKit

class LampCell: NSObject {
    var lamp: Lamp? {
        didSet {
            self.updateCell()
        }
    }
    
    @IBOutlet private weak var group: WKInterfaceGroup!
    @IBOutlet private weak var name: WKInterfaceLabel!
    @IBOutlet private weak var brightness: WKInterfaceLabel!
    
    private func updateCell() {
        guard let lamp = self.lamp else { return }
        
        if lamp.brightness > 0 {
            self.group.setBackgroundColor(#colorLiteral(red: 0.9459542632, green: 0.7699680924, blue: 0, alpha: 1))
            
        } else {
            self.group.setBackgroundColor(#colorLiteral(red: 0.4784313725, green: 0.5294117647, blue: 0.6196078431, alpha: 1))
        }
        
        self.name.setText(lamp.name)
        self.brightness.setText("\(lamp.brightness)%")
    }
}
