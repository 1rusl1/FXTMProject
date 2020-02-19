//
//  CurrencyListViewController.swift
//  FXTMproject
//
//  Created by Ruslan Sabirov on 18.02.2020.
//  Copyright © 2020 Ruslan Sabirov. All rights reserved.
//

import UIKit

class CurrencyListViewController: UIViewController {
    
    //MARK: Properties
    
    lazy var tableView = UITableView()
    var currencyPairsArray = [String]()
    lazy var fetcher = NetworkDataFetcher()
    
    let identifier = "currencyPairCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetcher.fetchCurrencyPairs { [weak self] pairsArray in
            self?.currencyPairsArray.append(contentsOf: pairsArray)
            self?.tableView.reloadData()
        }
        
        setupVC()
        setupTableView()
        // Do any additional setup after loading the view.
    }
    
    func setupVC() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        navigationItem.title = "Currency pairs"
    }
    
    func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.pinToSuperView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CurrencyPairCell.self, forCellReuseIdentifier: identifier)
    }
    
}

extension CurrencyListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyPairsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        let pair = currencyPairsArray[indexPath.row].formattedPair()
        cell.textLabel?.text = pair
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chartController = ChartViewController()
        chartController.currencyPair = currencyPairsArray[indexPath.row]
        navigationController?.pushViewController(chartController, animated: true)
    }
}
