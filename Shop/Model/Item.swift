//
//  Item.swift
//  Shop
//
//  Created by Mohsin Ali Ayub on 27.03.22.
//

import Foundation

class Item: Codable {
    let id: String
    let categoryId: String
    var name: String
    var description: String
    var price: Double
    var itemOrderCount: Int?
    var imageLinks: [String]
    var itemCountInBasket: Int {
        guard let itemOrderCount = itemOrderCount else {
            return 1
        }

        return itemOrderCount
    }
    
    var dictionary: [String: Any] {
        [
            Constants.objectId: id,
            Constants.categoryId: categoryId,
            Constants.name: name,
            Constants.description: description,
            Constants.price: price,
            Constants.imageLinks: imageLinks,
            Constants.itemOrderCount: itemOrderCount as Any
        ]
    }
    
    init(categoryId: String, name: String, description: String, price: Double) {
        self.id = UUID().uuidString
        self.categoryId = categoryId
        self.name = name
        self.description = description
        self.price = price
        self.imageLinks = []
    }
    
    init(dictionary: [String: Any]) {
        id = dictionary[Constants.objectId] as! String
        categoryId = dictionary[Constants.categoryId] as! String
        name = dictionary[Constants.name] as! String
        description = dictionary[Constants.description] as! String
        price = dictionary[Constants.price] as! Double
        imageLinks = dictionary[Constants.imageLinks] as! [String]
        itemOrderCount = dictionary[Constants.itemOrderCount] as? Int
    }
    
}

// MARK: Save & retrive items

func saveItemToFirestore(_ item: Item) {
    firebaseReference(.items).document(item.id).setData(item.dictionary)
}

func downloadItemsFromFirestore(withCategoryId categoryId: String,
                                completion: @escaping (_ items: [Item]?, _ error: Error?) -> Void) {
    
    var items = [Item]()
    
    firebaseReference(.items)
        .whereField(Constants.categoryId, isEqualTo: categoryId)
        .getDocuments { snapshot, error in
            // error occured notify the caller
            if let error = error {
                completion(nil, error)
                return
            }
            
            // if we don't have a snapshot or if it is empty, return empty array
            guard let snapshot = snapshot, !snapshot.isEmpty else {
                completion(items, nil)
                return
            }
            
            // put all the items in the array and send a callback
            for item in snapshot.documents {
                items.append(Item(dictionary: item.data()))
            }
            completion(items, nil)
    }
}

func downloadItems(withIds ids: [String], completion: @escaping (_ items: [Item]) -> Void) {
    if ids.isEmpty {
        completion([])
        return
    }
    
    var count = 0
    var items = [Item]()
    
    // download every item and append to the items array
    ids.forEach { id in
        firebaseReference(.items).document(id).getDocument { snapshot, error in
            // TODO: Return error from this by creating an errors array with a description of why we couldn't get the item
            // if snapshot does not exist, return with empty array - we were unable to download every single item
            guard let snapshot = snapshot, snapshot.exists else {
                completion(items)
                return
            }
            
            items.append(Item(dictionary: snapshot.data()!))
            count += 1
            
            if count == ids.count {
                completion(items)
            }
        }
    }
}

// MARK: - Algolia Functions


