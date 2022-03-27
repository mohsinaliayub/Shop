//
//  FirebaseCollectionReference.swift
//  Shop
//
//  Created by Mohsin Ali Ayub on 27.03.22.
//

import Foundation
import FirebaseFirestore

enum FirebaseCollectionReference: String {
    case user
    case category
    case items
    case basket
    
    
}

func firebaseReference(_ collectionReference: FirebaseCollectionReference) -> CollectionReference {
    Firestore.firestore().collection(collectionReference.rawValue)
}
