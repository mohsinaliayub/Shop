//
//  Double+Extension.swift
//  Shop
//
//  Created by Mohsin Ali Ayub on 02.04.22.
//

import Foundation

extension Double {
    
    /// Converts double to its currency representation in the current Locale.
    var currencyValue: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale.current
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.numberStyle = .currency
        
        let number = NSNumber(value: self)
        return numberFormatter.string(from: number)!
    }
    
}
