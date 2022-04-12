//
//  ItemInfoCell.swift
//  Shop
//
//  Created by Mohsin Ali Ayub on 02.04.22.
//

import UIKit

class ItemInfoCell: UITableViewCell {
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemDescriptionLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var numberOfItemsLabel: UILabel! // this label will only be used for user's purchased history
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func showCell(withItem item: Item, itemCount: Int? = nil) {
        itemNameLabel.text = item.name
        itemDescriptionLabel.text = item.description
        let numberOfItems = itemCount ?? 1
        itemPriceLabel.text = (Double(numberOfItems) * item.price).currencyValue
        if let itemCount = itemCount, itemCount > 2 {
            numberOfItemsLabel.text = "\(itemCount) items"
            numberOfItemsLabel.isHidden = false
        } else {
            numberOfItemsLabel.isHidden = true
        }
        
        if !item.imageLinks.isEmpty {
            StorageService.shared.downloadImages(fromUrls: [item.imageLinks[0]]) { images in
                if images.isEmpty {
                    print("we didn't receive any image")
                    return
                }
                
                DispatchQueue.main.async {
                    self.itemImageView.image = images[0]
                }
            }
        }
        
    }

}
