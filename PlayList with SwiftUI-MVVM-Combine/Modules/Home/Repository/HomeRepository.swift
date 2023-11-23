//
//  HomeRepository.swift
//  SwiftUI-MVVM-Combine
//
//  Created by Mahmoud Ismail on 22/11/2023.
//

import Foundation
import Combine

protocol HomeRepositoryInterface {
    func fetchHomeData() -> AnyPublisher<HomeResponse, APIServiceError>
    func fetchImageData(with urlPath: String) -> AnyPublisher<Data, APIServiceError>
}

class HomeRepository: HomeRepositoryInterface {
    
    private let apiService: APIServiceType
    private var disposables = Set<AnyCancellable>()
    
    init(apiService: APIServiceType = APIService.shared) {
        self.apiService = apiService
    }
    
    func fetchHomeData() -> AnyPublisher<HomeResponse, APIServiceError> {
        let endPoint: String = "playlist/01GVD0TTY5RRMHH6YMCW7N1H70"
        
        let combinedPublisher: AnyPublisher<HomeResponse, APIServiceError> = getAccessToken()
            .flatMap { user in
                UserDefaults.standard.set(user.accessToken, forKey: Constants.authorizationKey)
                return self.apiService.response(with: [:], endPoint: endPoint, httpMethod: HTTPMethod.get) as AnyPublisher<HomeResponse, APIServiceError>
            }
            .eraseToAnyPublisher()
        return combinedPublisher
    }
    
    func fetchImageData(with urlPath: String) -> AnyPublisher<Data, APIServiceError> {
        return apiService.downloadData(from: urlPath)
    }
    
    private func getAccessToken() -> AnyPublisher<User, APIServiceError> {
        let parameters: [String: Any] = [
            "email": "ajbusaleh@gmail.com",
            "password": "123123aJ*"
        ]
        let endPoint: String = "auth/login"
        let anyPublisher: AnyPublisher<User, APIServiceError> = apiService.response(with: parameters, endPoint: endPoint, httpMethod: HTTPMethod.post)
        return anyPublisher
    }
    
}
