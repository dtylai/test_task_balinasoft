//
//  PhotoTypeCell.swift
//  BalinaSoftTestTask
//
//  Created by Dmitry Tulay on 11/8/22.
//

import UIKit
import Kingfisher

class PhotoTypeCell: UITableViewCell {
    
    @IBOutlet private var photo: UIImageView!
    @IBOutlet private var typeLable: UILabel!
    
    func configureLable(with content: Content) {
        photo.contentMode = .scaleAspectFill
        typeLable.text = content.name
        
        guard let urlString = content.image else {
            let image = UIImage(named: "standartImage")
            photo.image = image
            return
        }
        
        let url = URL(string: urlString)
        
        photo.kf.indicatorType = .activity
        photo.kf.setImage(with: url)
    }
}

