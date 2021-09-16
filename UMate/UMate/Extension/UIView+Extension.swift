//
//  UIView+Extension.swift
//  UIView+Extension
//
//  Created by 안상희 on 2021/08/08.
//

import Foundation
import UIKit


/// 공통 스타일 열거형과 스타일 옵션을 적용하는 메소드를 포함하는 UIView extension
///
/// 적용할 공통 스타일의 열거형 케이스, 스타일을 적용하는 메소드를 추가하고, configureStyle(with:) 메소드 내부에 패턴을 등록합니다.
extension UIView {
    
    /// 뷰에 적용할 스타일 옵션
    ///
    /// 케이스를 추가할 때에는 케이스와 메소드의 순서를 일치시킵니다.
    /// - Author: 박혜정(mailmelater11@gmail.com)
    enum ViewStyleOptions {
        case lightShadow
        case heavyShadow
        case circle
        case pillShape
        case bigRoundedRect
        case smallRoundedRect
        case lightBorder
        case colorBorder(UIColor)
        case removeBorder
        case backroundColor(UIColor)
    }
    
    
    
    /// 미리 설정된 스타일 옵션을 해당 뷰에 추가합니다.
    /// - Parameter options: 스타일 옵션
    /// - Author: 박혜정(mailmelater11@gmail.com)
    func configureStyle(with options: [ViewStyleOptions]) {
        
        // 배열로 전달된 옵션이 루프를 돌며 적용됩니다.
        for op in options {
            switch op {
            case .lightShadow:
                self.applyLightShadow()
                
            case .heavyShadow:
                self.applyHeavyShadow()
                
            case .circle:
                self.applyCircleShape()
                
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
    
    
    /// 뷰에 원 모양을 적용합니다.
    /// - Author: 박혜정(mailmelater11@gmail.com)
    private func applyCircleShape() {
        
    }
    
    
    /// 뷰에 알약 모양을 적용합니다.
    /// - Author: 박혜정(mailmelater11@gmail.com)
    private func applyPillShape() {
        self.layer.cornerRadius = self.frame.height / 2
        
    }
    
    
    /// 상대적으로 큰 직사각형 뷰에 둥근 모서리를 적용합니다.
    /// - Author: 박혜정(mailmelater11@gmail.com)
    private func applyBigRoundedRect() {
        self.layer.cornerRadius = self.frame.height / 6
    }
    
    
    /// 상대적으로 작은 직사각형 뷰에 둥근 모서리를 적용합니다.
    /// - Author: 박혜정(mailmelater11@gmail.com)
    private func applySmallRoundedRect() {
        self.layer.cornerRadius = self.frame.height / 4
    }
    
    
    /// 상대적으로 얇은 테두리를 추가합니다.
    /// - Author: 박혜정(mailmelater11@gmail.com)
    private func applyLightBorder() {
        self.layer.borderColor = UIColor.systemGray4.cgColor
        self.layer.borderWidth = 1
    }
    
    
    /// 상대적으로 중간 두께의 컬러 테두리를 추가합니다.
    /// - Parameter borderColor: 테두리의 색상
    /// - Author: 박혜정(mailmelater11@gmail.com)
    private func applyColorBorder(with borderColor: UIColor) {
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = 2
    }
    
    
    /// 옅은 그림자를 추가합니다.
    /// - Author: 박혜정(mailmelater11@gmail.com)
    private func applyLightShadow() {
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 5
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.masksToBounds = false
    }
    
    
    /// 진한 색의 그림자를 추가합니다.
    /// - Author: 박혜정(mailmelater11@gmail.com)
    private func applyHeavyShadow() {
        
    }
    
    
    /// 적용된 보더를 삭제합니다.
    /// - Author: 박혜정(mailmelater11@gmail.com)
    private func removeBorder() {
        self.layer.borderWidth = 0
    }
    
    
    /// 배경색을 적용합니다.
    /// - Parameter color: 배경에 적용할 색상
    /// - Author: 박혜정(mailmelater11@gmail.com)
    private func fillBackground(with color: UIColor) {
        self.backgroundColor = color
    }
    
    /// View의 모서리 테마 설정 메소드
    /// - Author: ?
    func setViewTheme() {
        self.layer.cornerRadius = 14
        self.layer.borderColor = UIColor.systemGray.cgColor
    }
}
