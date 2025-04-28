//
//  ItemCollectionViewCell.swift
//  NewsApps
//
//  Created by Faza Azizi on 28/04/25.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        newsImageView.contentMode = .scaleAspectFill
        titleLabel.numberOfLines = 2
        
        containerView.layer.cornerRadius = 10
        containerView.layer.masksToBounds = false
        
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowOffset = CGSize(width: 0, height: 5)
        containerView.layer.shadowRadius = 4
        containerView.layer.masksToBounds = false
        
        newsImageView.layer.cornerRadius = 10
        newsImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    func configure(with item: NewsItem) {
        newsImageView.setImage(with: item.imageUrl)
        titleLabel.text = item.title
    }
}
