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
    var tableView = UITableView()
    var currencyPairsArray = [String]()
    lazy var fetcher = NetworkDataFetcher()
    
    lazy var searchText = String()
    lazy var searchArray = [String]()
    lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.hidesNavigationBarDuringPresentation = false
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.delegate = self
        return controller
    }()
    
    fileprivate var dataSource : UITableViewDiffableDataSource<Section, String>!
    
    var searchBarIsEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    let identifier = "currencyPairCell"
    let numberOfCells = 40
    let cellNibName = "CurrencyPairCell"
    let favoritesKey = "favoritesArray"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupVC()
        setupTableView()
        setupDataSource()
        
        
        
        fetcher.fetchCurrencyPairs { [weak self] pairsArray in
            self?.currencyPairsArray.append(contentsOf: pairsArray)
            DispatchQueue.main.async {
                self?.performSearch(with: "", animatingDifferences: false)
            }
        }
        //tableView.reloadData()
        
        // Do any additional setup after loading the view.
    }
    
    func setupVC() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        navigationItem.title = "Currency pairs"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.pinToSuperView()
        tableView.register(UINib(nibName: "CurrencyPairCell", bundle: nil), forCellReuseIdentifier: CurrencyPairCell.reuseIdentifier)
    }
    
     
    func setupDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, String>(tableView: tableView, cellProvider: { [weak self] (tableView, _, pair) ->  UITableViewCell?  in
            let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyPairCell.reuseIdentifier) as! CurrencyPairCell
            cell.delegate = self
            cell.currencyPairLabel.text = pair.formattedPair()
            cell.currencyPair = pair
            return cell
        })
    }
    
    func performSearch(with filter: String, animatingDifferences: Bool = true) {
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        
        let pairs: [String]
        
        if filter.isEmpty {
            pairs = currencyPairsArray.sorted()
        } else {
            pairs = currencyPairsArray.filter {$0.lowercased().contains(filter.lowercased())}
        }
            snapshot.appendSections([.main])
            snapshot.appendItems(pairs, toSection: .main)
            dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
        
    }
    
}

extension CurrencyListViewController: CurrencyPairCellDelegate {
    func addToFavoritesButtonPressed(currencyPair pair: String) {
        guard var favoritesArray = UserDefaults.standard.array(forKey: favoritesKey) as? [String] else {return}
        if favoritesArray.contains(pair) {
            return
        } else {
            favoritesArray.append(pair)
            UserDefaults.standard.set(favoritesArray, forKey: favoritesKey)
        }
    }
}

extension CurrencyListViewController: UITableViewDelegate {
    
    //    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        return currencyPairsArray.count
    //    }
    //
    //    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! CurrencyPairCell
    //        cell.delegate = self
    //        let pair = currencyPairsArray[indexPath.row].formattedPair()
    //        cell.currencyPairLabel.text = pair
    //        cell.currencyPair = currencyPairsArray[indexPath.row]
    //        return cell
    //    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chartController = ChartViewController()
        chartController.currencyPair = currencyPairsArray[indexPath.row]
        navigationController?.pushViewController(chartController, animated: true)
    }
}

extension CurrencyListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        performSearch(with: searchText)
    }
    
}

extension CurrencyListViewController {
    fileprivate enum Section: Hashable {
        case main
    }
}
