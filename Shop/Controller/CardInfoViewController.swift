//
//  CardInfoViewController.swift
//  Shop
//
//  Created by Mohsin Ali Ayub on 30.03.22.
//

import UIKit
import Stripe

protocol CardInfoViewControllerDelegate: AnyObject {
    func didFinishRetrievingToken(token: STPToken)
    func didCancel()
}

class CardInfoViewController: UIViewController {

    // Outlets & Views
    
    @IBOutlet weak var doneButton: UIButton!
    let paymentCardTextField = STPPaymentCardTextField()
    
    weak var delegate: CardInfoViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(paymentCardTextField)
        
        paymentCardTextField.translatesAutoresizingMaskIntoConstraints = false
        paymentCardTextField.delegate = self
        
        view.addConstraint(NSLayoutConstraint(item: paymentCardTextField, attribute: .top, relatedBy: .equal,
                                              toItem: doneButton, attribute: .bottom, multiplier: 1, constant: 30))
        view.addConstraint(NSLayoutConstraint(item: paymentCardTextField, attribute: .leading, relatedBy: .equal, toItem: view,
                                              attribute: .leading, multiplier: 1, constant: 20))
        view.addConstraint(NSLayoutConstraint(item: paymentCardTextField, attribute: .trailing, relatedBy: .equal, toItem: view,
                                              attribute: .trailing, multiplier: 1, constant: -20))
    }
    
    @IBAction func doneButtonPressed() {
        processCard()
    }
    
    @IBAction func cancelButtonPressed() {
        delegate?.didCancel()
        dismiss()
    }
    
    // MARK: Helpers
    
    private func dismiss() {
        dismiss(animated: true)
    }
    
    private func processCard() {
        let cardParams = STPCardParams()
        cardParams.number = paymentCardTextField.cardNumber
        cardParams.expMonth = UInt(paymentCardTextField.expirationMonth)
        cardParams.expYear = UInt(paymentCardTextField.expirationYear)
        cardParams.cvc = paymentCardTextField.cvc
        
        STPAPIClient.shared.createToken(withCard: cardParams) { token, error in
            if let error = error {
                print("Error processing card token", error.localizedDescription)
            }
            
            guard let token = token else { return }
            
            self.delegate?.didFinishRetrievingToken(token: token)
            self.dismiss()
        }
    }
    
}

extension CardInfoViewController: STPPaymentCardTextFieldDelegate {
    
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        doneButton.isEnabled = textField.isValid
    }
    
}
