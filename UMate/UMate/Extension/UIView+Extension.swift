//
//  UIView+Extension.swift
//  UIView+Extension
//
//  Created by 안상희 on 2021/08/08.
//

import Foundation
import UIKit


extension UIView {
    
    /// 뷰에 적용할 스타일 옵션
    /// - Author: 박혜정(mailmelater11@gmail.com)
    enum ViewStyleOptions {
        case lightShadow
        case heavyShadow
        case pillShape
        case bigRoundedRect
        case smallRoundedRect
        case lightBorder
        case colorBorder(UIColor)
        case removeBorder
        case backroundColor(UIColor)
    }
    
    
    
    /// 대상 뷰에 스타일 옵션을 적용합니다.
    ///
    /// 배열에 저장된 순서대로 적용됩니다.
    /// - Parameter options: 스타일 옵션 배열
    /// - Author: 박혜정(mailmelater11@gmail.com)
    func configureStyle(with options: [ViewStyleOptions]) {
        
        for option in options {
            switch option {
            case .lightShadow:
                self.applyLightShadow()
                
            case .heavyShadow:
                self.applyHeavyShadow()
                
            case .pillShape:
                applyPillShape()
                
            case .bigRoundedRect:
                applyBigRoundedRect()
                
            case .smallRoundedRect:
                applySmallRoundedRect()
                
            case .lightBorder:
                applyLightBorder()
                
            case .colorBorder(let color):
                applyColorBorder(with: color)
                
            case .removeBorder:
                removeBorder()
                
            case .backroundColor(let color):
                fillBackground(with: color)
            }
        }
        
    }
    
    
    /// 뷰에 알약 모양을 적용합니다.
    /// - Author: 박혜정(mailmelater11@gmail.com)
    func applyPillShape() {
        self.layer.cornerRadius = self.frame.height / 2
    }
    
    
    /// 상대적으로 큰 직사각형 뷰에 둥근 모서리를 적용합니다.
    /// - Author: 박혜정(mailmelater11@gmail.com)
    func applyBigRoundedRect() {
        self.layer.cornerRadius = self.frame.height / 6
    }
    
    
    /// 상대적으로 작은 직사각형 뷰에 둥근 모서리를 적용합니다.
    /// - Author: 박혜정(mailmelater11@gmail.com)
    func applySmallRoundedRect() {
        self.layer.cornerRadius = self.frame.height / 4
    }
    
    
    /// 상대적으로 얇은 테두리를 추가합니다.
    /// - Author: 박혜정(mailmelater11@gmail.com)
    func applyLightBorder() {
        self.layer.borderColor = UIColor.systemGray4.cgColor
        self.layer.borderWidth = 1
    }
    
    
    /// 상대적으로 중간 두께의 컬러 테두리를 추가합니다.
    /// - Parameter borderColor: 테두리의 색상
    /// - Author: 박혜정(mailmelater11@gmail.com)
    func applyColorBorder(with borderColor: UIColor) {
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = 2
    }
    
    
    /// 옅은 그림자를 추가합니다.
    /// - Author: 박혜정(mailmelater11@gmail.com)
    func applyLightShadow() {
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 5
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.masksToBounds = false
    }
    
    
    /// 진한 색의 그림자를 추가합니다.
    /// - Author: 박혜정(mailmelater11@gmail.com)
    func applyHeavyShadow() {
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 0.6
        self.layer.shadowRadius = 5
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.masksToBounds = false
    }
    
    
    /// 적용된 보더를 삭제합니다.
    /// - Author: 박혜정(mailmelater11@gmail.com)
    func removeBorder() {
        self.layer.borderWidth = 0
    }
    
    
    /// 배경색을 적용합니다.
    /// - Parameter color: 배경에 적용할 색상
    /// - Author: 박혜정(mailmelater11@gmail.com)
    func fillBackground(with color: UIColor) {
        self.backgroundColor = color
    }
    
    
    /// View의 모서리 테마 설정 메소드
    func setViewTheme() {
        self.layer.cornerRadius = 14
        self.layer.borderColor = UIColor.systemGray.cgColor
    }
}
