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
    @IBOutlet weak var itemDetailView: UIView! {
        didSet {
            itemDetailView.layer.cornerRadius = 35
            itemDetailView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
    }
    @IBOutlet weak var itemImagesContainer: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    private var itemImagesViewController: ItemImagesViewController!
    
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
                self.itemImagesViewController.images = self.itemImages
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        changeCartButtonState()
        downloadPictures()
        
        if let childVC = self.children.first as? ItemImagesViewController {
            itemImagesViewController = childVC
        }
        
        self.navigationItem.leftBarButtonItems = [
            UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(backAction))
        ]
    }
    
    // MARK: - Set Up UI
    
    private func changeCartButtonState() {
        self.addToCartButton.isEnabled = true
        guard let currentUser = User.currentUser() else { return }
        
        downloadBasketFromFirestore(for: currentUser.id) { basket, error in
            guard let basket = basket else {
                return
            }

            if let _ = basket.itemOrders.firstIndex(where: { $0.itemId == self.item.id }) {
                self.addToCartButton.isEnabled = false
                self.addToCartButton.backgroundColor = .lightGray
            }
        }
    }
    
    private func setupUI() {
        nameLabel.text = item.name
        priceLabel.text = convertToCurrency(item.price)
        descriptionLabel.text = item.description
        
        addToCartButton.setTitle("Already in cart", for: .disabled)
        addToCartButton.setTitleColor(.white, for: .disabled)
    }
    
    private func downloadPictures() {
        guard !item.imageLinks.isEmpty  else { return }
        
        StorageService.shared.downloadImages(fromUrls: item.imageLinks) { images in
            if images.isEmpty { return }
            
            self.itemImages = images
        }
    }

    // MARK: - Actions
    
    @objc private func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func addToBasket() {
        // if no user is logged in, show login view
        guard let currentUser = User.currentUser() else {
            showLoginViewController()
            return
        }
        
        // user is logged in, download his/her basket
        downloadBasketFromFirestore(for: currentUser.id) { basket, error in
            // if there's no basket, create new basket
            guard let basket = basket else {
                self.createNewBasket()
                return
            }

            // basket already exists, append an item and update in the firestore
            basket.addItemOrder(withId: self.item.id, count: 1)
            self.updateBasket(basket)
            self.changeCartButtonState()
        }
        
    }
    
    // MARK: - Add to basket
    
    private func createNewBasket() {
        guard let currentUserId = User.currentUserId() else { return }
        
        let newBasket = Basket(ownerId: currentUserId)
        newBasket.addItemOrder(withId: self.item.id, count: 1)
        
        saveBasketToFirestore(newBasket)
        self.hud.showHUD(withText: "Added to basket!", indicatorType: .success, showIn: view)
    }
    
    private func updateBasket(_ basket: Basket) {
        updateBasketInFirestore(basket) { error in
            // Error happened, handle it
            if let error = error {
                // TODO: show a more useful error
                self.hud.showHUD(withText: "Error: \(error.localizedDescription)",
                                 indicatorType: .failure, showIn: self.view)
                return
            }
            
            // show success information to the user
            self.hud.showHUD(withText: "Added to basket", indicatorType: .success, showIn: self.view)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    private func showLoginViewController() {
        let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC")
        
        self.present(loginVC, animated: true)
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


