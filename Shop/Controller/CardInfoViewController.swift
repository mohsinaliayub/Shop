//
//  CardInfoViewController.swift
//  Shop
//
//  Created by Mohsin Ali Ayub on 30.03.22.
//

import UIKit
import Stripe

class CardInfoViewController: UIViewController {

    // Outlets & Views
    
    @IBOutlet weak var doneButton: UIButton!
    let paymentCardTextField = STPPaymentCardTextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(paymentCardTextField)
        
        paymentCardTextField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addConstraint(NSLayoutConstraint(item: paymentCardTextField, attribute: .top, relatedBy: .equal,
                                              toItem: doneButton, attribute: .bottom, multiplier: 1, constant: 30))
        view.addConstraint(NSLayoutConstraint(item: paymentCardTextField, attribute: .leading, relatedBy: .equal, toItem: view,
                                              attribute: .leading, multiplier: 1, constant: 20))
        view.addConstraint(NSLayoutConstraint(item: paymentCardTextField, attribute: .trailing, relatedBy: .equal, toItem: view,
                                              attribute: .trailing, multiplier: 1, constant: -20))
    }
    
    @IBAction func doneButtonPressed() {
        dismiss()
    }
    
    @IBAction func cancelButtonPressed() {
        dismiss()
    }
    
    // MARK: Helpers
    
    private func dismiss() {
        dismiss(animated: true)
    }
    
}
