//
//  CurrencyListViewController.swift
//  FXTMproject
//
//  Created by Ruslan Sabirov on 18.02.2020.
//  Copyright © 2020 Ruslan Sabirov. All rights reserved.
//

import UIKit



class CurrencyListViewController: UIViewController {
    
    //MARK:- Properties
    
    var tableView = UITableView()
    var currencyPairsArray = [String]()
    lazy var fetcher = NetworkDataFetcher()
    
    lazy var searchController = UISearchController()
    
    fileprivate var dataSource : UITableViewDiffableDataSource<Section, String>!
    
    lazy var alertController : UIAlertController = {
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        return controller
    }()
    
    let cellNibName = "CurrencyPairCell"
    
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
        
    }
    
    //MARK:- Setup UI elements
    
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
        tableView.register(UINib(nibName: cellNibName, bundle: nil), forCellReuseIdentifier: CurrencyPairCell.reuseIdentifier)
    }
    
    func setupSearchController() {
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.autocorrectionType = .no
        searchController.searchBar.delegate = self
    }
    
    //MARK: -Setup data source
    
    func setupDataSource() {
        
        dataSource = UITableViewDiffableDataSource<Section, String>(tableView: tableView, cellProvider: { [weak self] (tableView, _, pair) ->  UITableViewCell?  in
            let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyPairCell.reuseIdentifier) as! CurrencyPairCell
            cell.delegate = self
            cell.currencyPairLabel.text = pair.formattedPair()
            cell.currencyPair = pair
            return cell
        })
    }
    
    //MARK: - Search
    
    func performSearch(with filter: String, animatingDifferences: Bool = true) {
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        
        let pairs: [String]
        
        if filter.isEmpty {
            pairs = currencyPairsArray
        } else {
            pairs = currencyPairsArray.filter {$0.lowercased().contains(filter.lowercased())}
        }
        snapshot.appendSections([.main])
        snapshot.appendItems(pairs, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
        
    }
}

//MARK: - CurrencyPairCellDelegate

extension CurrencyListViewController: CurrencyPairCellDelegate {
    
    func addToFavoritesButtonPressed(currencyPair pair: String) {
        guard var favoritesArray = UserDefaults.standard.array(forKey: Global.favoritesKey) as? [String] else {return}
        alertController.title = pair.formattedPair()
        
        if favoritesArray.contains(pair) {
            alertController.message = "Already in favorites!"
            present(alertController, animated: true)
            return
        } else {
            favoritesArray.append(pair)
            UserDefaults.standard.set(favoritesArray, forKey: Global.favoritesKey)
            alertController.message = "Added to favorites!"
            present(alertController, animated: true)
        }
    }
}

//MARK: - UITableViewDelegate

extension CurrencyListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chartController = ChartViewController()
        chartController.currencyPair = currencyPairsArray[indexPath.row]
        navigationController?.pushViewController(chartController, animated: true)
    }
}

//MARK: - UISearchBarDelegate

extension CurrencyListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        performSearch(with: searchText)
    }
    
}

//MARK: - Extensions

extension CurrencyListViewController {
    
    fileprivate enum Section: Hashable {
        case main
    }
}
