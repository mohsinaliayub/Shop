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
    private let placeholderImage = UIImage(named: "imagePlaceholder")
    private let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    private let itemsPerRow: CGFloat = 1
    private let cellHeight: CGFloat = 196
    let hud = JGProgressHUD(style: .dark)
    
    var item: Item!
    var itemImages = [UIImage?]() {
        didSet {
            DispatchQueue.main.async {
                self.itemImagesCollectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        downloadPictures()
    }
    
    // MARK: - Set Up UI
    
    private func setupUI() {
        title = item.name
        nameLabel.text = item.name
        priceLabel.text = convertToCurrency(item.price)
        descriptionTextView.text = item.description
    }
    
    private func downloadPictures() {
        guard !item.imageLinks.isEmpty  else { return }
        
        StorageService.shared.downloadImages(fromUrls: item.imageLinks) { images in
            if images.isEmpty { return }
            
            self.itemImages = images
        }
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
        // if there are no images, we need to display a placeholder image
        itemImages.isEmpty ? 1 : itemImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCell, for: indexPath) as! ImageCollectionViewCell
        
        if itemImages.isEmpty {
            cell.setImage(with: placeholderImage)
        } else {
            cell.setImage(with: itemImages[indexPath.row])
        }
        
        return cell
    }
}

extension ItemDetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - sectionInsets.left
        
        return CGSize(width: availableWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        sectionInsets.left
    }
    
}


