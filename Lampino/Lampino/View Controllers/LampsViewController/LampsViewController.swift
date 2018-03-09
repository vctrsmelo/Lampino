//
//  LampsViewController.swift
//  Lampino
//
//  Created by Victor S Melo on 23/02/18.
//  Copyright © 2018 Lampino Organization. All rights reserved.
//

import UIKit

class LampsViewController: UIViewController {
    
    @IBOutlet weak var lampsCollectionView: UICollectionView!
    
    @IBOutlet weak var microphoneButton: UIBarButtonItem!
    
    let loadingComponent = LoadingComponent()
    
    var isMicButtonSelected = false
    let blueColor = UIColor(red: 52/255, green: 73/255, blue: 94/255, alpha: 1)
    let yellowColor = UIColor(red: 241/255, green: 196/255, blue: 0, alpha: 1)
    
    let lampsManager = LampsManager.sharedInstance
    
    let speechController = SpeechRecognizingController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadingComponent.addLoadingIndicator(to: self.view)
        
        let navigationBar = self.navigationController?.navigationBar
        navigationBar?.setBackgroundImage(UIImage(), for: .default)
        navigationBar?.shadowImage = UIImage()
        navigationBar?.isTranslucent = true
        
        speechController.delegate = self
        lampsManager.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.statusBarStyle = .default
        
        self.navigationController?.navigationBar.tintColor = self.blueColor
        
        self.lampsCollectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let lampConfiguration = segue.destination as? LampConfigurationViewController {
            guard let sender = sender as? Lamp else { return }
            lampConfiguration.lamp = sender
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
        lampsManager.setBrightness(command, to: id)
        turnMicOff()
    }
    
    func didTimeout() {
        turnMicOff()
    }
}

extension LampsViewController: LampsManagerDelegate {
    func didConnect() {
        self.loadingComponent.removeLoadingIndicators(from: self.view)
        self.lampsCollectionView.reloadData()
    }
    
    func didDisconnect() {
        self.loadingComponent.addLoadingIndicator(to: self.view)
        self.lampsCollectionView.reloadData()
    }
    
    func didReceiveNewBrightness() {
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
