//
//  StorageService.swift
//  Shop
//
//  Created by Mohsin Ali Ayub on 27.03.22.
//

import Foundation
import FirebaseStorage
import UIKit

class StorageService {
    static let shared = StorageService()
    
    private let storage = Storage.storage()
    private var compressionQuality: CGFloat = 0.1
    
    init() { }
    init(compressionQuality: CGFloat) {
        self.compressionQuality = compressionQuality
    }

    func uploadImages(images: [UIImage?], itemId: String,
                             completion: @escaping (_ imageLinks: [String]) -> Void) {
        if !Reachability.hasConnection() {
            print("No internet connection")
            completion([])
            return
        }
        
        var uploadedImagesCount = 0
        var imageLinks = [String]()
        var nameSuffix = 0
        
        for image in images {
            let fileName = "ItemImages/" + itemId + "/" + "\(nameSuffix)" + ".jpg"
            let imageData = image!.jpegData(compressionQuality: compressionQuality)
            
            saveImageInFirebase(imageData: imageData!, fileName: fileName) { imageLink in
                guard let imageLink = imageLink else {
                    return
                }

                // add link to our array
                imageLinks.append(imageLink)
                uploadedImagesCount += 1
                
                // uploaded all the images, return to the caller in callback
                if uploadedImagesCount == images.count {
                    completion(imageLinks)
                }
            }
            
            nameSuffix += 1
        }
    }
    
    private func saveImageInFirebase(imageData: Data, fileName: String,
                                     completion: @escaping (_ imageLink: String?) -> Void) {
        var task: StorageUploadTask!
        
        let storageRef = storage.reference(forURL: Constants.firebaseStorageLink).child(fileName)
        
        task = storageRef.putData(imageData, metadata: nil) { metadata, error in
            task.removeAllObservers()
            
            // an error occured while uploading
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            
            // get the download url of uploaded image
            storageRef.downloadURL { url, error in
                guard let downloadUrl = url else {
                    completion(nil)
                    return
                }
                
                // return the absolute url
                completion(downloadUrl.absoluteString)
            }
        }
    }
    
    func downloadImages(fromUrls imageUrls: [String], completion: @escaping (_ images: [UIImage?]) -> Void) {
        var images = [UIImage?]()
        
        var downloadCounter = 0
        
        for link in imageUrls {
            let url = URL(string: link)
            let downloadQueue = DispatchQueue(label: "imageDownloadQueue")
            
            downloadQueue.async {
                downloadCounter += 1
                
                let data = try? Data(contentsOf: url!)
                if let data = data {
                    images.append(UIImage(data: data))
                    
                    if downloadCounter == imageUrls.count {
                        completion(images)
                    }
                } else {
                    print("Couldn't download image")
                    completion(images)
                }
            }
        }
    }
}


