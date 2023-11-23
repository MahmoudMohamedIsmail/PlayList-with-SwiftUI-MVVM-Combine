//
//  HomeViewModel.swift
//  SwiftUI-MVVM-Combine
//
//  Created by Mahmoud Ismail on 22/11/2023.
//

import Foundation
import SwiftUI
import Combine

protocol HomeViewModelInterface: BaseViewModel, Downloadable {
    var playlist: Playlist? { get set }
    var episodes: [Episode] { get set }
    init(repository: HomeRepositoryInterface)
    func fetchHomeData()
}

protocol Downloadable: ObservableObject {
    var cachedHomePhotos: [String: Data?] { get set }
    func downloadImage(_ url: String)
}

class HomeViewModel: HomeViewModelInterface {
    
    @Published var playlist: Playlist?
    @Published var episodes: [Episode]
    @Published var cachedHomePhotos: [String: Data?]
    @Published var showLoading: Bool
    private var disposables = Set<AnyCancellable>()
    private let repository: HomeRepositoryInterface
    
    required init(repository: HomeRepositoryInterface = HomeRepository()) {
        self.repository = repository
        self.episodes = [Episode]()
        self.cachedHomePhotos = [String: Data?]()
        self.showLoading = true
    }
    
    func fetchHomeData() {
        showLoading = true
        repository
            .fetchHomeData()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                switch value {
                case .failure:
                    self?.episodes = []
                    self?.playlist = nil
                case .finished:
                    break
                }
            } receiveValue: { [weak self] result in
                self?.showLoading = false
                self?.playlist = result.data?.playlist
                self?.episodes = result.data?.episodes ?? []
                guard let image = result.data?.playlist?.image else { return }
                self?.downloadImage(image)
            }
            .store(in: &disposables)
    }
    
    func downloadImage(_ url: String) {
        repository
            .fetchImageData(with: url)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                switch value {
                case .failure:
                    self?.cachedHomePhotos[url] = nil
                case .finished:
                    break
                }
            } receiveValue: { [weak self] imageData in
                self?.cachedHomePhotos[url] = imageData
            }
            .store(in: &disposables)
    }
    
}
