//
//  LampCollectionViewCell.swift
//  Lampino
//
//  Created by Victor S Melo on 23/02/18.
//  Copyright © 2018 Lampino Organization. All rights reserved.
//

import UIKit

class LampCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var lampNameLabel: UILabel!
    @IBOutlet weak var lampOnOffLabel: UILabel!
    @IBOutlet weak var brightnessPercentLabel: UILabel!
    
    
    @IBOutlet weak var brightnessImageView: UIImageView!
    @IBOutlet weak var lampImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        viewContainer.layer.cornerRadius = 10
    }
    
    func configure(lamp: Lamp) {
        lampNameLabel.text = lamp.name
        lampOnOffLabel.text = (lamp.brightness > 0) ? "ON" : "OFF"
        brightnessPercentLabel.text = "\(lamp.brightnessPercentage)%"
        
    }

}
