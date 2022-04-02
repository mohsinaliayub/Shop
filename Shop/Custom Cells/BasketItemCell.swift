//
//  BasketItemCell.swift
//  Shop
//
//  Created by Mohsin Ali Ayub on 02.04.22.
//

import UIKit

protocol BasketItemCellDelegate: AnyObject {
    
    func updateTotalItemPrice(_ cell: BasketItemCell, for item: Item, itemCount: Int)
    func removeItemFromBasket(_ cell: BasketItemCell, item: Item)
    
}

class BasketItemCell: UITableViewCell {
    
    @IBOutlet weak var itemPrimaryImage: UIImageView!
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var itemDescriptionLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var itemOrderCountLabel: UILabel!
    @IBOutlet weak var descreaseButton: UIButton!
    @IBOutlet weak var increaseButton: UIButton!
    
    private let maxItemOrderCount = 10
    private let minItemOrderCount = 1
    
    weak var delegate: BasketItemCellDelegate?
    var itemCount = 1 {
        didSet {
            itemOrderCountLabel.text = "\(itemCount)"
            itemPriceLabel.text = (item.price * Double(itemCount)).currencyValue
            updateButtonsDisableStatus()
            item.itemOrderCount = itemCount
            delegate?.updateTotalItemPrice(self, for: item, itemCount: itemCount)
        }
    }
    private var item: Item!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // MARK: - Actions
    
    @IBAction func decreaseItemOrder(_ sender: UIButton) {
        if itemCount > minItemOrderCount {
            itemCount -= 1
        }
    }
    
    @IBAction func increaseItemOrderCount(_ sender: UIButton) {
        if itemCount < maxItemOrderCount {
            itemCount += 1
        }
    }
    
    @IBAction func removeItemFromBasket(_ sender: UIButton) {
        delegate?.removeItemFromBasket(self, item: item)
    }
    
    // MARK: - Helper methods
    
    func generateCell(withItem item: Item) {
        self.item = item
        
        itemTitleLabel.text = item.name
        itemDescriptionLabel.text = item.description
        itemCount = item.itemCountInBasket
        
        // if there's an item image, download and display it
        if !item.imageLinks.isEmpty {
            StorageService.shared.downloadImages(fromUrls: [item.imageLinks[0]]) { images in
                if images.isEmpty {
                    print("we didn't receive any image")
                    return
                }
                
                DispatchQueue.main.async {
                    self.itemPrimaryImage.image = images[0]
                }
            }
        }
    }
    
    private func updateButtonsDisableStatus() {
        increaseButton.isEnabled = !(itemCount == maxItemOrderCount)
        descreaseButton.isEnabled = !(itemCount == minItemOrderCount)
    }
    
}
