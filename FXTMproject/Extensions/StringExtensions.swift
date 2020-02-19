//
//  StringExtensions.swift
//  FXTMproject
//
//  Created by Ruslan Sabirov on 19.02.2020.
//  Copyright © 2020 Ruslan Sabirov. All rights reserved.
//

import Foundation

extension String {
    
    func formattedPair() -> String {
    var pair = self
    pair.insert("/", at: pair.index(pair.startIndex, offsetBy: 3))
    return pair.uppercased()
    }
    
}
