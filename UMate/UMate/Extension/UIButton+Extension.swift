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
        self.backgroundColor = UIColor.black
        self.tintColor = UIColor.white
        self.layer.cornerRadius = self.layer.frame.height / 2
        self.layer.masksToBounds = true
    }
}
