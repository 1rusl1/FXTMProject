//
//  NetworkDataFetcher.swift
//  FXTMproject
//
//  Created by Ruslan Sabirov on 18.02.2020.
//  Copyright © 2020 Ruslan Sabirov. All rights reserved.
//

import UIKit

class NetworkDataFetcher: NSObject {
    
   
    let decoder = JSONDecoder()
    
    let urlString = "https://api.bitfinex.com/v1/symbols"
    
    func fetchCurrencyPairs(completion: @escaping([String])->(Void)) {
        guard let url = URL(string: urlString) else {
            print ("Invalid URL!")
            return
        }
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print (error.localizedDescription)
            } else {
                guard let data = data else {
                    print ("NO DATA")
                    return
                }
                do {
                    let decodedData = try self.decoder.decode([String].self, from: data)
                    print ("DATA: \(decodedData)")
                    completion(decodedData)
                } catch let error {
                    print (error.localizedDescription)
                }
            }
        }.resume()
    }
    
}