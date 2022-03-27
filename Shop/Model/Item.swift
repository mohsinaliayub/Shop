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


