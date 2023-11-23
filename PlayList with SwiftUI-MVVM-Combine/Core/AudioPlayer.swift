//
//  AudioPlayer.swift
//  SwiftUI-MVVM-Combine
//
//  Created by Mahmoud Ismail on 23/11/2023.
//

import Foundation
import AVFoundation
import Combine

class AudioManager: ObservableObject {
    
    static let shared: AudioManager = AudioManager()
    
    private var audioPlayer: AVPlayer?
    private var cancellables: Set<AnyCancellable> = []
    private var urlAudio: String = ""

    @Published var isPlaying: Bool = false

    func play(from url: URL) {
        pause()
        let playerItem = AVPlayerItem(url: url)
        audioPlayer = AVPlayer(playerItem: playerItem)
        urlAudio = url.absoluteString
        audioPlayer?.play()
        isPlaying = true
    }

    func pause() {
        audioPlayer?.pause()
        isPlaying = false
    }

    func stop() {
        audioPlayer?.pause()
        audioPlayer?.seek(to: CMTime.zero)
        isPlaying = false
    }
    
    func isCurrentAudio(url: URL) -> Bool {
        urlAudio == url.absoluteString
    }
}
