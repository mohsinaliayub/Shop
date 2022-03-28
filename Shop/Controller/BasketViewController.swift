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
    private let itemDetailVCStoryboardId = "itemDetailViewController"
    
    var basket: Basket?
    var itemsInBasket = [Item]() {
        didSet {
            DispatchQueue.main.async {
                self.refreshUI()
            }
        }
    }
    var totalBasketPrice: String {
        let totalPrice = itemsInBasket.reduce(0.0) { $0 + $1.price }
        return "Total price: " + convertToCurrency(totalPrice)
    }
    var purchasedItemIds = [String]()
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = footerView
        updateTotalLabels(itemsInBasket.isEmpty)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
            self.updateTotalLabels(items.isEmpty)
        }
    }
    
    // TODO: Provide a fix in the UI: If there are multiple items in the basket with same id, they should be displayed in a single cell with a number of items button next to them.
    private func removeItemFromBasket(at index: Int) {
        guard let basket = basket else {
            return
        }

        basket.itemIds.remove(at: index)
        updateBasketInFirestore(basket, withValues: [Constants.itemIds : basket.itemIds]) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: Helper methods
    private func updateTotalLabels(_ isEmpty: Bool) {
        totalItemsLabel.text = isEmpty ? "0" : "\(itemsInBasket.count)"
        totalPriceLabel.text = totalBasketPrice
        
        updateCheckoutButtonStatus()
    }
    
    private func updateCheckoutButtonStatus() {
        checkoutButton.isEnabled = !itemsInBasket.isEmpty
        
        checkoutButton.backgroundColor = checkoutButton.isEnabled ? .opaqueSeparator : .gray
    }
    
    private func refreshUI() {
        tableView.reloadData()
        updateTotalLabels(itemsInBasket.isEmpty)
    }
    
    // MARK: Navigation
    
    private func showItemViewController(with item: Item) {
        let itemDetailVC = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: itemDetailVCStoryboardId) as! ItemDetailViewController
        
        itemDetailVC.item = item
        self.navigationController?.pushViewController(itemDetailVC, animated: true)
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            _ = itemsInBasket[indexPath.row] // Need a fix
            itemsInBasket.remove(at: indexPath.row)
            refreshUI()
            
            // remove item from our basket
            removeItemFromBasket(at: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        showItemViewController(with: itemsInBasket[indexPath.row])
    }
    
}
