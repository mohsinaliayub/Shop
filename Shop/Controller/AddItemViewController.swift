//
//  AddItemViewController.swift
//  Shop
//
//  Created by Mohsin Ali Ayub on 27.03.22.
//

import UIKit

class AddItemViewController: UIViewController {
    
    // outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    // properties
    var categoryId: String!
    var itemImages = [UIImage]()

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
    
    // MARK: Save Item to Firestore
    
    private func saveToFirestore() {
        guard let name = titleTextField.text,
              let priceText = priceTextField.text,
              let price = Double(priceText),
              let description = descriptionTextView.text else {
            return
        }
        
        let item = Item(categoryId: categoryId, name: name, description: description, price: price)
        if itemImages.count > 0 {
            
        } else {
            saveItemToFirestore(item)
            popTheView()
        }
    }
}
