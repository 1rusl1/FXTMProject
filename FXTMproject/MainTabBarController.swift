//
//  MainTabBarController.swift
//  FXTMproject
//
//  Created by Ruslan Sabirov on 18.02.2020.
//  Copyright © 2020 Ruslan Sabirov. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTabBarChilds()
        // Do any additional setup after loading the view.
    }
    
    private func configureTabBarChilds() {
        
        let currencyListVC = UINavigationController(rootViewController: CurrencyListViewController())
        currencyListVC.tabBarItem = UITabBarItem.init(tabBarSystemItem: .search, tag: 0)
        currencyListVC.tabBarItem.title = "Currency list"
        addChild(currencyListVC)
        
        let favoritesVC = UINavigationController(rootViewController:FavoritesViewController())
        favoritesVC.tabBarItem = UITabBarItem.init(tabBarSystemItem: .favorites, tag: 1)
        currencyListVC.tabBarItem.title = "Favorites"
        addChild(favoritesVC)
        
    }

}
