//
//  SearchViewController.swift
//  Shop
//
//  Created by Mohsin Ali Ayub on 30.03.22.
//

import UIKit
import NVActivityIndicatorView

class SearchViewController: UIViewController {

    // outlets, views & view-controllers
    
    @IBOutlet weak var tableView: UITableView!
    private let searchController = UISearchController(searchResultsController: nil)
    var activityIndicator: NVActivityIndicatorView!
    
    // properties
    
    private let itemCellReuseIdentifier = "itemCell"
    private let itemDetailVCStoryboardId = "itemDetailViewController"
    
    var searchResults = [Item]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search..."
        searchController.searchBar.searchTextField.clearButtonMode = .whileEditing
        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.becomeFirstResponder()
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let activityIndicatorFrame = CGRect(x: view.frame.width / 2 - 30, y: view.frame.height / 2 - 30, width: 60, height: 60)
        activityIndicator = NVActivityIndicatorView(frame: activityIndicatorFrame, type: .ballPulse,
                                                    color: Constants.appColor, padding: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        activityIndicator = nil
    }
    
    // MARK: Helper methods
    
    private func emptyTextField() {
        searchController.searchBar.text = ""
    }
    
    private func dismissKeyboard() {
        view.endEditing(false)
    }
    
    private func showLoadingIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
    
    // MARK: Navigation
    
    private func showItemDetailVC(withItem item: Item) {
        let itemDetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: itemDetailVCStoryboardId) as! ItemDetailViewController
        
        itemDetailVC.item = item
        
        self.navigationController?.pushViewController(itemDetailVC, animated: true)
    }

}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: itemCellReuseIdentifier, for: indexPath) as! ItemTableViewCell
        
        cell.generateCell(with: searchResults[indexPath.row])
        
        return cell
    }
    
    // UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        showItemDetailVC(withItem: searchResults[indexPath.row])
    }
    
}

extension SearchViewController: UISearchControllerDelegate, UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            searchResults = []
            return
        }
        
        // TODO: make sure search results are performed after some interval
        searchInFirebase(forName: searchText)
    }
    
    
    
    private func searchInFirebase(forName name: String) {
        showLoadingIndicator()
        
        AlgoliaService.shared.search(withText: name) { itemIds in
            
            downloadItems(withIds: itemIds) { items in
                DispatchQueue.main.async {
                    self.searchResults = items
                    self.hideLoadingIndicator()
                }
            }
        }
    }
}
