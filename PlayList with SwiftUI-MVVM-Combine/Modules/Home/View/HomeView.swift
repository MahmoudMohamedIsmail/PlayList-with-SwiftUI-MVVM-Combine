//
//  HomeView.swift
//  SwiftUI-MVVM-Combine
//
//  Created by Mahmoud Ismail on 22/11/2023.
//

import SwiftUI

private let defaultPadding: CGFloat = 16

struct HomeView<Model>: View where Model: HomeViewModelInterface {
    
    private let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: defaultPadding), count: 1)
    @ObservedObject var viewModel: Model
    @State private var image: UIImage = UIImage()
    @State private var showLoading: Bool = true
    
    var body: some View {
        VStack {
            ZStack(alignment: .top) {
                
                Image(uiImage: image)
                    .resizable()
                    .frame(height: 375)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .edgesIgnoringSafeArea(.top)
                    .onChange(of: viewModel.cachedHomePhotos) { cachedPhotos in
                        guard let data: Data = cachedPhotos[(viewModel.playlist?.image) ?? ""] as? Data,
                              let photo: UIImage = UIImage(data: data) else {
                            showLoading = true
                            return }
                        showLoading = false
                        image = photo
                    }
                    .overlay {
                        if showLoading {
                            ProgressView()
                        }
                    }
                
                VStack(alignment: .leading) {
                    HStack {
                        Button(action: {
                            print("Back Button tapped!")
                        }) {
                            Image("back_icon")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(10)
                        }
                        .applyBlurredStyle()
                        .applyRoundedBorderStyle()
                        .frame(width: 39, height: 39)
                        
                        Spacer()
                        
                        HStack(spacing: 11) {
                            Button(action: {
                                print("Favorit Button tapped!")
                            }) {
                                Image("favorit_icon")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .padding(8)
                            }
                            .applyBlurredStyle()
                            .applyRoundedBorderStyle()
                            .frame(width: 39, height: 39)
                            
                            Button(action: {
                                print("More Button tapped!")
                            }) {
                                Image("horizontally_more_icon")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .padding(8)
                                
                            }
                            .applyBlurredStyle()
                            .applyRoundedBorderStyle()
                            .frame(width: 39, height: 39)
                            
                        }
                        
                    }
                    .padding(.top, 4)
                    .padding(.horizontal, 16)
                    
                    VStack(alignment: .leading, spacing: 32) {
                        Text(viewModel.playlist?.name ?? "")
                            .applyHeaderTitleStyle()
                            .lineLimit(2)
                            .foregroundColor(.white)
                        
                        Text(viewModel.playlist?.description ?? "")
                            .applySubHeaderTitleStyle()
                            .lineLimit(3)
                            .foregroundColor(.white)
                    }
                    .padding(22)
                    
                    HStack {
                        Button(action: {
                            print("Other Button tapped!")
                        }) {
                            HStack(spacing: 4) {
                                Image("others_icon")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 19, height: 19)
                                
                                Text("تشغيل متنوع")
                                    .applyButtonTitleStyle()
                                    .lineLimit(1)
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal, 32)
                        }
                        .frame(height: 39)
                        .background(AppColors.primary)
                        .cornerRadius(19.5)
                        
                        Spacer()
                        
                        HStack(spacing: 11) {
                            Button(action: {
                                print("Download Button tapped!")
                            }) {
                                Image("down_arrow_icon")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .padding(11)
                            }
                            .frame(width: 39, height: 39)
                            .background(AppColors.primary)
                            .clipShape(Circle())
                            
                            Button(action: {
                                print("Play Button tapped!")
                            }) {
                                Image("play_icon")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .padding(11)
                            }
                            .frame(width: 39, height: 39)
                            .background(AppColors.primary)
                            .clipShape(Circle())
                        }
                    }
                    .padding(.vertical, 24)
                    .padding(.leading, 22)
                    .padding(.trailing, 16)
                    
                    VStack {
                        HStack(alignment: .center) {
                            Text("الحلقات")
                                .applySectionHeaderTitleStyle()
                                .lineLimit(1)
                                .foregroundColor(AppColors.primaryText)
                            
                            Spacer()
                            
                            Text(viewModel.playlist?.playlistInfo ?? "")
                                .applySubHeaderTitleStyle()
                                .lineLimit(3)
                                .foregroundColor(AppColors.secondary)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        Divider().padding(.horizontal, 20)
                        
                        List {
                            ForEach(viewModel.episodes) { episode in
                                EpisodeCell(episode: episode, viewModel: viewModel)
                            }
                        }
                        .listStyle(.plain)
                    }.background(.white)
                        .cornerRadius(10, corners: [.topLeft, .topRight])
                }
                
            }        
            .applyHiddenStyle(isHidden: viewModel.showLoading)

        }
        .overlay {
            if viewModel.showLoading {
                ProgressView()
            }
        }
        .onAppear {
            viewModel.fetchHomeData()
        }
    }
}
