//
//  Credentials.swift
//  NewsApps
//
//  Created by Faza Azizi on 28/04/25.
//

import Foundation

struct Credentials: Codable {
    let accessToken: String
    let idToken: String
    let refreshToken: String?
    let expiresIn: TimeInterval
    let scope: String?
    let tokenType: String?
}
