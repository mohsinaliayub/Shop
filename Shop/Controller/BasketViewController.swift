//
//  BasketViewController.swift
//  Shop
//
//  Created by Mohsin Ali Ayub on 28.03.22.
//

import UIKit
import JGProgressHUD
import Stripe
import SwiftUI

class BasketViewController: UIViewController {
    
    // outlets
    @IBOutlet weak var totalItemsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var checkoutButton: UIButton!
    @IBOutlet weak var subtotalPriceLabel: UILabel!
    @IBOutlet weak var shippingPriceLabel: UILabel!
    
    // properties
    private let hud = JGProgressHUD(style: .dark)
    private let itemCellReuseIdentifier = "itemCell"
    private let basketItemCell = "basketItemCell"
    private let itemDetailVCStoryboardId = "itemDetailViewController"
    
    var basket: Basket?
    var itemOrdersInBasket = [Basket.ItemOrder]() {
        didSet {
            DispatchQueue.main.async {
                self.refreshUI()
            }
        }
    }
    var purchasedOrders = [Basket.ItemOrder]()
    
    var shippingPrice: Double { itemOrdersInBasket.isEmpty ? 0 : 4.99 }
    var totalBasketPrice: Double { subtotalBasketPrice + shippingPrice }
    var subtotalBasketPrice: Double {
        let subtotal = itemOrdersInBasket.reduce(0.0) { $0 + $1.item.price * Double($1.itemCount) }
        return subtotal
    }
    
    var totalPrice = 0
    var purchasedItemIds = [String]()
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let basketItemCell = UINib(nibName: "BasketItemCell", bundle: nil)
        tableView.register(basketItemCell, forCellReuseIdentifier: self.basketItemCell)
        
        tableView.tableFooterView = UIView()
        updateTotalLabels(itemOrdersInBasket.isEmpty)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if User.currentUser() != nil {
            loadBasketFromFirestore()
        } else {
            updateTotalLabels(true)
        }
    }
    
    // MARK: Actions
    
    @IBAction func promoCodeValueChanged(_ sender: UITextField) {
        
    }
    
    @IBAction func applyVoucherButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func checkoutItems(_ sender: UIButton) {
        // if user has verified their email address and provided their name & address information
        // let them checkout the basket - otherwise show an error stating they need to onboard
        guard let currentUser = User.currentUser(), currentUser.onBoard else {
            hud.showHUD(withText: "Please complete your profile", indicatorType: .failure, showIn: view)
            return
        }
        
        // provide user with payment options
        showPaymentOptions()
    }
    
    // MARK: Download Basket
    private func loadBasketFromFirestore() {
        guard let currentUserId = User.currentUserId() else { return }
        
        downloadBasketFromFirestore(for: currentUserId) { basket, error in
            guard let basket = basket else {
                return
            }

            self.basket = basket
            self.getItemOrdersFromBasket(basket.itemOrders)
        }
    }
    
    private func getItemOrdersFromBasket(_ orders: [Basket.ItemOrder]) {
        downloadItemsForBasketOrders(orders) { itemOrders in
            self.itemOrdersInBasket = itemOrders
        }
    }
    
    // remove item from basket, update itemsInBasket array and update the labels
    private func removeItemFromBasket(_ itemOrder: Basket.ItemOrder) {
        guard let basket = basket else {
            return
        }
        
        guard let index = itemOrdersInBasket.firstIndex(where: { $0.itemId == itemOrder.itemId }) else { return }
        itemOrdersInBasket.remove(at: index)
        refreshUI()
        
        updateBasket(basket)
    }
    
    private func updateBasket(_ basket: Basket) {
        basket.itemOrders = itemOrdersInBasket
        updateBasketInFirestore(basket) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Payment
    
    private func showPaymentOptions() {
        let alertController = UIAlertController(title: "Payment Options", message: "Choose preferred payment option", preferredStyle: .actionSheet)
        
        let cardAction = UIAlertAction(title: "Pay with Card", style: .default) { action in
            // show card number view
            let cardInfoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "cardInfoViewController") as! CardInfoViewController
            cardInfoVC.delegate = self
            
            self.present(cardInfoVC, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(cardAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    private func finishPayment(token: STPToken) {
        totalPrice = 0
        
        for order in itemOrdersInBasket {
            purchasedOrders.append(order)
//            purchasedItemIds.append(item.id)
            totalPrice += Int(floor(order.item.price))
        }
        
        // prepare total price for Stripe
        totalPrice *= 100
        
        StripeClient.shared.createAndConfirmPayment(token: token, amount: totalPrice) { error in
            
            if let error = error {
                self.hud.showHUD(withText: error.localizedDescription, indicatorType: .failure, showIn: self.view)
            } else {
                self.emptyBasket()
                self.addItemsToPurchaseHistory(withIds: self.purchasedItemIds)
                self.hud.showHUD(withText: "Payment Successful", indicatorType: .success, showIn: self.view)
            }
            
        }
    }
    
    // MARK: Helper methods
    private func updateTotalLabels(_ isEmpty: Bool) {
        footerView.isHidden = itemOrdersInBasket.isEmpty
        
        totalItemsLabel.text = isEmpty ? "" : "(\(itemOrdersInBasket.count) \(itemOrdersInBasket.count == 1 ? "item" : "items")"
        subtotalPriceLabel.text = subtotalBasketPrice.currencyValue
        shippingPriceLabel.text = shippingPrice.currencyValue
        totalPriceLabel.text = totalBasketPrice.currencyValue
        
        updateCheckoutButtonStatus()
    }
    
    private func updateCheckoutButtonStatus() {
        checkoutButton.isEnabled = !itemOrdersInBasket.isEmpty
    }
    
    private func refreshUI() {
        tableView.reloadData()
        updateTotalLabels(itemOrdersInBasket.isEmpty)
    }
    
    private func emptyBasket() {
        purchasedItemIds.removeAll()
        itemOrdersInBasket.removeAll()
        refreshUI()
        
        guard let basket = basket else {
            return
        }

        updateBasket(basket)
    }
    
    private func addItemsToPurchaseHistory(withIds itemIds: [String]) {
        guard let currentUser = User.currentUser() else { return }
        
        currentUser.purchasedItemIds += purchasedItemIds
        
        updateCurrentUserInFirestore(withValues: [Constants.purchasedItemIds: currentUser.purchasedItemIds]) { error in
            if let error = error {
                print("Error updating purchased items: \(error.localizedDescription)")
                self.hud.showHUD(withText: "Error updating purchased items", indicatorType: .failure,
                                 showIn: self.view)
            }
        }
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
        itemOrdersInBasket.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: basketItemCell, for: indexPath) as! BasketItemCell
        
        cell.generateCell(withItemOrder: itemOrdersInBasket[indexPath.row])
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let item = itemOrdersInBasket[indexPath.row]
            
            // remove item from our basket
            removeItemFromBasket(item)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        showItemViewController(with: itemOrdersInBasket[indexPath.row].item)
    }
    
}

extension BasketViewController: CardInfoViewControllerDelegate {
    
    func didCancel() {
        hud.showHUD(withText: "Payment Cancelled", indicatorType: .failure, showIn: view)
    }
    
    func didFinishRetrievingToken(token: STPToken) {
        finishPayment(token: token)
    }
    
}

extension BasketViewController: BasketItemCellDelegate {
    
    func updateTotalItemPrice(_ cell: BasketItemCell, for item: ItemOrder, itemCount: Int) {
        if let orderIndex = itemOrdersInBasket.firstIndex(where: { $0.itemId == item.itemId }),
           let basket = basket {
            itemOrdersInBasket[orderIndex].itemCount = itemCount
            updateBasket(basket)
        }
        updateTotalLabels(itemOrdersInBasket.isEmpty)
    }
    
    func removeItemOrderFromBasket(_ cell: BasketItemCell, itemOrder: ItemOrder) {
        removeItemFromBasket(itemOrder)
    }
    
}
