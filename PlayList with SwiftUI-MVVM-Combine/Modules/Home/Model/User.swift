//
//  User.swift
//  SwiftUI-MVVM-Combine
//
//  Created by Mahmoud Ismail on 22/11/2023.
//

import Foundation

// MARK: - User
struct User: Codable {
    let accessToken, refreshToken: String
    let expiresIn: Int
    let user: UserClass
}

// MARK: - UserClass
struct UserClass: Codable {
    let email, userID: String
    let verified: Bool

    enum CodingKeys: String, CodingKey {
        case email
        case userID = "userId"
        case verified
    }
}
