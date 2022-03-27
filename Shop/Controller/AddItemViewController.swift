//
//  AddItemViewController.swift
//  Shop
//
//  Created by Mohsin Ali Ayub on 27.03.22.
//

import UIKit
import JGProgressHUD
import NVActivityIndicatorView

class AddItemViewController: UIViewController {
    
    // outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    // properties
    let gallery = GalleryController()
    let hud = JGProgressHUD(style: .dark)
    var activityIndicator: NVActivityIndicatorView?
    
    var categoryId: String!
    var itemImages = [UIImage?]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("Category Id: \(String(describing: categoryId))")
    }
    
    // MARK: Actions
    
    @IBAction func saveItem(_ sender: UIBarButtonItem) {
        dismissKeyboard()
        
        guard fieldsAreCompleted() else {
            print("Error: All fields are required!")
            // TODO: Show error to the user
            return
        }
        
        saveToFirestore()
        print("We have values")
    }
    
    @IBAction func cameraButtonPressed(_ sender: UIButton) {
        dismissKeyboard()
        itemImages = [] // whenever user presses camera, remove previous images
        showImageGallery()
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        dismissKeyboard()
    }
    
    // MARK: Helper methods
    
    private func fieldsAreCompleted() -> Bool {
        guard let titleText = titleTextField.text,
              let priceText = priceTextField.text,
              let descriptionText = descriptionTextView.text else {
            return false
        }
        
        return !titleText.isEmpty && !priceText.isEmpty && !descriptionText.isEmpty
    }
    
    private func dismissKeyboard() {
        view.endEditing(false)
    }
    
    private func popTheView() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func showImageGallery() {
        // set the delegate to receive images
        gallery.delegate = self
        
        // configure number of tabs and maximum number of images to be selected
        Config.tabsToShow = [.imageTab, .cameraTab]
        Config.Camera.imageLimit = 5
        
        present(gallery, animated: true)
    }
    
    // MARK: Save Item to Firestore
    
    private func saveToFirestore() {
        guard let name = titleTextField.text,
              let priceText = priceTextField.text,
              let price = Double(priceText),
              let description = descriptionTextView.text else {
            return
        }
        
        let item = Item(categoryId: categoryId, name: name, description: description, price: price)
        
        // if we have images, save them to Firebase Storage first and then save the item
        // to Firebase Firestore. Otherwise, simply save the item object to Firebase Firestore.
        if !itemImages.isEmpty {
            
            // upload the images to Firebase Storage
            StorageService.shared.uploadImages(images: itemImages, itemId: item.id) { imageLinks in
                // save links to item object, save the item to Firestore and pop the view
                item.imageLinks = imageLinks
                saveItemToFirestore(item)
                self.popTheView()
            }
            
        } else {
            saveItemToFirestore(item)
            popTheView()
        }
    }
}


extension AddItemViewController: GalleryControllerDelegate {
    
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        controller.dismiss(animated: true)
        
        guard !images.isEmpty else { return }
        
        // Convert Image objects into UIImage objects
        Image.resolve(images: images) { resolvedImages in
            self.itemImages = resolvedImages
        }
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        controller.dismiss(animated: true)
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        controller.dismiss(animated: true)
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true)
    }
    
}
