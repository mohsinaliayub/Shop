//
//  BasketItemCell.swift
//  Shop
//
//  Created by Mohsin Ali Ayub on 02.04.22.
//

import UIKit


class BasketItemCell: UITableViewCell {
    
    @IBOutlet weak var itemPrimaryImage: UIImageView!
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var itemDescriptionLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var itemOrderCountLabel: UILabel!
    @IBOutlet weak var descreaseButton: UIButton!
    @IBOutlet weak var increaseButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @IBAction func decreaseItemOrder(_ sender: UIButton) {
    }
    
    @IBAction func increaseItemOrderCount(_ sender: UIButton) {
        
    }
    
    @IBAction func removeItemFromBasket(_ sender: UIButton) {
    }
    
    
}
