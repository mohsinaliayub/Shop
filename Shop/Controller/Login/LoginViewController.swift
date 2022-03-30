//
//  LoginViewController.swift
//  Shop
//
//  Created by Mohsin Ali Ayub on 28.03.22.
//

// TODO: Create a new sign in screen that will get user information, and shows them to verify their email
// But now you can fill in the fields (email and password) - and click the ´Register now` button at the bottom
// of the view

import UIKit
import JGProgressHUD
import NVActivityIndicatorView

class LoginViewController: UIViewController {
    
    // outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var resendEmailButton: UIButton!
    
    // properties
    let hud = JGProgressHUD(style: .dark)
    var activityIndicator: NVActivityIndicatorView?

    var textFieldsHaveText: Bool {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return false
        }
        
        return !email.isEmpty && !password.isEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let rect = CGRect(x: view.frame.width / 2 - 30,
                          y: view.frame.height / 2 - 30,
                          width: 60, height: 60)
        activityIndicator = NVActivityIndicatorView(frame: rect, type: .ballPulse,
                                                    color: Constants.appColor, padding: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        activityIndicator?.stopAnimating()
        activityIndicator = nil
    }
    
    // MARK: Actions
    @IBAction func cancelLogin(_ sender: UIBarButtonItem) {
        dismissVC()
    }
    
    @IBAction func login(_ sender: UIButton) {
        guard textFieldsHaveText else {
            showErrorHUD(withText: "All fields are required")
            return
        }
        
        loginUser()
    }
    
    @IBAction func register(_ sender: UIButton) {
        guard textFieldsHaveText else {
            showErrorHUD(withText: "All fields are required")
            return
        }
        
        registerUser()
    }
    
    @IBAction func forgotPasswordPressed(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty else {
            showErrorHUD(withText: "Email field must not be empty!")
            return
        }
        
        resetPassword()
    }
    
    @IBAction func resendEmailButtonPressed(_ sender: UIButton) {
        
        guard let email = emailTextField.text, !email.isEmpty else {
            showErrorHUD(withText: "Email field must not be empty!")
            return
        }
        
        resetPassword()
    }
    
    // MARK: Login, Register user
    
    private func loginUser() {
        showLoadingIndicator()
        
        User.loginUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { error, isEmailVerified in
            self.hideLoadingIndicator()
            
            // if an error occured, show error information to the user - Please make it user readable
            guard error == nil else {
                print("Error loggin in: ", error!.localizedDescription)
                self.showErrorHUD(withText: error!.localizedDescription)
                return
            }
            
            // if email is verified - just dismiss the view. If not, show error to the user.
            if isEmailVerified {
                self.dismissVC()
            } else {
                self.showErrorHUD(withText: "Please verify your email!")
                self.resendEmailButton.isHidden = false
            }
        }
    }
    
    private func registerUser() {
        showLoadingIndicator()
        
        User.registerUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { error in
            self.hideLoadingIndicator()
            
            // we have an error so display relevant error information
            guard error == nil else {
                print("Error registering: ", error!.localizedDescription)
                self.showErrorHUD(withText: error!.localizedDescription)
                return
            }
            
            // there is no error - show verification email is sent!
            self.showHUD(withIndicator: JGProgressHUDSuccessIndicatorView(),
                         andText: "Verification email sent!")
        }
    }
    
    // MARK: Helper methods
    
    private func resetPassword() {
        guard let email = emailTextField.text, !email.isEmpty else {
            showErrorHUD(withText: "Email field must not be empty!")
            return
        }
        
        User.resetPassword(forEmail: email) { error in
            if let error = error {
                self.showErrorHUD(withText: error.localizedDescription)
                return
            }
            
            self.showHUD(withIndicator: JGProgressHUDSuccessIndicatorView(),
                         andText: "Reset password link has been sent to your email!")
        }
    }
    
    private func dismissVC() {
        dismiss(animated: true)
    }
    
    private func showLoadingIndicator() {
        guard let activityIndicator = activityIndicator else {
            return
        }

        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        activityIndicator?.stopAnimating()
        activityIndicator?.removeFromSuperview()
    }
    
    private func showHUD(withIndicator indicatorView: JGProgressHUDIndicatorView, andText text: String) {
        hud.textLabel.text = text
        hud.indicatorView = indicatorView
        hud.show(in: view)
        hud.dismiss(afterDelay: 2.0)
    }
    
    private func showErrorHUD(withText text: String) {
        showHUD(withIndicator: JGProgressHUDErrorIndicatorView(), andText: text)
    }
    
}
