//
//  UIColor+Extension.swift
//  UIColor+Extension
//
//  Created by 안상희 on 2021/08/09.
//

import UIKit

extension UIColor {
    var name: String? {
        switch self {
        case UIColor(named: "lightRed"):
            return "lightRed"
        case UIColor(named: "red"):
            return "red"
        case UIColor(named: "pink"):
            return "pink"
        case UIColor(named: "orange"):
            return "orange"
        case UIColor(named: "yellow"):
            return "yellow"
        case UIColor(named: "lightGreen"):
            return "lightGreen"
        case UIColor(named: "green"):
            return "green"
        case UIColor(named: "skyblue"):
            return "skyblue"
        case UIColor(named: "blue"):
            return "blue"
        case UIColor(named: "lightPurple"):
            return "lightPurple"
        case UIColor(named: "purple"):
            return "purple"
        case UIColor(named: "darkGray"):
            return "darkGray"
        case UIColor.black:
            return "black"
        case UIColor.darkGray:
            return "darkGray"
        case UIColor.lightGray:
            return "lightGray"
        case UIColor.white:
            return "white"
        case UIColor.gray:
            return "gray"
        case UIColor.red:
            return "red"
        case UIColor.green:
            return "green"
        case UIColor.blue:
            return "blue"
        case UIColor.cyan:
            return "cyan"
        case UIColor.yellow:
            return "yellow"
        case UIColor.magenta:
            return "magenta"
        case UIColor.orange:
            return "orange"
        case UIColor.purple:
            return "purple"
        case UIColor.brown:
            return "brown"
        default:
            return nil
        }
    }
}
