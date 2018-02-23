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

    var lamp: Lamp?
    var delegate: LampConfigurationViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("""
            Lamp Configuration called:
            \(lamp?.name ?? "NO NAME")
            \(lamp?.brightnessPercentage ?? -1)%
        """)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let lamp = lamp else { return }
        delegate?.didUpdate(lamp: lamp)
    }
    
    
    
}
