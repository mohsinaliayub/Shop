//
//  HelperFunctions.swift
//  Shop
//
//  Created by Mohsin Ali Ayub on 28.03.22.
//

import Foundation

func convertToCurrency(_ number: Double) -> String {
    let currencyFormatter = NumberFormatter()
    currencyFormatter.usesGroupingSeparator = true
    currencyFormatter.numberStyle = .currency
    currencyFormatter.locale = Locale.current
    
    return currencyFormatter.string(from: NSNumber(value: number))!
    
}
