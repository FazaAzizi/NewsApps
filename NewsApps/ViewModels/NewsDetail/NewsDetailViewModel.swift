//
//  NewsDetailViewModel.swift
//  NewsApps
//
//  Created by Faza Azizi on 28/04/25.
//

import Foundation
import Combine

enum NewsSectionType {
    case article, blog, report
    
    var detailTitle: String {
        switch self {
        case .article: return "Article Detail"
        case .blog: return "Blog Detail"
        case .report: return "Report Detail"
        }
    }
}

class NewsDetailViewModel {
    @Published var newsItem: NewsItem?
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false

    private let service: HomeServiceProtocol
    let sectionType: NewsSectionType
    private var cancellables = Set<AnyCancellable>()

    init(sectionType: NewsSectionType, service: HomeServiceProtocol = HomeService()) {
        self.sectionType = sectionType
        self.service = service
    }

    func fetchDetail(id: Int, section: NewsSectionType) {
        isLoading = true
        let publisher: AnyPublisher<NewsItem, Error>
        switch section {
        case .article:
            publisher = service.getArticleDetail(id: id)
        case .blog:
            publisher = service.getBlogDetail(id: id)
        case .report:
            publisher = service.getReportDetail(id: id)
        }
        publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] item in
                self?.newsItem = item
            }
            .store(in: &cancellables)
    }

    func formattedDate() -> String {
        guard let publishedAt = newsItem?.publishedAt else { return "" }
        let isoFormatter = ISO8601DateFormatter()
        guard let date = isoFormatter.date(from: publishedAt) else { return publishedAt }
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = "d MMMM yyyy, HH:mm"
        return formatter.string(from: date)
    }

    func summaryFirstSentence() -> String {
        guard let summary = newsItem?.summary else { return "" }
        if let endIndex = summary.firstIndex(of: ".") {
            return String(summary[..<endIndex]) + "."
        }
        return summary
    }
}
