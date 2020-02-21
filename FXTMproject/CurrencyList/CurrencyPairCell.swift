//
//  CurrencyPairCell1.swift
//  FXTMproject
//
//  Created by Софтиус on 21/02/2020.
//  Copyright © 2020 Ruslan Sabirov. All rights reserved.
//

import UIKit

protocol CurrencyPairCellDelegate: AnyObject {
    func addToFavoritesButtonPressed(currencyPair pair: String)
}

class CurrencyPairCell: UITableViewCell {

    @IBOutlet weak var currencyPairLabel: UILabel!
    weak var delegate: CurrencyPairCellDelegate?
    var currencyPair = String()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func addToFavoritesButtonPressed(_ sender: Any) {
        delegate?.addToFavoritesButtonPressed(currencyPair: currencyPair)
    }
    
}
