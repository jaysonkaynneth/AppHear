//
//  audioplayingview.swift
//  AppHear
//
//  Created by Jason Kenneth on 14/11/22.
//

import SwiftUI
import AVKit
import AVFoundation
import Combine

class audioSettings: ObservableObject {
    
    var audioPlayer: AVAudioPlayer?
    var playing = false
    @Published var playValue: TimeInterval = 0.0
    var playerDuration: TimeInterval = 3
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    
    func playSound(sound: String, type: String) {
//        if let path = Bundle.main.path(forResource: sound, ofType: type)
        if let path = Bundle.main.url(forResource: "audio", withExtension: ".m4a")
        {
            do {
                if playing == false {
                    if (audioPlayer == nil) {
                        
                        
//                        audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                        audioPlayer = try AVAudioPlayer(contentsOf: path)
                        audioPlayer?.prepareToPlay()
                        
                        audioPlayer?.play()
                        playing = true
                    }
                    
                }
                if playing == false {
                    
                    audioPlayer?.play()
                    playing = true
                }
                
                
            } catch {
                print("Could not find and play the sound file.")
            }
        }
        
    }
    
    func stopSound() {
        //   if playing == true {
        audioPlayer?.stop()
        audioPlayer = nil
        playing = false
        playValue = 0.0
        //   }
    }
    
    func pauseSound() {
        if playing == true {
            audioPlayer?.pause()
            playing = false
        }
    }
    
    func changeSliderValue() {
        if playing == true {
            pauseSound()
            audioPlayer?.currentTime = playValue
            
        }
        
        if playing == false {
            audioPlayer?.play()
            playing = true
        }
    }
}

struct audioplayingview: View {
    
    @ObservedObject var audiosettings = audioSettings()
    @State private var playButton: Image = Image(systemName: "play.circle")
    
    var body: some View {
        
        VStack {
            HStack {
                Button(action: {
                    if (self.playButton == Image(systemName: "play.circle")) {
                        print("All Done")
                        self.audiosettings.playSound(sound: "filename", type: "wav")
                        self.audiosettings.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                        self.playButton = Image(systemName: "pause.circle")
                        
                    } else {
                        
                        self.audiosettings.pauseSound()
                        self.playButton = Image(systemName: "play.circle")
                    }
                }) {
                    self.playButton
                        .foregroundColor(Color.blue)
                        .font(.system(size: 44))
                }
                Button(action: {
                    print("All Done")
                    self.audiosettings.stopSound()
                    self.playButton = Image(systemName: "play.circle")
                    self.audiosettings.playValue = 0.0
                    
                }) {
                    Image(systemName: "stop.circle")
                        .foregroundColor(Color.blue)
                        .font(.system(size: 44))
                }
            }
            Slider(value: $audiosettings.playValue, in: TimeInterval(0.0)...audiosettings.playerDuration, onEditingChanged: { _ in
                self.audiosettings.changeSliderValue()
            })
            .onReceive(audiosettings.timer) { _ in
                
                if self.audiosettings.playing {
                    if let currentTime = self.audiosettings.audioPlayer?.currentTime {
                        self.audiosettings.playValue = currentTime
                        
                        if currentTime == TimeInterval(0.0) {
                            self.audiosettings.playing = false
                        }
                    }
                    
                }
                else {
                    self.audiosettings.playing = false
                    self.audiosettings.timer.upstream.connect().cancel()
                }
            }
        }
    }
}

struct audioplayingview_Previews: PreviewProvider {
    static var previews: some View {
        audioplayingview()
    }
}
