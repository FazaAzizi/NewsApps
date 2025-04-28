//
//  UIImageView+Ext.swift
//  NewsApps
//
//  Created by Faza Azizi on 28/04/25.
//

import Foundation
import Kingfisher

extension UIImageView {

    func setImage(with urlString: String?) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            self.image = UIImage(named: "placeholder")
            return
        }
        
        let placeholderImage = UIImage(named: "placeholder")
        
        self.kf.setImage(with: url, placeholder: placeholderImage)
    }
}
