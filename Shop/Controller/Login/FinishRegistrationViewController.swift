//
//  FinishRegistrationViewController.swift
//  Shop
//
//  Created by Mohsin Ali Ayub on 30.03.22.
//

import UIKit
import JGProgressHUD

class FinishRegistrationViewController: UIViewController {

    // outlets & views
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    private let hud = JGProgressHUD(style: .dark)
    
    // properties
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        surnameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        addressTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    // Actions
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        finishOnBoarding()
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        updateDoneButtonStatus()
    }
    
    // Helper methods
    
    private func showHUD(withText text: String, success: Bool, completion: (() -> Void)? = nil) {
        hud.textLabel.text = text
        hud.indicatorView = success ? JGProgressHUDSuccessIndicatorView() : JGProgressHUDErrorIndicatorView()
        hud.show(in: view)
        hud.dismiss(afterDelay: 2.0, animated: true, completion: completion)
        
    }
    
    private func updateDoneButtonStatus() {
        guard let name = nameTextField.text, let surname = surnameTextField.text,
              let address = addressTextField.text else {
            doneButton.isEnabled = false
            return
        }
        
        let fieldsHaveValues = !name.isEmpty && !surname.isEmpty && !address.isEmpty
        doneButton.backgroundColor = fieldsHaveValues ? .systemTeal : .lightGray
        doneButton.isEnabled = fieldsHaveValues
    }
    
    private func finishOnBoarding() {
        guard let name = nameTextField.text,
              let surname = surnameTextField.text,
              let address = addressTextField.text else {
            return
        }
        
        let valuesToUpdateInFirestore: [String: Any] = [
            Constants.firstName: name,
            Constants.lastName: surname,
            Constants.fullAddress: address,
            Constants.onBoard: true
        ]
        
        updateCurrentUserInFirestore(withValues: valuesToUpdateInFirestore) { error in
            if let error = error {
                print(error.localizedDescription)
                self.showHUD(withText: error.localizedDescription, success: false)
            } else {
                self.showHUD(withText: "Updated!", success: true) {
                    self.dismiss(animated: true)
                }
            }
        }
    }

}
