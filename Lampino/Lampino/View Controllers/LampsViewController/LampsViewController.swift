//
//  LampsViewController.swift
//  Lampino
//
//  Created by Victor S Melo on 23/02/18.
//  Copyright © 2018 Lampino Organization. All rights reserved.
//

import UIKit

class LampsViewController: UIViewController {
    
    private var lampsManager: LampsManager!
    
    @IBOutlet weak var lampsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lampsManager = LampsManager(delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let lampConfiguration = segue.destination as? LampConfigurationViewController {
            guard let sender = sender as? Lamp else { return }
            lampConfiguration.lamp = sender
        }
    }
}

extension LampsViewController: LampsManagerDelegate {
    func didConnect() {
        // TODO: user feedback
        self.lampsCollectionView.reloadData()
    }
    
    func didDisconnect() {
        // TODO user feedback
        self.lampsCollectionView.reloadData()
    }
    
    func updatedLamps() {
        self.lampsCollectionView.reloadData()
    }
}

extension LampsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.lampsManager.lamps.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "lampCell", for: indexPath) as? LampCollectionViewCell else {
            fatalError("Could not dequeue Lamp Cell")
        }
        
        cell.configure(lamp: self.lampsManager.lamps[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "lampConfiguration", sender: self.lampsManager.lamps[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = self.lampsCollectionView.frame.width/2
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
}
