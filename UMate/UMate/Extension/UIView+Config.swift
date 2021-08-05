//
//  UIView+Config.swift
//  UMate
//
//  Created by Effie on 2021/08/05.
//

import UIKit

extension UIView {
    enum ViewConfigurationOptions {
        case lightShadow
        case heavyShadow
        case pillShape
        case squircleBig
        case squircleSmall
        case lightBorder
    }
    
    func viewConfig(with options: [ViewConfigurationOptions]) {
        for op in options {
            switch op {
            case .lightShadow:
                self.lightBorder()
            case .heavyShadow:
                self.heavyShadow()
            case .pillShape:
                pillShape()
            case .squircleBig:
                squircleBig()
            case .squircleSmall:
                squircleSmall()
            case .lightBorder:
                lightBorder()
            default:
                break
            }
        }
        
    }
    
    private func pillShape() {
        self.layer.cornerRadius = self.frame.height / 2
        
    }
    
    private func squircleBig() {
        self.layer.cornerRadius = self.frame.height / 6
    }
    
    private func squircleSmall() {
        self.layer.cornerRadius = self.frame.height / 4
    }
    
    private func lightBorder() {
        self.layer.borderColor = UIColor.systemGray4.cgColor
        self.layer.borderWidth = 1
    }
    
    private func lightShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 10
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.layer.masksToBounds = false
    }
    
    private func heavyShadow() {
        
    }
}
