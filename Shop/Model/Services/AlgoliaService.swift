//
//  AlgoliaService.swift
//  Shop
//
//  Created by Mohsin Ali Ayub on 30.03.22.
//

import Foundation
import AlgoliaSearchClient

class AlgoliaService {
    
    static let shared = AlgoliaService()
    
    private let appID = ApplicationID(rawValue: Constants.Algolia.applicationId)
    private let adminKey = APIKey(rawValue: Constants.Algolia.adminKey)
    
    let client: SearchClient
    let index: Index
    
    private init() {
        client = SearchClient(appID: appID, apiKey: adminKey)
        index = client.index(withName: "item_Name")
    }
    
    func saveItemToAlgolia(_ item: Item) {
        do {
            try index.replaceObject(withID: ObjectID(rawValue: item.id), by: item)
            print("added to Algolia")
        } catch {
            print("Error saving to algolia", error.localizedDescription)
        }
    }
    
    func search(withText searchString: String, completion: @escaping ([String]) -> Void) {
        var resultIds = [String]()
        
        let query = Query(searchString).set(\.attributesToRetrieve, to: ["name", "description"])
        
        index.search(query: query) { result in
            switch result {
            case .success(let response):
                for hit in response.hits {
                    resultIds.append(hit.objectID.rawValue)
                }
                completion(resultIds)
                break
            case .failure(let error):
                print(error.localizedDescription)
                completion(resultIds)
                break
            }
        }
    }
    
}
