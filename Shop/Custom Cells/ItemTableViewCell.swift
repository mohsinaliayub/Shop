//
//  ItemTableViewCell.swift
//  Shop
//
//  Created by Mohsin Ali Ayub on 28.03.22.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    
    // outlets
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func generateCell(with item: Item) {
        nameLabel.text = item.name
        descriptionLabel.text = item.description
        priceLabel.text = String(item.price)
        
        if !item.imageLinks.isEmpty {
            StorageService.shared.downloadImages(fromUrls: [item.imageLinks.first!]) { images in
                if images.isEmpty {
                    print("We didn't receive any image")
                    return
                }
                
                DispatchQueue.main.async {
                    self.itemImageView.image = images[0]
                }
            }
        }
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
