//
//  JGProgressHUDExtension.swift
//  Shop
//
//  Created by Mohsin Ali Ayub on 30.03.22.
//

import UIKit
import JGProgressHUD

enum ProgressHUGIndicator {
    case success
    case failure
    
    var indicatorView: JGProgressHUDIndicatorView {
        switch self {
        case .success: return JGProgressHUDSuccessIndicatorView()
        case .failure: return JGProgressHUDErrorIndicatorView()
        }
    }
}

extension JGProgressHUD {
    
    func showHUD(withText text: String, indicatorType type: ProgressHUGIndicator, showIn view: UIView,
                 dismissDelay delay: TimeInterval = 2.0, completion: (() -> Void)? = nil) {
        self.textLabel.text = text
        self.indicatorView = type.indicatorView
        self.show(in: view)
        self.dismiss(afterDelay: delay, animated: true, completion: completion)
    }
    
}
