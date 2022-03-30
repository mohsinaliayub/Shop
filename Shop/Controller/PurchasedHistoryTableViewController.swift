//
//  PurchasedHistoryTableViewController.swift
//  Shop
//
//  Created by Mohsin Ali Ayub on 30.03.22.
//

import UIKit

class PurchasedHistoryTableViewController: UITableViewController {
    
    // properties
    private let itemCellReuseIdentifier = "itemCell"
    
    var items: [Item] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadItems()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: itemCellReuseIdentifier, for: indexPath) as! ItemTableViewCell

        cell.generateCell(with: items[indexPath.row])

        return cell
    }
    
    // MARK: - Load Items
    
    private func loadItems() {
        guard let currentUser = User.currentUser() else { return }
        
        downloadItems(withIds: currentUser.purchasedItemIds) { items in
            self.items = items
            print("We have \(items.count) purchased items")
        }
    }

}
