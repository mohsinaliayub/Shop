//
//  Category.swift
//  Shop
//
//  Created by Mohsin Ali Ayub on 27.03.22.
//

import Foundation
import UIKit

class Category {
    let id: String
    let name: String
    let imageName: String?
    
    var image: UIImage? {
        UIImage(named: imageName ?? "")
    }
    
    var dictionary: [String: Any] {
        [
            Constants.objectId: id,
            Constants.name: name,
            Constants.imageName: imageName as Any
        ]
    }
    
    init(name: String, imageName: String) {
        self.id = UUID().uuidString
        self.name = name
        self.imageName = imageName
    }
    
    init(dictionary: [String: Any]) {
        id = dictionary[Constants.objectId] as! String
        name = dictionary[Constants.name] as! String
        imageName = dictionary[Constants.imageName] as? String
    }
}

// MARK: Download Category

func downloadCategoriesFromFirebase(completion: @escaping ([Category]?, Error?) -> Void) {
    var categories = [Category]()
    
    firebaseReference(.category).getDocuments { snapshot, error in
        // an error occured - callback with error
        if let error = error {
            completion(nil, error)
            return
        }
        
        // there is no snapshot, or there is no data - we don't have an error also
        // callback with no categories and no error
        guard let snapshot = snapshot, !snapshot.isEmpty else {
            completion(categories, nil)
            return
        }
        
        // we have our categories - callback with our categories and no error
        for document in snapshot.documents {
            categories.append(Category(dictionary: document.data()))
        }
        completion(categories, nil)
    }
}

// MARK: Save Category

func saveCategoryToFirebase(_ category: Category) {
    firebaseReference(.category).document(category.id).setData(category.dictionary)
}

// MARK: Use only one time
func createCategorySet() {
    let womenClothing = Category(name: "Women's Clothing & Accessories", imageName: "womenCloth")
    let footWear = Category(name: "Footwear", imageName: "footWear")
    let electronics = Category(name: "Electronics", imageName: "electronics")
    let menClothing = Category(name: "Men's Clothing & Accessories", imageName: "menCloth")
    let health = Category(name: "Health & Beauty", imageName: "health")
    let baby = Category(name: "Baby Products", imageName: "baaby")
    let home = Category(name: "Home & Kitchen", imageName: "home")
    let car = Category(name: "Automobile & Motorcycles", imageName: "car")
    let luggage = Category(name: "Luggage & Bags", imageName: "luggage")
    let jewelery = Category(name: "Jewelery", imageName: "jewelery")
    let hobby = Category(name: "Hobby, Sport, Travelling", imageName: "hobby")
    let pet = Category(name: "Pet Products", imageName: "pet")
    let industry = Category(name: "Industry & Business", imageName: "industry")
    let garden = Category(name: "Garden Supplies", imageName: "garden")
    let camera = Category(name: "Cameras & Optics", imageName: "camera")
    
    let categories = [womenClothing, footWear, electronics, menClothing, health, baby,
                      home, car, luggage, jewelery, hobby, pet, industry, garden, camera]
    
    for category in categories {
        saveCategoryToFirebase(category)
    }
}
