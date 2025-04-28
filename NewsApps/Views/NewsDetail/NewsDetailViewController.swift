//
//  NewsDetailViewController.swift
//  NewsApps
//
//  Created by Faza Azizi on 28/04/25.
//

import UIKit
import Combine

class NewsDetailViewController: UIViewController {

    private let viewModel: NewsDetailViewModel
    private var cancellables = Set<AnyCancellable>()

    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var pageLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    init(viewModel: NewsDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        pageLabel.text = viewModel.sectionType.detailTitle
        activityIndicator.startAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func setupUI(){
        backImageView.isUserInteractionEnabled = true
        let backTap = UITapGestureRecognizer(target: self, action: #selector(backTapped))
        backImageView.addGestureRecognizer(backTap)
    }

    private func bindViewModel() {
        viewModel.$newsItem
            .receive(on: DispatchQueue.main)
            .sink { [weak self] item in
                guard let self = self, let item = item else { return }
                self.titleLabel.text = item.title
                self.dateLabel.text = self.viewModel.formattedDate()
                self.summaryLabel.text = self.viewModel.summaryFirstSentence()
                if let urlStr = item.imageUrl {
                    self.imageView.setImage(with: urlStr)
                }
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
            }
            .store(in: &cancellables)

        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] loading in
                loading ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
            }
            .store(in: &cancellables)

        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                if let error = error {
                    self?.showError(error)
                }
            }
            .store(in: &cancellables)
    }

    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
}
