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
    func getArticleDetail(id: Int) -> AnyPublisher<NewsItem, Error>
    func getBlogDetail(id: Int) -> AnyPublisher<NewsItem, Error>
    func getReportDetail(id: Int) -> AnyPublisher<NewsItem, Error>}

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
    
    func getArticleDetail(id: Int) -> AnyPublisher<NewsItem, Error> {
        let url = "\(Constants.baseURL)articles/\(id)/"
        return networkManager.request(url)
            .eraseToAnyPublisher()
    }
    
    func getBlogDetail(id: Int) -> AnyPublisher<NewsItem, Error> {
        let url = "\(Constants.baseURL)blogs/\(id)/"
        return networkManager.request(url)
            .eraseToAnyPublisher()
    }
    
    func getReportDetail(id: Int) -> AnyPublisher<NewsItem, Error> {
        let url = "\(Constants.baseURL)reports/\(id)/"
        return networkManager.request(url)
            .eraseToAnyPublisher()
    }
}

