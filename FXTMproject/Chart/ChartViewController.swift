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
    
    //MARK: - Properties
    
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
    
    lazy var timer = Timer()
    
    lazy var chartDataSet : LineChartDataSet = {
        let set = LineChartDataSet()
        set.valueFont = UIFont.systemFont(ofSize: 10)
        set.valueTextColor = .white
        
        return set
    }()
    
    lazy var chartView = LineChartView()
    
    let lastPriceIndex = 7
    
    var counter: Double = 0.0
  
    //MARK: - View lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupVC()
        setChartData()
        setupChartView()
        socket.delegate = self
        socket.connect()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        socket.connect()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] (timer) in
            self?.counter += 1
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        socket.disconnect()
        counter = 0
        timer.invalidate()
    }
    
    //MARK: - Setup UI elements
    
    func setupVC() {
        view.backgroundColor = .white
        view.addSubview(chartView)
        chartView.centerInSuperview(size: .init(width: view.frame.width, height: view.frame.width))
    }
    
    //MARK: - Configure chart
    
    func setupChartView() {
        
        chartView.backgroundColor = .systemBlue
        let systemFont: UIFont = .boldSystemFont(ofSize: 12)
        chartView.rightAxis.enabled = false
        
        chartDataSet.label = currencyPair.formattedPair()
        
        let yAxis = chartView.leftAxis
        yAxis.labelFont = systemFont
        yAxis.labelTextColor = .white
        yAxis.axisLineColor = .white
        yAxis.setLabelCount(6, force: false)
        
        let xAxis = chartView.xAxis
        xAxis.labelFont = systemFont
        xAxis.labelPosition = .bottom
        xAxis.labelTextColor = .white
        xAxis.axisLineColor = .white
        yAxis.setLabelCount(6, force: false)
    }
    
    func setChartData() {
        let data = LineChartData(dataSets: [chartDataSet])
        chartView.data = data
    }
    
    //MARK: - Subscribe to pair price changes
    
    func subscribeToPair(pair: String) {
        let parameters = ["event": "subscribe", "channel": "ticker", "pair": pair]
        let encoder = JSONEncoder()
        do {
            let encodedData = try encoder.encode(parameters)
            socket.write(data: encodedData)
        }  catch let error {
            print(error)
        }
    }
    
    deinit {
        socket.delegate = nil
    }
    
}

//MARK: - WebsocketDelegate

extension ChartViewController: WebSocketDelegate {
    
    func websocketDidConnect(socket: WebSocketClient) {
        print ("Connected")
        subscribeToPair(pair: currencyPair)
        
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print ("Disconnected")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        guard let data = text.data(using: .utf16) else {return}
        guard let currencyPair = fetcher.decode(type: [Double].self, decoder: decoder, from: data) else {return} //data is not coming, only text, decode text data to array
        let lastPrice = currencyPair[lastPriceIndex]
        let entry = ChartDataEntry(x: counter , y: lastPrice)
        chartView.data?.addEntry(entry, dataSetIndex: 0)
        chartView.data?.notifyDataChanged()
        chartView.notifyDataSetChanged()
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        return
    }
}
