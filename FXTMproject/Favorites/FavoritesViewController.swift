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
    
    //MARK: - Properties
    
    lazy var favoritesArray = [String]()
    
    lazy var tableView = UITableView()
    let identifier = "favoritesCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVC()
        setupTableView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let favorites = UserDefaults.standard.array(forKey: Global.favoritesKey)
        favoritesArray = favorites as! [String]
        tableView.reloadData()
    }
    
    //MARK: - Setup UI elements
    
    func setupVC() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        navigationItem.title = "Favorite pairs"
    }
    
    func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.pinToSuperView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        let pair = favoritesArray[indexPath.row].formattedPair()
        cell.textLabel?.text = pair
        cell.textLabel?.font = UIFont.systemFont(ofSize: 22)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chartController = ChartViewController()
        chartController.currencyPair = favoritesArray[indexPath.row]
        navigationController?.pushViewController(chartController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            var array = UserDefaults.standard.array(forKey: Global.favoritesKey)
            array?.remove(at: indexPath.row)
            UserDefaults.standard.set(array, forKey: Global.favoritesKey)
            favoritesArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
        default:
            return
        }
    }
}

