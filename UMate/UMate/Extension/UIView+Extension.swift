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
        case pillShape
        case squircleBig
        case squircleSmall
        case lightBorder
    }
    
    
    
    /// 스타일 옵션을 view 스타일을 추가하는 메소드
    /// - Parameter options: 스타일 옵션
    func configureStyle(with options: [ViewStyleOptions]) {
        
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
    
    
    /// 알약 모양
    private func pillShape() {
        self.layer.cornerRadius = self.frame.height / 2
        
    }
    
    
    /// 상대적으로 큰 스퀘어클
    private func squircleBig() {
        self.layer.cornerRadius = self.frame.height / 6
    }
    
    
    /// 상대적으로 작은 스퀘어클
    private func squircleSmall() {
        self.layer.cornerRadius = self.frame.height / 4
    }
    
    
    /// 얇은 보더 추가
    private func lightBorder() {
        self.layer.borderColor = UIColor.systemGray4.cgColor
        self.layer.borderWidth = 1
    }
    
    
    /// 옅은 그림자 추가
    private func lightShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 10
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.layer.masksToBounds = false
    }
    
    /// 진한 그림자 추가
    private func heavyShadow() {
        
    }
    
    /// View의 모서리 테마 설정 메소드
    func setViewTheme() {
        self.layer.cornerRadius = 14
        self.layer.borderColor = UIColor.systemGray.cgColor
    }
}
