//
//  Basket.swift
//  Shop
//
//  Created by Mohsin Ali Ayub on 28.03.22.
//

import Foundation

class Basket {
    class ItemOrder: Codable {
        var itemId: String
        var itemCount: Int
        var item: Item!
        
        var dictionary: [String: Any] {
            [
                Constants.objectId: itemId,
                Constants.itemOrderCount: itemCount
            ]
        }
        
        init(itemId: String, itemCount: Int) {
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
    var itemOrders: [ItemOrder]
    var itemOrdersDict: [[String: Any]] {
        var dict = [[String: Any]]()
        for order in itemOrders {
            dict.append(order.dictionary)
        }
        return dict
    }
    var itemIds: [String]
    
    var dictionary: [String: Any] {
        [
            Constants.objectId: id,
            Constants.ownerId: ownerId,
            Constants.itemIds: itemIds,
            Constants.itemOrders: itemOrdersDict
        ]
    }
    
    init(ownerId: String) {
        self.id = UUID().uuidString
        self.ownerId = ownerId
        self.itemIds = []
        self.itemOrders = []
    }
    
    init(dictionary: [String: Any]) {
        id = dictionary[Constants.objectId] as! String
        ownerId = dictionary[Constants.ownerId] as! String
        itemIds = dictionary[Constants.itemIds] as! [String]
        itemOrders = []
        let orders = dictionary[Constants.itemOrders] as! [[String: Any]]
        for order in orders {
            itemOrders.append(ItemOrder(dictionary: order))
        }
    }
    
    func addItemOrder(withId itemId: String, count: Int) {
        itemOrders.append(ItemOrder(itemId: itemId, itemCount: count))
    }
}

// MARK: - Save, Update & Retrieve basket from Firebase Firestore

func saveBasketToFirestore(_ basket: Basket) {
    firebaseReference(.basket).document(basket.id).setData(basket.dictionary)
}

func downloadItemsForBasketOrders(_ itemOrders: [Basket.ItemOrder], completion: @escaping ([Basket.ItemOrder]) -> Void) {
    var count = 0
    var orders = [Basket.ItemOrder]()
    
    for order in itemOrders {
        firebaseReference(.items).document(order.itemId).getDocument { snapshot, error in
            count += 1
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let snapshot = snapshot, snapshot.exists else {
                return
            }
            
            // download item, append new item to our return array
            let item = Item(dictionary: snapshot.data()!)
            let itemOrder = Basket.ItemOrder(itemId: order.itemId, itemCount: order.itemCount)
            itemOrder.item = item
            orders.append(itemOrder)
            
            if count == itemOrders.count {
                completion(orders)
            }
        }
    }
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
