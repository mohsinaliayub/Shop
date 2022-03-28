//
//  Constants.swift
//  Shop
//
//  Created by Mohsin Ali Ayub on 27.03.22.
//

import Foundation

struct Constants {
    // IDs, Keys and Links
    static let firebaseStorageLink = "gs://shop-88faf.appspot.com"
    
    // Firebase Headers - Folder names in Firestore
    static let userPath = "Users"
    static let categoryPath = "Categories"
    static let itemsPath = "Items"
    static let basketPath = "Basket"
    
    // Category
    static let name = "name"
    static let imageName = "imageName"
    static let objectId = "objectId"
    
    // Item
    static let categoryId = "categoryId"
    static let description = "description"
    static let price = "price"
    static let imageLinks = "imageLinks"
    
    // Basket
    static let ownerId = "ownerId"
    static let itemIds = "itemIds"
}
