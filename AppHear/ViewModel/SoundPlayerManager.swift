//
//  SoundPlayerManager.swift
//  AppHear
//
//  Created by Jason Kenneth on 07/11/22.
//

import AVKit
import AVFoundation

class SoundPlayerManager : ObservableObject {
    var audioPlayer: AVPlayer?

    func playSound(sound: String){
        if let url = URL(string: sound) {
            self.audioPlayer = AVPlayer(url: url)
        }
    }
}
