//
//  APIService.swift
//  SwiftUI-MVVM-Combine
//
//  Created by Mahmoud Ismail on 14/01/2023.
//

import Foundation
import Combine

protocol APIServiceType {
    func response<T>(with parameters: [String: Any], endPoint: String, httpMethod: String) -> AnyPublisher<T, APIServiceError> where T: Decodable
    func downloadData(from urlPath: String) -> AnyPublisher<Data, APIServiceError>
}

final class APIService: APIServiceType {
    
    static let shared: APIServiceType = APIService()
    
    private let baseURL: URL?
    private let session: URLSession
    
    init(session: URLSession = .shared, urlPath: String = "https://staging.podcast.kaitdev.com/client/api/") {
        self.baseURL = URL(string: urlPath)
        self.session = session
    }
    
    func response<T>(with parameters: [String: Any], endPoint: String, httpMethod: String) -> AnyPublisher<T, APIServiceError> where T: Decodable {
        
        guard let urlRequest = getURLRequest(with: parameters, endPoint: endPoint, httpMethod: httpMethod) else {
            let error = APIServiceError.invalidURL(description: "Can't create URL")
            return Fail(error: error).eraseToAnyPublisher()
        }
        return session.dataTaskPublisher(for: urlRequest)
            .mapError { error in
            .network(description: error.localizedDescription)
            }
            .flatMap(maxPublishers: .max(1)) { pair in
                decode(pair.data)
            }
            .eraseToAnyPublisher()
    }
    
    func downloadData(from urlPath: String) -> AnyPublisher<Data, APIServiceError> {
        guard let pathURL: URL = URL(string:urlPath),
              let urlComponents: URLComponents = URLComponents(url: pathURL, resolvingAgainstBaseURL: true),
              let url: URL = urlComponents.url else {
                  let error = APIServiceError.invalidURL(description: "Can't create URL")
                  return Fail(error: error).eraseToAnyPublisher()
              }
        return session.dataTaskPublisher(for: URLRequest(url: url))
            .tryMap { response -> Data in
                guard
                    let httpURLResponse = response.response as? HTTPURLResponse,
                    httpURLResponse.statusCode == 200
                else {
                    throw  APIServiceError.network(description: "Invalid Status Code")
                }
                
                return response.data
            }
            .mapError { error in
            .network(description: error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
    
    private func getURLRequest(with parameters: [String: Any], endPoint: String, httpMethod: String) -> URLRequest? {
        guard let pathURL: URL = URL(string: endPoint, relativeTo: baseURL) else {
            return nil
        }
        let urlComponents: URLComponents? = URLComponents(url: pathURL, resolvingAgainstBaseURL: true)
        guard let url: URL = urlComponents?.url else {
            return nil
        }
        var urlRequest = URLRequest(url: url)
        if let token = UserDefaults.standard.string(forKey: Constants.authorizationKey) {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: Constants.authorizationKey)
        }
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

        urlRequest.httpMethod = httpMethod
        if !parameters.isEmpty {
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        }
        return urlRequest
    }
    
}
