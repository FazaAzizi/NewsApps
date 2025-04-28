//
//  HomeViewController.swift
//  NewsApps
//
//  Created by Faza Azizi on 28/04/25.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    private let viewModel: HomeViewModel
    private var cancellables = Set<AnyCancellable>()
    
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    enum Section: Int, CaseIterable {
        case articles, blogs, reports
        
        var title: String {
            switch self {
            case .articles: return "Articles"
            case .blogs: return "Blogs"
            case .reports: return "Reports"
            }
        }
    }
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindViewModel()
        viewModel.fetchAll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "SectionItemTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "SectionItemTableViewCell")
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
    }
    
    private func bindViewModel() {
        viewModel.$userName
            .sink { [weak self] userName in
                let greeting = self?.viewModel.greeting() ?? "Hello"
                self?.greetingLabel.text = "\(greeting)\n\(userName.isEmpty ? "User" : userName)"
            }
            .store(in: &cancellables)
        
        Publishers.CombineLatest3(viewModel.$articles, viewModel.$blogs, viewModel.$reports)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate, SectionHeaderDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SectionItemTableViewCell", for: indexPath) as? SectionItemTableViewCell,
              let sectionType = Section(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        
        let items: [NewsItem]
        switch sectionType {
        case .articles: items = viewModel.articles
        case .blogs: items = viewModel.blogs
        case .reports: items = viewModel.reports
        }
        
        cell.delegate = self
        cell.configure(with: items, sectionType: sectionType)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let nib = UINib(nibName: "SectionHeaderView", bundle: nil)
        guard let header = nib.instantiate(withOwner: nil, options: nil).first as? SectionHeaderView else {
            return nil
        }
        header.configure(title: Section(rawValue: section)?.title ?? "", section: section, delegate: self)
        return header
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
    
    func didTapShowMore(in section: Int) {
        print("Tap = \(section)")
    }
}

extension HomeViewController: SectionItemTableViewCellDelegate {
    func sectionItemCell(_ cell: SectionItemTableViewCell, didSelectItem item: NewsItem, in section: HomeViewController.Section) {
        guard let id = item.id else { return }
        let sectionType: NewsSectionType
        switch section {
        case .articles: sectionType = .article
        case .blogs: sectionType = .blog
        case .reports: sectionType = .report
        }
        let detailVM = NewsDetailViewModel(sectionType: sectionType)
        detailVM.fetchDetail(id: id, section: sectionType)
        let detailVC = NewsDetailViewController(viewModel: detailVM)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func sectionItemCellDidTapLoad(_ cell: SectionItemTableViewCell, in section: HomeViewController.Section) {
        print("Section: \(section.title)")
    }
}


