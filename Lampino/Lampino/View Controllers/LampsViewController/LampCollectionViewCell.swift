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
    
    private var lamp: Lamp!
    
    @IBOutlet weak var brightnessImageView: UIImageView!
    @IBOutlet weak var lampIconOffImageView: UIImageView!
    @IBOutlet weak var lampIconOnImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        viewContainer.layer.cornerRadius = 15
        
        viewContainer.layer.shadowColor = UIColor.black.cgColor
        viewContainer.layer.shadowOpacity = 0.3
        viewContainer.layer.shadowOffset = CGSize(width: 0, height: 3)
        viewContainer.layer.shadowRadius = 1
        

    }
    
    func configure(lamp: Lamp) {
        self.lamp = lamp
        lampNameLabel.text = lamp.name
        lampOnOffLabel.text = (lamp.brightness > 0) ? NSLocalizedString("ON", comment: "") : NSLocalizedString("OFF", comment: "")
        brightnessPercentLabel.text = "\(lamp.brightnessPercentage)%"
        configureLampIcon()
        
        configureAccessibility()
        
    }
    
    private func configureLampIcon() {
        
        lampIconOnImageView.isHidden = !(lamp.brightness > 0)
        lampIconOffImageView.isHidden = !lampIconOnImageView.isHidden
        
    }
    
    private func configureAccessibility() {
        self.isAccessibilityElement = true
        
        if lamp.brightness > 0 {
            self.accessibilityLabel = "\(NSLocalizedString("Lamp selected. It's name is", comment: "")): \(lamp.name). \(NSLocalizedString("It's on", comment: "")). \(NSLocalizedString("It's current brightness is", comment: "")): \(lamp.brightness)%"
        } else {
            self.accessibilityLabel = "\(NSLocalizedString("Lamp selected. It's name is", comment: "")): \(lamp.name). \(NSLocalizedString("It's off", comment: ""))."
        }
        self.accessibilityHint = NSLocalizedString("Tap to configure", comment: "")
    }
    
}
