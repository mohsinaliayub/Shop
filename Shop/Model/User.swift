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
    var fullAddress: String?
    var onBoard: Bool
    var purchasedOrders: [ItemOrder]
    var purchasedOrdersDict: [[String: Any]] {
        var dict = [[String: Any]]()
        for order in purchasedOrders {
            dict.append(order.dictionary)
        }
        return dict
    }
    
    var fullName: String {
        "\(firstName) \(lastName)"
    }
    var dictionary: [String: Any] {
        [
            Constants.objectId: id,
            Constants.email: email,
            Constants.firstName: firstName,
            Constants.lastName: lastName,
            Constants.fullAddress: fullAddress as Any,
            Constants.onBoard: onBoard,
            Constants.purchasedOrders: purchasedOrdersDict
        ]
    }
    
    init(id: String, email: String, firstName: String, lastName: String) {
        self.id = id
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        fullAddress = ""
        purchasedOrders = []
        onBoard = false
    }
    
    init(dictionary: [String: Any]) {
        id = dictionary[Constants.objectId] as! String
        email = dictionary[Constants.email] as! String
        firstName = dictionary[Constants.firstName] as! String
        lastName = dictionary[Constants.lastName] as! String
        fullAddress = dictionary[Constants.fullAddress] as? String
        onBoard = dictionary[Constants.onBoard] as! Bool
        purchasedOrders = []
        let orders = dictionary[Constants.purchasedOrders] as! [[String: Any]]
        for order in orders {
            purchasedOrders.append(ItemOrder(dictionary: order))
        }
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
            downloadUserFromFirestore(withId: authDataResult.user.uid, email: email)
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
    
    class func logOutCurrentUser(completion: @escaping (Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: Constants.currentUser)
            UserDefaults.standard.synchronize()
            
            completion(nil)
        } catch {
            completion(error)
        }
    }
    
    // MARK: - Resend link methods
    class func resetPassword(forEmail email: String, completion: @escaping (_ error: Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            completion(error)
        }
    }
    
    class func resendVerificationEmail(email: String, completion: @escaping(Error?) -> Void) {
        Auth.auth().currentUser?.reload(completion: { error in
            Auth.auth().currentUser?.sendEmailVerification(completion: { error in
                completion(error)
            })
        })
    }
    
}






// MARK: - Save, Update & Retrieve User Info from Firebase Firestore

func saveUserToFirestore(_ user: User) {
    firebaseReference(.user).document(user.id).setData(user.dictionary) { error in
        if let error = error {
            print("Error saving user \(error.localizedDescription)")
        }
    }
}

func updateCurrentUserInFirestore(withValues values: [String: Any], completion: @escaping (Error?) -> Void) {
    guard var dictionary = UserDefaults.standard.object(forKey: Constants.currentUser) as? [String: Any],
          let currentUserId = User.currentUserId()
    else {
        return
    }
    
    // update the value for keys in saved dictionary
    values.forEach { dictionary[$0] = $1 }
    
    // update user in firestore, and then if there's no error, save it locally as well
    firebaseReference(.user).document(currentUserId).updateData(values) { error in
        completion(error)
        
        if error == nil {
            saveUserLocally(userDictionary: dictionary)
        }
    }
}

func downloadUserFromFirestore(withId userId: String, email: String) {
    firebaseReference(.user).document(userId).getDocument { snapshot, error in
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        // there is no snapshot, create a new user
        guard let snapshot = snapshot, snapshot.exists else {
            let user = User(id: userId, email: email, firstName: "", lastName: "")
            saveUserLocally(userDictionary: user.dictionary)
            saveUserToFirestore(user)
            return
        }
        
        // a user data already exists, so save it to UserDefaults
        print("download current user from firestore")
        saveUserLocally(userDictionary: snapshot.data()!)
    }
}

func saveUserLocally(userDictionary: [String: Any]) {
    UserDefaults.standard.set(userDictionary, forKey: Constants.currentUser)
}
