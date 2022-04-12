//
//  StripeClient.swift
//  Shop
//
//  Created by Mohsin Ali Ayub on 30.03.22.
//

import Foundation
import Stripe
import Alamofire

class StripeClient {
    
    static let shared = StripeClient()
    
    var baseURLString: String? = nil
    var baseURL: URL {
        if let urlString = baseURLString, let url = URL(string: urlString) {
            return url
        }
        
        fatalError()
    }
    
    func createAndConfirmPayment(token: STPToken, amount: Double, completion: @escaping (Error?) -> Void) {
        let url = baseURL.appendingPathComponent("charge")
        
        let params: [String: Any] = [
            "stripeToken": token.tokenId,
            "amount": amount,
            "description": Constants.Stripe.defaultDescription,
            "currency": Constants.Stripe.defaultCurrency
        ]
        
        AF.request(url, method: .post, parameters: params).validate(statusCode: 200..<300).responseData { response in
            switch response.result {
            case .success(_):
                print("Payment successful")
                completion(nil)
            case .failure(let error):
                print("Error processing the payment", error.localizedDescription)
                completion(error)
            }
        }
    }
    
}
