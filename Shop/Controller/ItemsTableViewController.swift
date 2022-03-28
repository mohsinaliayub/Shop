//
//  ItemsTableViewController.swift
//  Shop
//
//  Created by Mohsin Ali Ayub on 27.03.22.
//

import UIKit

class ItemsTableViewController: UITableViewController {
    
    // properties
    private let addItemSegue = "addItemSegue"
    private let itemCell = "itemCell"
    
    var category: Category!
    var items = [Item]()

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView() // remove all empty cells
        self.title = category?.name
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let category = category {
            loadItems(from: category)
        }
    }
    
    // MARK: - Load Items
    
    private func loadItems(from category: Category) {
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: itemCell, for: indexPath)

        // Configure the cell...

        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == addItemSegue,
           let addItemViewController = segue.destination as? AddItemViewController {
            addItemViewController.categoryId = category.id
        }
    }

}
