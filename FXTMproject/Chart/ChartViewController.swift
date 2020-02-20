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
    
    lazy var fetcher = NetworkDataFetcher()
    lazy var decoder : JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    lazy var socket : WebSocket = {
        let socket = WebSocket(url: URL(string: "wss://api.bitfinex.com/ws/1")!)
        return socket
    }()
    lazy var socketParameters = ["event": "subscribe", "channel": "ticker", "pair": currencyPair]
    
    var chartDataSet = LineChartDataSet() {
        didSet {
            print ("New entry")
        }
    }

    lazy var chartView : LineChartView = {
        let view = LineChartView()
        view.rightAxis.enabled = false
        view.backgroundColor = .gray
        return view
    }()
    
    let lastPriceIndex = 7
    
    var counter: Double = 0.0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupVC()
        setupUI()
        socket.delegate = self
        socket.connect()
        setData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        socket.connect()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        socket.disconnect()
        counter = 0
    }
    
    func setupVC() {
        view.backgroundColor = .white
        view.addSubview(chartView)
    }
    
    func setupUI() {
        chartView.centerInSuperview(size: .init(width: view.frame.width, height: view.frame.width))
    }
    
    func setData() {
       let data = LineChartData(dataSets: [chartDataSet])
        chartView.data = data
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
        guard let data = text.data(using: .utf16) else {return}
        guard let currencyPair = fetcher.decode(type: [Double].self, decoder: decoder, from: data) else {return}
        let lastPrice = currencyPair[lastPriceIndex]
        let entry = ChartDataEntry(x: counter , y: lastPrice)
        print (lastPrice)
        print (counter)
        chartView.data?.addEntry(entry, dataSetIndex: 0)
        counter += 1.0
        chartView.data?.notifyDataChanged()
        chartView.notifyDataSetChanged()
        
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        
    }
    
}
