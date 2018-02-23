//
//  LampsViewController.swift
//  Lampino
//
//  Created by Victor S Melo on 23/02/18.
//  Copyright © 2018 Lampino Organization. All rights reserved.
//

import UIKit

class LampsViewController: UIViewController {
    
    private var lamps: [Lamp] = [
        Lamp.init(id: UInt8(0), name: "Lamp 0", brightness: 80),
        Lamp.init(id: UInt8(1), name: "Lamp 1", brightness: 80),
        Lamp.init(id: UInt8(2), name: "Lamp 2", brightness: 80),
        Lamp.init(id: UInt8(3), name: "Lamp 3", brightness: 80),
        Lamp.init(id: UInt8(3), name: "Lamp 3", brightness: 80),
        Lamp.init(id: UInt8(3), name: "Lamp 3", brightness: 80),
        Lamp.init(id: UInt8(3), name: "Lamp 3", brightness: 80),
        Lamp.init(id: UInt8(3), name: "Lamp 3", brightness: 80),
        Lamp.init(id: UInt8(3), name: "Lamp 3", brightness: 80),
        Lamp.init(id: UInt8(3), name: "Lamp 3", brightness: 80),
        Lamp.init(id: UInt8(3), name: "Lamp 3", brightness: 80),
        Lamp.init(id: UInt8(3), name: "Lamp 3", brightness: 80),
        Lamp.init(id: UInt8(3), name: "Lamp 3", brightness: 80)
    ]
    
    @IBOutlet weak var lampsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension LampsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lamps.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "lampCell", for: indexPath) as? LampCollectionViewCell else {
            fatalError("Could not dequeue Lamp Cell")
        }
        
        cell.configure(lamp: lamps[indexPath.row])
        
        return cell
    }
    
}
