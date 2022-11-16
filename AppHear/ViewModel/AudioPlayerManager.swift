//
//  AudioPlayerViewModel.swift
//  AppHear
//
//  Created by Jason Kenneth on 06/11/22.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation
import AVKit

class AudioPlayerManager: NSObject, ObservableObject, AVAudioPlayerDelegate {

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    func getAudioURL() -> URL {
        return getDocumentsDirectory().appendingPathComponent("audio.m4a")
        //return getDocumentsDirectory().appendingPathComponent("\(title).m4a")
    }

    func getAudioDuration() -> Double {
        let audio = AVURLAsset(url: getAudioURL())
        return Double(floor(CMTimeGetSeconds(audio.duration)))
    }

   
    var isPlaying = false
    var audioPlayer: AVAudioPlayer?
    @Published var playValue: TimeInterval = 0.0
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    func play(audio: URL) {
        let playbackSession = AVAudioSession.sharedInstance()

        do {
            try playbackSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch {
            print("Playing over the device's speakers failed")
        }

        do {
            if isPlaying == false {
                if (audioPlayer == nil) {

                    audioPlayer = try AVAudioPlayer(contentsOf: audio)
                    audioPlayer?.delegate = self
                    audioPlayer?.prepareToPlay()
                    audioPlayer?.play()
                    isPlaying = true
                }
            }
            if isPlaying == false {

                audioPlayer?.play()
                isPlaying = true
            }
        } catch let error {
            print("Playback failed because \(error.localizedDescription).")
        }
    }

    func pause() {
        if isPlaying == true {
            audioPlayer?.pause()
            isPlaying = false
        }
    }

    func sliderValue() {
        if isPlaying == true {
            pause()
            audioPlayer?.currentTime = playValue

        }

        if isPlaying == false {
            audioPlayer?.play()
            isPlaying = true
        }

    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            isPlaying = false
        }
    }


}


