//
//  ItemDetailViewController.swift
//  Shop
//
//  Created by Mohsin Ali Ayub on 28.03.22.
//

import UIKit
import JGProgressHUD

class ItemDetailViewController: UIViewController {

    // outlets
    @IBOutlet weak var itemImagesCollectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    // properties
    private let imageCell = "imageCell"
    let hud = JGProgressHUD(style: .dark)
    
    var item: Item!
    var itemImages = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    // MARK: - Set Up UI
    
    private func setupUI() {
        title = item.name
        nameLabel.text = item.name
        priceLabel.text = convertToCurrency(item.price)
        descriptionTextView.text = item.description
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}

extension ItemDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCell, for: indexPath) as! ImageCollectionViewCell
        
        return cell
    }
    
    
}

