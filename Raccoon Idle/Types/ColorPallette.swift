//
//  ColorPallette.swift
//  Raccoon Bakery
//
//  Created by Daniel Moore on 10/21/23.
//

import UIKit

enum ColorPallette: String {
    case Yellow, Blue, Green, Lime, Orange, Pink, Red, Teal, Purple
    
    var name: String {
        rawValue
    }
    
    var color: UIColor {
        return UIColor(named: name) ?? .magenta
    }
}
