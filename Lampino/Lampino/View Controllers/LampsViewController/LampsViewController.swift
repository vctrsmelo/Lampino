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
        Lamp.init(id: UInt8(0), name: "Lamp 0", brightness: 50),
        Lamp.init(id: UInt8(1), name: "Lamp 1", brightness: 60),
        Lamp.init(id: UInt8(2), name: "Lamp 2", brightness: 100),
        Lamp.init(id: UInt8(3), name: "Lamp 3", brightness: 0),
        Lamp.init(id: UInt8(4), name: "Lamp 4", brightness: 90),
        Lamp.init(id: UInt8(5), name: "Lamp 5", brightness: 100),
        Lamp.init(id: UInt8(6), name: "Lamp 6", brightness: 20),
        Lamp.init(id: UInt8(7), name: "Lamp 7", brightness: 70),
        Lamp.init(id: UInt8(8), name: "Lamp 8", brightness: 50)
    ]
    
    @IBOutlet weak var lampsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let lampConfiguration = segue.destination as? LampConfigurationViewController {
            
            guard let sender = sender as? Lamp else { return }
            lampConfiguration.lamp = sender
            lampConfiguration.delegate = self
    
        }
        
    }
    

}

extension LampsViewController: LampConfigurationViewControllerDelegate {
    
    func didUpdate(lamp: Lamp) {
        guard let index = lamps.index(where: {$0.id == lamp.id }) else { return }
        lamps[index] = lamp
        print("configured lamp named \(lamp.name)")
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "lampConfiguration", sender: lamps[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = self.lampsCollectionView.frame.width/2
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
}