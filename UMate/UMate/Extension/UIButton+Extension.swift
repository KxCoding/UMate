//
//  UIButton+Extension.swift
//  UIButton+Extension
//
//  Created by 안상희 on 2021/08/08.
//

import Foundation
import UIKit


extension UIButton {
    /// 버튼 테마 메소드
    func setButtonTheme() {
        self.backgroundColor = UIColor(named: "black")
        self.tintColor = UIColor.white
        self.frame.size.height = 40
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }
}
