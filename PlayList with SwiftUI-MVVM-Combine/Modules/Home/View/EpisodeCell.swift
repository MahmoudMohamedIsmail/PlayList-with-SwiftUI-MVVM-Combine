//
//  ProductCell.swift
//  SwiftUI-MVVM-Combine
//
//  Created by Mahmoud Ismail on 22/11/2023.
//

import SwiftUI

struct EpisodeCell<Model>: View where Model: Downloadable {
    
    private let episode: Episode
    @State private var image: UIImage = UIImage()
    @State private var showLoading: Bool = true
    @ObservedObject private var viewModel: Model
    
    @State var isPlaying: Bool = false
    
    init(episode: Episode, viewModel: Model) {
        self.episode = episode
        self.viewModel = viewModel
    }
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 76, height: 76)
                    .cornerRadius(10)
                    .onChange(of: viewModel.cachedHomePhotos) { cachedPhotos in
                        guard let data: Data = cachedPhotos[(episode.image) ?? ""] as? Data,
                              let photo: UIImage = UIImage(data: data) else {
                            showLoading = true
                            return }
                        showLoading = false
                        image = photo
                    }
            }.overlay {
                if showLoading {
                    ProgressView()
                }
            }
            
            VStack(alignment: .leading) {
                HStack {
                    Text(episode.name ?? "")
                        .applyTitleStyle()
                        .lineLimit(1)
                        .foregroundColor(AppColors.primaryText)
                    
                    Spacer()
                    
                    HStack(spacing: .zero) {
                        Button(action: {
                            episode.play()
                            isPlaying.toggle()
                        }) {
                            Image(isPlaying ? "pause_fill_icon" : "play_fill_icon")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(4)
                        }
                        .frame(width: 32, height: 32)
                        .clipShape(Circle())
                        
                        Button(action: {
                            print("More Button tapped!")
                        }) {
                            Image("vertically_more_icon")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(4)
                        }
                        .frame(width: 32, height: 32)
                        .clipShape(Circle())
                    }
                    
                }
                VStack(alignment: .leading, spacing: 6) {
                    
                    Text(episode.podcastName ?? "")
                        .applyBodyStyle()
                        .lineLimit(1)
                        .foregroundColor(AppColors.secondaryText)
                    
                    Text(episode.episodeInfo)
                        .applyCalloutStyle()
                        .lineLimit(1)
                        .foregroundColor(AppColors.secondaryText)
                }
            }
        }
        .onAppear {
            guard let url: String = episode.image else { return }
            let isCashed: Bool = viewModel.cachedHomePhotos[url] != nil
            showLoading = isCashed == false
            if isCashed,
               let data: Data = viewModel.cachedHomePhotos[url] as? Data {
                image = UIImage(data: data) ?? UIImage()
            } else {
                viewModel.downloadImage(url)
            }
        }
    }
    
}
