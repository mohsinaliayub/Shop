//
//  Basket.swift
//  Shop
//
//  Created by Mohsin Ali Ayub on 28.03.22.
//

import Foundation

class Basket {
    struct ItemOrder {
        var itemId: String
        var itemCount: Int
        
        var dictionary: [String: Any] {
            [
                Constants.objectId: itemId,
                Constants.itemOrderCount: itemCount
            ]
        }
        
        init(itemId: String, itemCount: Int = 1) {
            self.itemId = itemId
            self.itemCount = itemCount
        }
        
        init(dictionary: [String: Any]) {
            itemId = dictionary[Constants.objectId] as! String
            itemCount = dictionary[Constants.itemOrderCount] as! Int
        }
    }
    
    var id: String
    var ownerId: String
    var itemIds: [String]
    
    var dictionary: [String: Any] {
        [
            Constants.objectId: id,
            Constants.ownerId: ownerId,
            Constants.itemIds: itemIds
        ]
    }
    
    init(ownerId: String) {
        self.id = UUID().uuidString
        self.ownerId = ownerId
        self.itemIds = []
    }
    
    init(dictionary: [String: Any]) {
        id = dictionary[Constants.objectId] as! String
        ownerId = dictionary[Constants.ownerId] as! String
        itemIds = dictionary[Constants.itemIds] as! [String]
    }
}

// MARK: - Save, Update & Retrieve basket from Firebase Firestore

func saveBasketToFirestore(_ basket: Basket) {
    firebaseReference(.basket).document(basket.id).setData(basket.dictionary)
}

func downloadBasketFromFirestore(for ownerId: String, completion: @escaping (Basket?, Error?) -> Void) {
    firebaseReference(.basket)
        .whereField(Constants.ownerId, isEqualTo: ownerId)
        .getDocuments { snapshot, error in
            // error happened, callback with error
            if let error = error {
                print(error.localizedDescription)
                completion(nil, error)
                return
            }
            
            // either no snapshot or snapshot is empty, callback with nil
            guard let snapshot = snapshot, !snapshot.isEmpty else {
                completion(nil, nil)
                return
            }
            
            // get basket data and return to caller in callback
            let basket = Basket(dictionary: snapshot.documents.first!.data())
            completion(basket, nil)
    }
}

func updateBasketInFirestore(_ basket: Basket, withValues values: [String: Any],
                             completion: @escaping (_ error: Error?) -> Void) {
    
    firebaseReference(.basket).document(basket.id).updateData(values) { error in
        completion(error)
    }
}
