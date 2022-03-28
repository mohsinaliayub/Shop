//
//  Item.swift
//  Shop
//
//  Created by Mohsin Ali Ayub on 27.03.22.
//

import Foundation

class Item {
    let id: String
    let categoryId: String
    var name: String
    var description: String
    var price: Double
    var imageLinks: [String]
    
    var dictionary: [String: Any] {
        [
            Constants.objectId: id,
            Constants.categoryId: categoryId,
            Constants.name: name,
            Constants.description: description,
            Constants.price: price,
            Constants.imageLinks: imageLinks
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
        imageLinks = dictionary[Constants.price] as! [String]
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
                print(error.localizedDescription)
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
