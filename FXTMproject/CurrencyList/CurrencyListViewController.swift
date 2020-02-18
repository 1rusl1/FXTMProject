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
    var currencyPairsArray = [String]() {
        didSet {
            currencyPairsArray.map {
                $0.capitalized
                //$0.insert("/", at: $0.index($0.startIndex, offsetBy: 2))
            }
        }
    }
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
        cell.textLabel?.text = currencyPairsArray[indexPath.row]
        return cell
    }
    
    
}
