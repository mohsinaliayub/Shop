//
//  PurchasedHistoryTableViewController.swift
//  Shop
//
//  Created by Mohsin Ali Ayub on 30.03.22.
//

import UIKit

class PurchasedHistoryTableViewController: UITableViewController {
    
    // properties
    private let itemCellReuseIdentifier = "itemInfoCell"
    
    var items: [Item] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    var orders: [ItemOrder] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let itemInfoNib = UINib(nibName: "ItemInfoCell", bundle: nil)
        tableView.register(itemInfoNib, forCellReuseIdentifier: itemCellReuseIdentifier)
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadItems()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        orders.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: itemCellReuseIdentifier, for: indexPath) as! ItemInfoCell

        let order = orders[indexPath.row]
        cell.showCell(withItem: order.item, itemCount: order.itemCount)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Load Items
    
    private func loadItems() {
        guard let currentUser = User.currentUser() else { return }
        
        downloadItemsForBasketOrders(currentUser.purchasedOrders) { orders in
            self.orders = orders
        }
    }

}
