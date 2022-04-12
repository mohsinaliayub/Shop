//
//  ItemImageView.swift
//  Shop
//
//  Created by Mohsin Ali Ayub on 12.04.22.
//

import UIKit

class ItemImageView: UIView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initWithNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initWithNib()
    }
    
    private func initWithNib() {
        Bundle.main.loadNibNamed("ItemImage", owner: self)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(contentView)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func showImage(_ image: UIImage?) {
        imageView.image = image
    }

}
