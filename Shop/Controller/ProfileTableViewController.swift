//
//  ProfileTableViewController.swift
//  Shop
//
//  Created by Mohsin Ali Ayub on 28.03.22.
//

import UIKit

class ProfileTableViewController: UITableViewController {
    
    // outlets
    @IBOutlet weak var finishRegistrationButton: UIButton!
    @IBOutlet weak var purchaseHistoryButton: UIButton!
    var rightBarButton: UIBarButtonItem!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkLoginStatus()
        checkOnboardingStatus()
    }
    
    // UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }

    // Actions
    
    @IBAction func rightBarButtonItemPressed() {
        if editBarButton.title == "Login" {
            showLoginVC()
        } else {
            goToEditProfile()
        }
    }
    
    // MARK: - Helpers
    
    private func checkLoginStatus() {
        let title = User.currentUser() == nil ? "Login" : "Edit"
        editBarButton.title = title
    }
    
    private func checkOnboardingStatus() {
        if User.currentUser() != nil {
            
            if User.currentUser()!.onBoard {
                finishRegistrationButton.setTitle("Account is active", for: .normal)
                finishRegistrationButton.isEnabled = false
                purchaseHistoryButton.isEnabled = true
            } else {
                finishRegistrationButton.setTitle("Finish registration", for: .normal)
                finishRegistrationButton.isEnabled = true
                finishRegistrationButton.tintColor = .red
            }
            
        } else {
            finishRegistrationButton.setTitle("Logged out", for: .normal)
            finishRegistrationButton.isEnabled = false
            purchaseHistoryButton.isEnabled = false
        }
    }
    
    private func showLoginVC() {
        let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC")
        self.present(loginVC, animated: true)
    }
    
    private func goToEditProfile() {
        print("Edit Profile")
    }
    
}
