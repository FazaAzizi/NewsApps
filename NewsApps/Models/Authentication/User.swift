//
//  UserModel.swift
//  NewsApps
//
//  Created by Faza Azizi on 28/04/25.
//

import Foundation

struct User: Codable {
    let id: String
    let name: String
    let email: String
    let picture: URL?
    
    static var empty: User {
        return User(id: "", name: "", email: "", picture: nil)
    }
}
