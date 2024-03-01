//
//  AudioManager.swift
//  Peggle
//
//  Created by Muhammad Reyaaz on 1/3/24.
//

import Foundation
import AVFoundation

class AudioManager: ObservableObject {
    static let shared = AudioManager()

    var audioPlayer: AVAudioPlayer?
    var isPlaying: Bool = false
    var isLooping: Bool = false

    init() {}

    func play(fileName: String, isLooping: Bool = false) {
        self.isLooping = isLooping
        if let soundURL = Bundle.main.url(forResource: fileName, withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.numberOfLoops = isLooping ? -1 : 0
                audioPlayer?.play()
                isPlaying = true
            } catch {
                print("Error loading sound file: \(error.localizedDescription)")
            }
        } else {
            print("Sound file not found")
        }
    }

    func pause() {
        audioPlayer?.pause()
        isPlaying = false
    }

    func stop() {
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0
        isPlaying = false
    }
}
