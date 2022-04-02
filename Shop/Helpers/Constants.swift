//
//  Constants.swift
//  Shop
//
//  Created by Mohsin Ali Ayub on 27.03.22.
//

import UIKit

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
    
    // User
    static let email = "email"
    static let firstName = "firstName"
    static let lastName = "lastName"
    static let fullName = "fullName"
    static let fullAddress = "fullAddress"
    static let onBoard = "onBoard"
    static let purchasedItemIds = "purchasedItemIds"
    static let currentUser = "currentUser"
    
    // Colors
    static let appColor = UIColor(red: 0.9998469949, green: 0.4941213727, blue: 0.4734867811, alpha: 1)
    
    struct Colors {
        static let appBackgroundColor = UIColor(named: "AppBackgroundColor")!
        static let appPrimaryTextColor = UIColor(named: "AppPrimaryTextColor")!
        static let appSecondaryTextColor = UIColor(named: "AppSecondaryTextColor")!
        static let appButtonColor = UIColor(named: "AppButtonColor")!
    }
    
    struct Algolia {
        public static let applicationId = "YOUR ALGOLIA APP ID"
        public static let publicKey = "YOUR ALGOLIA SEARCH-ONLY API KEY"
        public static let adminKey = "YOUR ALGOLIA ADMIN API KEY"
    }
    
    struct Stripe {
        static let publishableKey = "pk_test_51Kj5CYAzfV4m8rZRKSRxwg6DeMV4fYY6ciU6KoQTO428eU68d06cUrAVbPqVvg9RSWxb8aQo6ppOit7YVHL7om9w00Kh1g0xZF"
        static let baseURLString = "http://localhost:3000/"
        static let defaultCurrency = "eur"
        static let defaultDescription = "Purchase from Shop"
    }
}
