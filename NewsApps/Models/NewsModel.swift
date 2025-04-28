//
//  NewsModel.swift
//  NewsApps
//
//  Created by Faza Azizi on 28/04/25.
//

import Foundation

struct NewsPagedResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [NewsItem]
}

struct NewsItem: Codable {
    let id: Int?
    let title: String?
    let authors: [Author]?
    let url: String?
    let imageUrl: String?
    let newsSite: String?
    let summary: String?
    let publishedAt: String?
    let updatedAt: String?
    let featured: Bool?
    let launches: [Launch]?
    let events: [Event]?

    enum CodingKeys: String, CodingKey {
        case id, title, authors, url
        case imageUrl = "image_url"
        case newsSite = "news_site"
        case summary
        case featured
        case publishedAt = "published_at"
        case updatedAt = "updated_at"
        case launches, events
    }
}

struct Author: Codable {
    let name: String
    let socials: Socials?
}

struct Socials: Codable {
    let youtube: String?
    let linkedin: String?
    let mastodon: String?
    let bluesky: String?
    let x: String?
    let instagram: String?
}

struct Launch: Codable {
    let launchId: String?
    let provider: String?

    enum CodingKeys: String, CodingKey {
        case launchId = "launch_id"
        case provider
    }
}

struct Event: Codable {
    let eventId: Int?
    let provider: String?

    enum CodingKeys: String, CodingKey {
        case eventId = "event_id"
        case provider
    }
}
