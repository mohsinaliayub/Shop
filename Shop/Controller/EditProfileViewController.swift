//
//  EditProfileViewController.swift
//  Shop
//
//  Created by Mohsin Ali Ayub on 30.03.22.
//

import UIKit
import JGProgressHUD

class EditProfileViewController: UIViewController {
    
    // outlets & views
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    private let hud = JGProgressHUD(style: .dark)
    
    // properties
    var fieldsHaveValues: Bool {
        guard let name = nameTextField.text,
              let surname = surnameTextField.text,
              let address = addressTextField.text else {
            return false
        }
        
        return !name.isEmpty && !surname.isEmpty && !address.isEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadUserInfo()
    }
    
    // Actions
    
    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        dismissKeyboard()
        
        guard fieldsHaveValues else {
            hud.showHUD(withText: "All fields are required!", indicatorType: .failure, showIn: view, dismissDelay: 2.0)
            return
        }
        
        let valuesToSaveInFirestore: [String: Any] = [
            Constants.firstName: nameTextField.text!,
            Constants.lastName: surnameTextField.text!,
            Constants.fullAddress: addressTextField.text!
        ]
        
        updateCurrentUserInFirestore(withValues: valuesToSaveInFirestore) { error in
            if let error = error {
                print(error.localizedDescription)
                self.hud.showHUD(withText: error.localizedDescription, indicatorType: .failure, showIn: self.view)
                return
            }
            
            self.hud.showHUD(withText: "Updated!", indicatorType: .success, showIn: self.view)
        }
    }
    
    // MARK: UpdateUI
    
    private func loadUserInfo() {
        guard let currentUser = User.currentUser() else {
            return
        }
        
        nameTextField.text = currentUser.firstName
        surnameTextField.text = currentUser.lastName
        addressTextField.text = currentUser.fullAddress
    }
    
    // MARK: Helper methods
    
    private func dismissKeyboard() {
        view.endEditing(false)
    }
    
}
