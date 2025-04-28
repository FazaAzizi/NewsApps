//
//  SectionHeaderView.swift
//  NewsApps
//
//  Created by Faza Azizi on 28/04/25.
//

import UIKit

protocol SectionHeaderDelegate: AnyObject {
    func didTapShowMore(in section: Int)
}

class SectionHeaderView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var showMoreButton: UIButton!
    
    private var section: Int = 0
    weak var delegate: SectionHeaderDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(title: String, section: Int, delegate: SectionHeaderDelegate?) {
        self.titleLabel.text = title
        self.section = section
        self.delegate = delegate
        showMoreButton.addTarget(self, action: #selector(showMoreTapped), for: .touchUpInside)
    }

    @objc private func showMoreTapped() {
        delegate?.didTapShowMore(in: section)
    }
}

