//
//  CategoryCollectionViewController.swift
//  Shop
//
//  Created by Mohsin Ali Ayub on 27.03.22.
//

import UIKit

class CategoryCollectionViewController: UICollectionViewController {
    
    // properties
    private let reuseIdentifier = "CategoryCell"
    
    var categories = [Category]() {
        didSet {
            collectionView.reloadData()
        }
    }

    
    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CategoryCollectionViewCell
    
        return cell
    }
    
    // MARK: Download categories
    
    private func loadCategories() {
        
        downloadCategoriesFromFirebase { categories, error in
            // handle the error
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            // make sure we have categories not empty - if empty show relevant error
            guard let categories = categories, !categories.isEmpty else {
                return
            }
            
            self.categories = categories
        }
        
    }

}
