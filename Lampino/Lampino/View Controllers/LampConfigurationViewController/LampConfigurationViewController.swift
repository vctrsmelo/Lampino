//
//  LampConfigurationViewController.swift
//  Lampino
//
//  Created by Victor S Melo on 23/02/18.
//  Copyright © 2018 Lampino Organization. All rights reserved.
//

import UIKit

class LampConfigurationViewController: UIViewController {

    @IBOutlet weak var lampNameTextField: UITextField!
    @IBOutlet weak var brightnessPercentageLabel: UILabel!
    @IBOutlet weak var brightnessSliderView: BrightnessSliderView!

    @IBOutlet weak var onOffButton: UIButton!
    
    private var isOn: Bool = false {
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
    
    var lamp: Lamp!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        let navigationBar = self.navigationController?.navigationBar
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        navigationBar?.titleTextAttributes = textAttributes
        navigationBar?.tintColor = UIColor.white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        brightnessSliderView.delegate = self

        guard let lamp = lamp else { return }
        brightnessPercentageLabel.text = "\(lamp.brightnessPercentage)%"
        lampNameTextField.text = lamp.name.uppercased()
        
        isOn = (lamp.brightnessPercentage > 0)
        onOffButton.layer.borderColor = UIColor.white.cgColor
        onOffButton.layer.borderWidth = 3
        onOffButton.layer.cornerRadius = 15

        brightnessSliderView.setPercentValue(lamp.brightnessPercentage)
        
        onOffButton.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    private func setButtonOn() {
        onOffButton.setTitle(NSLocalizedString("ON", comment: ""), for: .normal)
        onOffButton.backgroundColor = BrightnessColor.on
    }
    
    private func setButtonOff() {
        onOffButton.setTitle(NSLocalizedString("OFF", comment: ""), for: .normal)
        onOffButton.backgroundColor = UIColor(red: 122/255, green: 135/255, blue: 158/255, alpha: 1)
    }
    
    @IBAction func didTouchOnOffButton(_ sender: UIButton) {
        isOn ? brightnessSliderView.setPercentValue(0) : brightnessSliderView.setPercentValue(100)
    }
    
}

extension LampConfigurationViewController: BrightnessSliderViewDelegate {
    
    func didChangePercentValue(_ newValue: Int) {
        self.lamp.brightness = UInt8(newValue)
        brightnessPercentageLabel.text = "\(newValue)%"
        isOn = (newValue > 0)
        
        LampsManager.sharedInstance.setBrightness(self.lamp.brightness, to: self.lamp.id)
    }

}
