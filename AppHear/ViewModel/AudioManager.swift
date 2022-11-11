
import AVFoundation
import AVKit

class AudioManager {
    static let shared = AudioManager()
    
    var audioPlayer: AVAudioPlayer?
    
    func play(url: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue) 
            audioPlayer?.play()
            print("sound is playing")
        } catch let error {
            print("Sound Play Error -> \(error)")
        }
    }
}
