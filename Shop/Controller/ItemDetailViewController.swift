//
//  ItemDetailViewController.swift
//  Shop
//
//  Created by Mohsin Ali Ayub on 28.03.22.
//

import UIKit
import JGProgressHUD

class ItemDetailViewController: UIViewController {

    // outlets
    @IBOutlet weak var itemImagesCollectionView: UICollectionView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    // properties
    let hud = JGProgressHUD(style: .dark)
    
    var item: Item!
    var itemImages = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("Item name is: \(item.name)")
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
