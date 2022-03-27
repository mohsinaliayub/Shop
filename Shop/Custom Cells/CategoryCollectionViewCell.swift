//
//  CategoryCollectionViewCell.swift
//  Shop
//
//  Created by Mohsin Ali Ayub on 27.03.22.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func loadCell(with category: Category) {
        categoryImage.image = category.image
        nameLabel.text = category.name
    }
}
