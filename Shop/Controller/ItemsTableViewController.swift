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
    private let itemDetailSegue = "itemDetail"
    private let itemCell = "itemInfoCell"
    private let itemDetailVCStoryboardId = "itemDetailViewController"
    
    var category: Category!
    var items = [Item]() {
        didSet {
            tableView.reloadData()
        }
    }

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let itemInfoNib = UINib(nibName: "ItemInfoCell", bundle: nil)
        tableView.register(itemInfoNib, forCellReuseIdentifier: itemCell)
        
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
        downloadItemsFromFirestore(withCategoryId: category.id) { items, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            // TODO: handle the case when there are no items in the array
            guard let items = items else {
                return
            }

            self.items = items
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: itemCell, for: indexPath) as! ItemInfoCell

        cell.showCell(withItem: items[indexPath.row])
        cell.backgroundColor = .white

        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: itemDetailSegue, sender: indexPath)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == addItemSegue,
           let addItemViewController = segue.destination as? AddItemViewController {
            addItemViewController.categoryId = category.id
        } else if segue.identifier == itemDetailSegue,
                  let itemDetailVC = segue.destination as? ItemDetailViewController {
            itemDetailVC.item = items[(sender as! IndexPath).row]
        }
    }

}
