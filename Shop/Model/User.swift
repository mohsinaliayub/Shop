//
//  User.swift
//  Shop
//
//  Created by Mohsin Ali Ayub on 28.03.22.
//

import Foundation
import FirebaseAuth

class User {
    let id: String
    var email: String
    var firstName: String
    var lastName: String
    var purchasedItemIds: [String]
    var fullAddress: String?
    var onBoard: Bool
    
    var fullName: String {
        "\(firstName) \(lastName)"
    }
    var dictionary: [String: Any] {
        [
            Constants.objectId: id,
            Constants.email: email,
            Constants.firstName: firstName,
            Constants.lastName: lastName,
            Constants.purchasedItemIds: purchasedItemIds,
            Constants.fullAddress: fullAddress as Any,
            Constants.onBoard: onBoard
        ]
    }
    
    init(id: String, email: String, firstName: String, lastName: String) {
        self.id = id
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        purchasedItemIds = []
        onBoard = false
    }
    
    init(dictionary: [String: Any]) {
        id = dictionary[Constants.objectId] as! String
        email = dictionary[Constants.email] as! String
        firstName = dictionary[Constants.firstName] as! String
        lastName = dictionary[Constants.lastName] as! String
        purchasedItemIds = dictionary[Constants.purchasedItemIds] as! [String]
        fullAddress = dictionary[Constants.fullAddress] as? String
        onBoard = dictionary[Constants.onBoard] as! Bool
    }
    
    // MARK: Return current user
    
    class func currentUserId() -> String? {
        Auth.auth().currentUser?.uid
    }
    
    class func currentUser() -> User? {
        guard Auth.auth().currentUser != nil else {
            return nil
        }
        
        if let dictionary = UserDefaults.standard.object(forKey: Constants.currentUser) as? [String: Any] {
            return User(dictionary: dictionary)
        }
        
        return nil
    }
    
    // MARK: Login functions
    
    class func loginUser(withEmail email: String, password: String, completion: @escaping(_ error: Error?, _ emailVerified: Bool) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { authDataResult, error in
            // if there's an error, callback with error
            guard let authDataResult = authDataResult, error == nil else {
                completion(error, false)
                return
            }
            
            // if email is not verified, send the caller with that information
            guard authDataResult.user.isEmailVerified else {
                print("Email is not verified")
                completion(nil, false)
                return
            }
            
            // email is verified, there is no error also
            // TODO: Download user from firestore
            completion(nil, true)
        }
    }
    
    class func registerUser(withEmail email: String, password: String, completion: @escaping(_ error: Error?) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { authDataResult, error in
            guard let authDataResult = authDataResult, error == nil else {
                completion(error)
                return
            }
            
            // send email verification
            authDataResult.user.sendEmailVerification { error in
                if let error = error {
                    print("auth email verification: ", error.localizedDescription)
                }
                completion(error)
            }
            
        }
        
    }
    
}
