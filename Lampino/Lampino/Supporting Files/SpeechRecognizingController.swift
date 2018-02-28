//
//  SpeechRecognizingController.swift
//  Lampino
//
//  Created by Bruno Scheltzke on 28/02/18.
//  Copyright © 2018 Bruno Scheltzke. All rights reserved.
//

import Foundation
import Speech

class SpeechRecognizingController {
    internal var delegate: SpeechRecognizable!
    
    private let audionEngine = AVAudioEngine()
    private let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    private let request = SFSpeechAudioBufferRecognitionRequest()
    private var recognitionTask: SFSpeechRecognitionTask?
    
    private var lampToModify: UInt8?
    private var lampCommand: UInt8?
    
    private let allLampsToModify: UInt8 = 0
    
    /**
        Start recording and recognizing speech, searching for a lamp and command
    */
    func recordAndRecognizeSpeech() {
        lampToModify = nil
        lampCommand = nil
        
        let recordingFormat = audionEngine.inputNode.outputFormat(forBus: 0)
        audionEngine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
            self.request.append(buffer)
        }
        
        audionEngine.prepare()
        do{
            try audionEngine.start()
        } catch {
            return print(error)
        }
        
        guard let myRecognizer = SFSpeechRecognizer() else {
            return
        }
        
        if !myRecognizer.isAvailable {
            return
        }
        
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { (result, error) in
            if let result = result {
                let bestString = result.bestTranscription.formattedString
                self.checkForLightsOrCommands(from: bestString)
                
            } else if let error = error {
                print(error)
            }
        })
    }
    
    /**
     Manually stop recording and recognizing speech
     */
    func stopRecording() {
        audionEngine.inputNode.removeTap(onBus: 0)
        audionEngine.stop()
        request.endAudio()
        recognitionTask?.cancel()
    }
    
    /**
        Checks if speech recognition is allowed
     
     - Parameter completion: the completion handler with a boolean that says wether recognition was authorized or not
    */
    func checkIfRecognitionIsAuthorized(completion: @escaping (_ : Bool) -> Void) {
        
        SFSpeechRecognizer.requestAuthorization {
            (authStatus) in
            switch authStatus {
            case .authorized:
                print("Speech recognition authorized")
                completion(true)
            case .denied:
                print("Speech recognition authorization denied")
                completion(false)
            case .restricted:
                print("Not available on this device")
                completion(false)
            case .notDetermined:
                print("Not determined")
                SFSpeechRecognizer.requestAuthorization({ (status) in
                    if status == .authorized {
                        completion(true)
                    }
                })
                completion(false)
            }
        }
    }
    
    // MARK: Private Functions
    private func checkForLightsOrCommands(from sentence: String) {
        let wordsSpoken = sentence.split(separator: " ")
        let lastWordSpoken = wordsSpoken.last!
        var secondToLastWordSpoken = ""
        
        if wordsSpoken.count > 1 {
            secondToLastWordSpoken = String(wordsSpoken[wordsSpoken.count - 2])
        }
        
        if lastWordSpoken.last! == "%" {
            let possibleNumber = String(lastWordSpoken).split(separator: "%").first!
            
            if let percentage = Int(possibleNumber), percentage >= 0 && percentage <= 100 {
                lampCommand = UInt8(percentage)
            }
        }
        
        switch lastWordSpoken {
        case "light":
            self.delegate.lampsManager.lamps.forEach { (light) in
                if light.name.lowercased() == secondToLastWordSpoken.lowercased() {
                    lampToModify = light.id
                }
            }
        case "lamp":
            self.delegate.lampsManager.lamps.forEach { (light) in
                if light.name.lowercased() == secondToLastWordSpoken.lowercased() {
                    lampToModify = light.id
                }
            }
        case "lights":
            lampToModify = allLampsToModify
        case "lamps":
            lampToModify = allLampsToModify
        case "every":
            lampToModify = allLampsToModify
        case "all":
            lampToModify = allLampsToModify
        case "on":
            lampCommand = UInt8(100)
        case "off":
            lampCommand = UInt8(0)
        default:
            break
        }
        
        switch secondToLastWordSpoken {
        case "light":
            self.delegate.lampsManager.lamps.forEach { (light) in
                if light.name.lowercased() == lastWordSpoken.lowercased() {
                    lampToModify = light.id
                }
            }
        case "lamp":
            self.delegate.lampsManager.lamps.forEach { (light) in
                if light.name.lowercased() == lastWordSpoken.lowercased() {
                    lampToModify = light.id
                }
            }
        default:
            break
        }
        
        if lampToModify != nil && lampCommand != nil {
            stopRecording()
            
            if lampToModify == allLampsToModify {
                lampToModify = nil
            }
            
            delegate.didFind(command: lampCommand!, forLampId: lampToModify)
        }
    }
}

protocol SpeechRecognizable {
    /**
        The lamp manager that contains the lamps currently connected
    */
    var lampsManager: LampsManager { get set }
    
    /**
        Will be called whenever a lamp and a command is speech recognized
     
     - Parameter command: the command for the lamp from 0 to 100 to set its brightness
     - Parameter id: the lampId of the lamp to be configured. When set to nil, it means all lamps are to be configured
    */
    func didFind(command: UInt8, forLampId id: UInt8?)
    
    //TODO: error understanding command method
    //TODO: timeout method
}
