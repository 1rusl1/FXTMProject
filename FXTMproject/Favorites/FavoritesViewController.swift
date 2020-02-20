//
//  FavoritesViewController.swift
//  FXTMproject
//
//  Created by Ruslan Sabirov on 18.02.2020.
//  Copyright © 2020 Ruslan Sabirov. All rights reserved.
//

import Starscream
import UIKit

class FavoritesViewController: UIViewController {
    
    lazy var favoritesArray = [String]()
    
    lazy var tableView = UITableView()
    let identifier = "favoritesCell"
    
    let favoritesKey = "favoritesArray"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVC()
        setupTableView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let favorites = UserDefaults.standard.array(forKey: favoritesKey)
        favoritesArray = favorites as! [String]
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
    }
}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        let pair = favoritesArray[indexPath.row].formattedPair()
        cell.textLabel?.text = pair
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chartController = ChartViewController()
        chartController.currencyPair = favoritesArray[indexPath.row]
        navigationController?.pushViewController(chartController, animated: true)
    }
}

