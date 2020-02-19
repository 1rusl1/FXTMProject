//
//  ChartViewController.swift
//  FXTMproject
//
//  Created by Ruslan Sabirov on 18.02.2020.
//  Copyright © 2020 Ruslan Sabirov. All rights reserved.
//
import Starscream
import Charts
import UIKit

class ChartViewController: UIViewController {

    lazy var currencyPair = String()
    lazy var socket : WebSocket = {
        let socket = WebSocket(url: URL(string: "wss://api.bitfinex.com/ws/1")!)
        return socket
    }()
    lazy var fetcher = NetworkDataFetcher()
    lazy var decoder : JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
//    lazy var socketParameters: Data = {
//        let parameters = ["event": "subscribe", "channel": "ticker", "pair": currencyPair]
//
//    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        socket.delegate = self
        socket.connect()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        socket.connect()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        socket.disconnect()
    }
    
    func setupVC() {
        view.backgroundColor = .white
        
    }
    
    deinit {
        socket.delegate = nil
    }
    
}

extension ChartViewController: WebSocketDelegate {
    
    func websocketDidConnect(socket: WebSocketClient) {
        print ("Connected")
        let parameters = ["event": "subscribe", "channel": "ticker", "pair": currencyPair]
        let encoder = JSONEncoder()
        do {
        let encodedData = try encoder.encode(parameters)
            socket.write(data: encodedData)
        }  catch let error {
            print(error)
        }
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print ("Disconnected")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        guard let data = text.data(using: .utf8) else {return}
        guard let currencyPair = fetcher.decode(type: CurrencyPair.self, decoder: decoder, from: data) else {return}
        print (currencyPair.lastPrice)
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
    
    }
    
}
