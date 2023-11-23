//
//  HomeResponse.swift
//  SwiftUI-MVVM-Combine
//
//  Created by Mahmoud Ismail on 22/11/2023.
//

import Foundation

// MARK: - HomeResponse
struct HomeResponse: Codable {
    let data: HomeResponseData?
}

// MARK: - DataClass
struct HomeResponseData: Codable {
    let playlist: Playlist?
    let episodes: [Episode]?
}

// MARK: - Episode
class Episode: Codable, Identifiable {
    let id, itunesID: String?
    let type: Int?
    let name, description: String?
    let image, imageBigger: String?
    let audioLink: String?
    let duration, durationInSeconds, views: Int?
    let podcastItunesID, podcastName, releaseDate, createdAt: String?
    let updatedAt: String?
    let isDeleted: Bool?
    let chapters: [Chapter]?
    let isEditorPick, sentNotification: Bool?
    let position: Int?
    
    var convertedDate: String {
        updatedAt?.convertDateString() ?? ""
    }
    
    var episodeInfo: String {
        let minutes: Int = Int(durationInSeconds ?? 0) / 60
        return convertedDate + " . " + "\(minutes) دقيقة"
    }
    
    @Published var player: AudioManager = AudioManager.shared
    @Published var isPlaying: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id
        case itunesID = "itunesId"
        case type, name, description, image, imageBigger, audioLink, duration, durationInSeconds, views
        case podcastItunesID = "podcastItunesId"
        case podcastName, releaseDate, createdAt, updatedAt, isDeleted, chapters, isEditorPick, sentNotification, position
    }
    
    func play() {
        guard let audioUrl = URL(string: audioLink ?? "") else { return }
        if player.isCurrentAudio(url: audioUrl) {
            if player.isPlaying {
                player.pause()
                isPlaying = false
            } else {
                player.play(from: audioUrl)
                isPlaying = true
            }
        } else {
            player.play(from: audioUrl)
            isPlaying = true
        }
    }
}

// MARK: - Playlist
struct Playlist: Codable {
    let id: String?
    let type: Int?
    let name, description: String?
    let image: String?
    let access, status: String?
    let episodeCount, episodeTotalDuration: Int?
    let createdAt, updatedAt: String?
    let isDeleted: Bool?
    let followingCount: Int?
    let userID: String?
    let isSubscribed: Bool?
    
    var playlistInfo: String {
        guard (episodeCount ?? .zero ) > .zero else { return "" }
        let hours: Int = Int(episodeTotalDuration ?? 0) / 3600 // seconds per hour
        var hoursInfo: String = String(hours)
        hoursInfo.append(hours > 2 ? "ساعة": "ساعات")
        return "\(episodeCount ?? .zero)حلقة.\(hoursInfo)"
    }

    enum CodingKeys: String, CodingKey {
        case id, type, name, description, image, access, status, episodeCount, episodeTotalDuration, createdAt, updatedAt, isDeleted, followingCount
        case userID = "userId"
        case isSubscribed
    }
    
}

// MARK: - Chapter
struct Chapter: Codable {
    let start: Int?
    let title: String?
}
