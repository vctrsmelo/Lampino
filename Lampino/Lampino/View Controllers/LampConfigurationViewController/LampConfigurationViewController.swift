//
//  LampConfigurationViewController.swift
//  Lampino
//
//  Created by Victor S Melo on 23/02/18.
//  Copyright © 2018 Lampino Organization. All rights reserved.
//

import UIKit

protocol LampConfigurationViewControllerDelegate {
    func didUpdate(lamp: Lamp)
}

class LampConfigurationViewController: UIViewController {

    @IBOutlet weak var lampNameTextField: UITextField!
    @IBOutlet weak var brightnessPercentageLabel: UILabel!
    @IBOutlet weak var brightnessSliderView: BrightnessSliderView!

    @IBOutlet weak var onOffButton: UIButton!
    
    private var isOn: Bool! {
        didSet{
            guard let lamp = lamp else {
                setButtonOff()
                return
            }
            
            if lamp.brightnessPercentage > 0 {
                setButtonOn()
            } else {
                setButtonOff()
            }
        }
    }
    
    var lamp: Lamp?
    var delegate: LampConfigurationViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("""
            Lamp Configuration called:
            \(lamp?.name ?? "NO NAME")
            \(lamp?.brightnessPercentage ?? -1)%
        """)
        brightnessSliderView.delegate = self

        guard let lamp = lamp else { return }
        brightnessPercentageLabel.text = "\(lamp.brightnessPercentage)%"
        
        isOn = (lamp.brightnessPercentage > 0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let lamp = lamp else { return }
        delegate?.didUpdate(lamp: lamp)
    }
    
    private func setButtonOn() {
        onOffButton.setTitle("ON", for: .normal)
        onOffButton.backgroundColor = BrightnessColor.on
    }
    
    private func setButtonOff() {
        onOffButton.setTitle("OFF", for: .normal)
        onOffButton.backgroundColor = BrightnessColor.off
    }
    
}

extension LampConfigurationViewController: BrightnessSliderViewDelegate {
    
    func didChangePercentValue(_ newValue: Int) {
        self.lamp?.brightness = UInt8(newValue)
        brightnessPercentageLabel.text = "\(newValue)%"
        isOn = (newValue > 0)
    }

}
