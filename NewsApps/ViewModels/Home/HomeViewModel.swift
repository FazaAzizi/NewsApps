//
//  HomeViewModel.swift
//  NewsApps
//
//  Created by Faza Azizi on 28/04/25.
//

import Foundation
import Combine

class HomeViewModel {
    @Published var articles: [NewsItem] = []
    @Published var blogs: [NewsItem] = []
    @Published var reports: [NewsItem] = []
    @Published var userName: String = ""
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()

    private let homeService: HomeServiceProtocol
    
    init(homeService: HomeServiceProtocol = HomeService()) {
        self.homeService = homeService
    }
    
    func fetchAll() {
        getUser()
        fetchArticles()
        fetchBlogs()
        fetchReports()
    }
    
    private func getUser() {
        if let savedUserData = UserDefaults.standard.data(forKey: "savedUser") {
            let decoder = JSONDecoder()
            let user = try? decoder.decode(User.self, from: savedUserData)
            userName = user?.name ?? ""
        }
    }
    
    func fetchArticles() {
        homeService.getArticles()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] articles in
                self?.articles = articles
            }
            .store(in: &cancellables)
    }
    
    func fetchBlogs() {
        homeService.getBlogs()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] blogs in
                self?.blogs = blogs
            }
            .store(in: &cancellables)
    }
    
    func fetchReports() {
        homeService.getReports()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] reports in
                self?.reports = reports
            }
            .store(in: &cancellables)
    }

    func greeting(for date: Date = Date()) -> String {
        let hour = Calendar.current.component(.hour, from: date)
        switch hour {
        case 5..<12: return "Good Morning"
        case 12..<17: return "Good Afternoon"
        case 17..<22: return "Good Evening"
        default: return "Good Night"
        }
    }
}
