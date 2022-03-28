//
//  BasketViewController.swift
//  Shop
//
//  Created by Mohsin Ali Ayub on 28.03.22.
//

import UIKit
import JGProgressHUD

class BasketViewController: UIViewController {
    
    // outlets
    @IBOutlet weak var totalItemsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var checkoutButton: UIButton!
    
    // properties
    private let hud = JGProgressHUD(style: .dark)
    private let itemCellReuseIdentifier = "itemCell"
    
    var basket: Basket?
    var itemsInBasket = [Item]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var purchasedItemIds = [String]()
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = footerView
        loadBasketFromFirestore()
    }
    
    // MARK: Actions
    
    @IBAction func checkoutItems(_ sender: UIButton) {
        
    }
    
    // MARK: Download Basket
    private func loadBasketFromFirestore() {
        downloadBasketFromFirestore(for: "1234") { basket, error in
            guard let basket = basket else {
                return
            }

            self.basket = basket
            self.getItemsFromBasket(withIds: basket.itemIds)
        }
    }
    
    private func getItemsFromBasket(withIds ids: [String]) {
        downloadItems(withIds: ids) { items in
            self.itemsInBasket = items
        }
    }
    
}


extension BasketViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemsInBasket.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: itemCellReuseIdentifier, for: indexPath) as! ItemTableViewCell
        
        cell.generateCell(with: itemsInBasket[indexPath.row])
        
        return cell
    }
    
}
