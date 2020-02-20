//
//  CurrencyPairCell.swift
//  FXTMproject
//
//  Created by Ruslan Sabirov on 20.02.2020.
//  Copyright © 2020 Ruslan Sabirov. All rights reserved.
//

import UIKit

protocol CurrencyPairCellDelegate: AnyObject {
    func addToFavoritesButtonPressed(currencyPair pair: String)
}

class CurrencyPairCell: UITableViewCell {

    @IBOutlet weak var currencyPairLabel: UILabel!
    lazy var currencyPair = String()
    weak var delegate: CurrencyPairCellDelegate?
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func addToFavoritesButtonPressed(_ sender: UIButton) {
        delegate?.addToFavoritesButtonPressed(currencyPair: currencyPair)
    }
    
}
