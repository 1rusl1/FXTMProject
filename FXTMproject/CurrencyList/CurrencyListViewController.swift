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
    let numberOfCells = 40
    let cellNibName = "CurrencyPairCell"
    let favoritesKey = "favoritesArray"
    
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
        tableView.register(UINib(nibName: cellNibName, bundle: nil), forCellReuseIdentifier: identifier)
    }
    
}

extension CurrencyListViewController: CurrencyPairCellDelegate {
    func addToFavoritesButtonPressed(currencyPair pair: String) {
        var favoritesArray = UserDefaults.standard.array(forKey: favoritesKey)
        favoritesArray?.append(pair)
        UserDefaults.standard.set(favoritesArray, forKey: favoritesKey)
    }
    
    
}

extension CurrencyListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyPairsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! CurrencyPairCell
        let pair = currencyPairsArray[indexPath.row].formattedPair()
        cell.currencyPair = pair
        cell.currencyPairLabel.text = pair
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chartController = ChartViewController()
        chartController.currencyPair = currencyPairsArray[indexPath.row]
        navigationController?.pushViewController(chartController, animated: true)
    }
}
