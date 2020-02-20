//
//  UIViewExtensions.swift
//  FXTMproject
//
//  Created by Ruslan Sabirov on 18.02.2020.
//  Copyright © 2020 Ruslan Sabirov. All rights reserved.
//

import Foundation

import Foundation
import UIKit

extension UIView {
    
    func pinToSuperView() {
        translatesAutoresizingMaskIntoConstraints = false
        guard let superview = superview else {return}
        topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: superview.leadingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
        trailingAnchor.constraint(equalTo: superview.trailingAnchor).isActive = true
    }
    
    func centerInSuperview(size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let superviewXAnchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: superviewXAnchor).isActive = true
        }
        
        if let superviewYAnchor = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: superviewYAnchor).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
}
