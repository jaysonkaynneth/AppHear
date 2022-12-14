//
//  SpeechRecognitionManager.swift
//  AppHear
//
//  Created by Jason Kenneth on 18/10/22.
//

import Foundation
import Speech
import SwiftUI

class SpeechRecManager {
    public var isRecording = false
    @State var transcript = "Transcript will be shown here"
    private var audioEngine: AVAudioEngine!
    private var inputNode: AVAudioInputNode!
    private var audioSession: AVAudioSession!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    
    func checkPermissions() {
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            DispatchQueue.main.async {
                switch authStatus {
                case .authorized: break
                default: print("speech recognition needs permission")
                }
            }
        }
    }
    func start(completion: @escaping (String?) -> Void) {
        if isRecording {
            stopRecording()
        } else {
            startRecording(completion: completion)
        }
    }
    
    func startRecording(completion: @escaping (String?) -> Void) {
        guard let recognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "id-ID")),recognizer.isAvailable else {
            print("Speech recognition isnt available")
            return
        }
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        recognitionRequest?.shouldReportPartialResults = true
        recognizer.recognitionTask(with: recognitionRequest!) { (result, error) in
            var isFinal = false
            guard error == nil else {
                print("error \(error!.localizedDescription)")
                return
            }
            if result != nil {
                self.transcript = result?.bestTranscription.formattedString ?? "No transcript was made"
                isFinal = (result?.isFinal)!
            }
            if isFinal {
                self.stopRecording()
            }
        }
        
        audioEngine = AVAudioEngine()
        inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) {(buffer, _) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.record, mode: .spokenAudio, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            try audioEngine.start()
        } catch {
            print(error)
        }
    }
    
    func stopRecording() {
        recognitionRequest?.endAudio()
        recognitionRequest = nil
        audioEngine.stop()
        inputNode.removeTap(onBus: 0)
        //        try? audioSession.setActive(false)
        audioSession = nil
        print(transcript)
    }
}

