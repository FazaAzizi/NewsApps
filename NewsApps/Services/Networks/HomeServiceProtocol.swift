//
//  HomeServiceProtocol.swift
//  NewsApps
//
//  Created by Faza Azizi on 28/04/25.
//

import Foundation
import Combine

protocol HomeServiceProtocol {
    func getArticles() -> AnyPublisher<[NewsItem], Error>
    func getBlogs() -> AnyPublisher<[NewsItem], Error>
    func getReports() -> AnyPublisher<[NewsItem], Error>
}

class HomeService: HomeServiceProtocol {
    private let networkManager = NetworkManager.shared
    
    func getArticles() -> AnyPublisher<[NewsItem], Error> {
        let url = "\(Constants.baseURL)articles/"
        return networkManager.request(url)
            .map { (response: NewsPagedResponse) in response.results }
            .eraseToAnyPublisher()
    }
    
    func getBlogs() -> AnyPublisher<[NewsItem], Error> {
        let url = "\(Constants.baseURL)blogs/"
        return networkManager.request(url)
            .map { (response: NewsPagedResponse) in response.results }
            .eraseToAnyPublisher()
    }
    
    func getReports() -> AnyPublisher<[NewsItem], Error> {
        let url = "\(Constants.baseURL)reports/"
        return networkManager.request(url)
            .map { (response: NewsPagedResponse) in response.results }
            .eraseToAnyPublisher()
    }
}

