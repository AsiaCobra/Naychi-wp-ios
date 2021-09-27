//
//  Color.swift
//  stationery
//
//  Created by Codigo NOL on 20/12/2020.
//

import UIKit

public enum Color: String {

    case Red = "#B80000"
    case RedDark = "#891314"
    case Gray = "#F8F8F8"
    case Black = "#333333"
    case Silver = "#E9E9E9"
    case DarkGray = "#565656"
    case JungleGreen = "#038752"
    case Blue = "#438CD1"

    public func instance() -> UIColor {
        return UIColor.init(hexString: self.rawValue) ?? .clear
    }
}
