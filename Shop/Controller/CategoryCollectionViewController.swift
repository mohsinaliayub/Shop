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
    private let categoryToItemsSegue = "categoryToItemsSegue"
    private let sectionInsets = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
    private let itemsPerRow: CGFloat = 3
    
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
    
        cell.generateCell(with: categories[indexPath.row])
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: categoryToItemsSegue, sender: categories[indexPath.row])
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == categoryToItemsSegue,
           let itemViewController = segue.destination as? ItemsTableViewController {
            itemViewController.category = (sender as! Category)
        }
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

extension CategoryCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = floor(availableWidth / itemsPerRow)
        
        return CGSize(width: widthPerItem, height: widthPerItem) // square cells
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        sectionInsets.left
    }
}
