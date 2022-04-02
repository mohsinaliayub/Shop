//
//  BasketItemCell.swift
//  Shop
//
//  Created by Mohsin Ali Ayub on 02.04.22.
//

import UIKit

typealias ItemOrder = Basket.ItemOrder

protocol BasketItemCellDelegate: AnyObject {
    
    func updateTotalItemPrice(_ cell: BasketItemCell, for item: ItemOrder, itemCount: Int)
    func removeItemOrderFromBasket(_ cell: BasketItemCell, itemOrder: ItemOrder)
    
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
            itemPriceLabel.text = (order.item.price * Double(itemCount)).currencyValue
            updateButtonsDisableStatus()
            order.itemCount = itemCount
        }
    }
    private var order: ItemOrder!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // MARK: - Actions
    
    @IBAction func decreaseItemOrder(_ sender: UIButton) {
        if itemCount > minItemOrderCount {
            itemCount -= 1
            delegate?.updateTotalItemPrice(self, for: order, itemCount: itemCount)
        }
    }
    
    @IBAction func increaseItemOrderCount(_ sender: UIButton) {
        if itemCount < maxItemOrderCount {
            itemCount += 1
            delegate?.updateTotalItemPrice(self, for: order, itemCount: itemCount)
        }
    }
    
    @IBAction func removeItemFromBasket(_ sender: UIButton) {
        delegate?.removeItemOrderFromBasket(self, itemOrder: order)
    }
    
    // MARK: - Helper methods
    
    func generateCell(withItemOrder order: Basket.ItemOrder) {
        self.order = order
        
        itemTitleLabel.text = order.item.name
        itemDescriptionLabel.text = order.item.description
        itemCount = order.itemCount
        
        // if there's an item image, download and display it
        if !order.item.imageLinks.isEmpty {
            StorageService.shared.downloadImages(fromUrls: [order.item.imageLinks[0]]) { images in
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
