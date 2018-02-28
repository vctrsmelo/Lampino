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
        Lamp.init(id: UInt8(0), name: "First Lamp", brightness: 50),
        Lamp.init(id: UInt8(1), name: "Second Lamp", brightness: 60),
        Lamp.init(id: UInt8(2), name: "Third Lamp", brightness: 100),
        Lamp.init(id: UInt8(3), name: "Fourth Lamp", brightness: 0),
        Lamp.init(id: UInt8(4), name: "Fifth Lamp", brightness: 90),
        Lamp.init(id: UInt8(5), name: "Sixth Lamp", brightness: 100),
        Lamp.init(id: UInt8(6), name: "Seventh Lamp", brightness: 20),
        Lamp.init(id: UInt8(7), name: "Eigth Lamp", brightness: 70),
        Lamp.init(id: UInt8(8), name: "Nineth Lamp", brightness: 50)
    ]
    
    @IBOutlet weak var lampsCollectionView: UICollectionView!
    
    @IBOutlet weak var microphoneButton: UIBarButtonItem!
    var isMicButtonSelected = false
    let blueColor = UIColor(red: 52/255, green: 73/255, blue: 94/255, alpha: 1)
    let yellowColor = UIColor(red: 241/255, green: 196/255, blue: 0, alpha: 1)
    
    var lampsManager: LampsManager = LampsManager()
    
    let speechController = SpeechRecognizingController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        speechController.delegate = self
        lampsManager.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let lampConfiguration = segue.destination as? LampConfigurationViewController {
            
            guard let sender = sender as? Lamp else { return }
            lampConfiguration.lamp = sender
            lampConfiguration.delegate = self
    
        }

    }
    
    @IBAction func didPressMicrophoneButton(_ sender: UIBarButtonItem) {
        speechController.checkIfRecognitionIsAuthorized { (isAuthorized) in
            if isAuthorized {
                switch self.isMicButtonSelected {
                case false:
                    self.speechController.recordAndRecognizeSpeech()
                    DispatchQueue.main.async {
                        self.turnMicOn()
                    }
                case true:
                    self.speechController.stopRecording()
                    DispatchQueue.main.async {
                        self.turnMicOff()
                    }
                }
            }
        }
    }
    
    fileprivate func turnMicOff() {
        microphoneButton.tintColor = blueColor
        isMicButtonSelected = false
    }
    
    fileprivate func turnMicOn() {
        microphoneButton.tintColor = yellowColor
        isMicButtonSelected = true
    }
}

extension LampsViewController: SpeechRecognizable {
    func didFind(command: UInt8, forLampId id: UInt8?) {
        lampsManager.updateBrightness(id!, newBrightness: command)
        turnMicOff()
    }
    
    func didTimeout() {
        turnMicOff()
    }
}

extension LampsViewController: LampsManagerDelegate {
    
    func didConnectToCommunicator() {
        
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
