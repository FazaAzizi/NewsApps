//
//  SectionItemTableViewCell.swift
//  NewsApps
//
//  Created by Faza Azizi on 28/04/25.
//

import UIKit

protocol SectionItemTableViewCellDelegate: AnyObject {
    func sectionItemCell(_ cell: SectionItemTableViewCell, didSelectItem item: NewsItem, in section: HomeViewController.Section)
    func sectionItemCellDidTapLoad(_ cell: SectionItemTableViewCell, in section: HomeViewController.Section)
}


class SectionItemTableViewCell: UITableViewCell {

    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var loadButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var data: [NewsItem] = []

    private var currentSection: HomeViewController.Section?
    weak var delegate: SectionItemTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 220, height: 200)
        layout.minimumLineSpacing = 10
        
        collectionView.collectionViewLayout = layout
        collectionView.register(UINib(nibName: "ItemCollectionViewCell", bundle: nil),
                              forCellWithReuseIdentifier: "ItemCollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
    }

    func configure(with items: [NewsItem], sectionType: HomeViewController.Section) {
        loadButton.addTarget(self, action: #selector(loadButtonTapped), for: .touchUpInside)
        currentSection = sectionType
        data = items
        collectionView.isHidden = items.isEmpty
        collectionView.reloadData()
    }
    
    @objc private func loadButtonTapped() {
        guard let section = currentSection else { return }
        delegate?.sectionItemCellDidTapLoad(self, in: section)
    }
}

extension SectionItemTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCollectionViewCell", for: indexPath) as! ItemCollectionViewCell
        guard let sectionType = currentSection else { return cell }
        
        let item: NewsItem = data[indexPath.item]
        
        cell.configure(with: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = currentSection else { return }
        let item = data[indexPath.item]
        delegate?.sectionItemCell(self, didSelectItem: item, in: section)
    }
}

