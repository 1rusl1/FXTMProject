//
//  WebSocketClient.swift
//  FXTMproject
//
//  Created by Ruslan Sabirov on 19.02.2020.
//  Copyright © 2020 Ruslan Sabirov. All rights reserved.
//

import Foundation

struct ApiClient {

    static func URLWithCurrencyPair(_ pair: String) -> URL {
        
        var parameters : [String: String] {
            var params = [String: String]()
            params["event"] = "subscribe"
            params["channel"] = "ticker"
            params["pair"] = pair
            return params
        }
        var url: URL {
            var components = URLComponents()
            components.scheme = "wss"
            components.host = "api.bitfinex.com"
            components.path = "ws/1"
            components.queryItems = parameters.map {URLQueryItem(name: $0, value: $1)}
            return components.url!
        }

        return url
    }
}
