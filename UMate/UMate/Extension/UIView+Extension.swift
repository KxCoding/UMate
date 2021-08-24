//
//  UIView+Extension.swift
//  UIView+Extension
//
//  Created by 안상희 on 2021/08/08.
//

import Foundation
import UIKit

extension UIView {
    
    enum ViewStyleOptions {
        case lightShadow
        case heavyShadow
        case circle
        case pillShape
        case squircleBig
        case squircleSmall
        case lightBorder
        case colorBorder(UIColor)
        case removeBorder
        case backroundColor(UIColor)
    }
    
    
    
    /// 스타일 옵션을 view 스타일을 추가하는 메소드
    /// - Parameter options: 스타일 옵션
    func configureStyle(with options: [ViewStyleOptions]) {
        
        for op in options {
            switch op {
            case .lightShadow:
                self.lightShadow()
                
            case .heavyShadow:
                self.heavyShadow()
                
            case .circle:
                self.circle()
                
            case .pillShape:
                pillShape()
                
            case .squircleBig:
                bigRoundedRect()
                
            case .squircleSmall:
                smallRoundedRect()
                
            case .lightBorder:
                lightBorder()
                
            case .colorBorder(let color):
                colorBorder(with: color)
                
            case .removeBorder:
                removeBorder()
                
            case .backroundColor(let color):
                fillBackground(with: color)
            }
        }
        
    }
    
    
    /// 원 모양
    private func circle() {
        
    }
    
    /// 알약 모양
    private func pillShape() {
        self.layer.cornerRadius = self.frame.height / 2
        
    }
    
    
    /// 상대적으로 큰 스퀘어클
    private func bigRoundedRect() {
        self.layer.cornerRadius = self.frame.height / 6
    }
    
    
    /// 상대적으로 작은 스퀘어클
    private func smallRoundedRect() {
        self.layer.cornerRadius = self.frame.height / 4
    }
    
    
    /// 얇은 보더 추가
    private func lightBorder() {
        self.layer.borderColor = UIColor.systemGray4.cgColor
        self.layer.borderWidth = 1
    }
    
    
    /// 적당한 두께의 컬러 보더 추가
    private func colorBorder(with borderColor: UIColor) {
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = 2
    }
    
    
    /// 옅은 그림자 추가
    private func lightShadow() {
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 5
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.masksToBounds = false
    }
    
    /// 진한 그림자 추가
    private func heavyShadow() {
        
    }
    
    /// 보더 삭제
    private func removeBorder() {
        self.layer.borderWidth = 0
    }
    
    /// 배경색 설정
    private func fillBackground(with color: UIColor) {
        self.backgroundColor = color
    }
    
    /// View의 모서리 테마 설정 메소드
    func setViewTheme() {
        self.layer.cornerRadius = 14
        self.layer.borderColor = UIColor.systemGray.cgColor
    }
}
