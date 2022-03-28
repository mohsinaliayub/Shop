//
//  LoginViewController.swift
//  Shop
//
//  Created by Mohsin Ali Ayub on 28.03.22.
//

import UIKit

class LoginViewController: UIViewController {
    
    // outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var resendEmailButton: UIButton!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: Actions
    @IBAction func cancelLogin(_ sender: UIBarButtonItem) {
        print("cancel")
    }
    
    @IBAction func login(_ sender: UIButton) {
        print("login")
    }
    
    @IBAction func register(_ sender: UIButton) {
        print("register")
    }
    
    @IBAction func forgotPasswordPressed(_ sender: UIButton) {
        print("forgot password")
    }
    
    @IBAction func resendEmailButtonPressed(_ sender: UIButton) {
        print("resend email")
    }
    
}
