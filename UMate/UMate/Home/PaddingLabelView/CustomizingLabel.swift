//
//  PaddingLabel.swift
//  UMate
//
//  Created by 황신택 on 2021/09/30.
//

import Foundation
import UIKit

/// UILabel의 left, right, top, bottom padding값을 커스터마이징 해주는 클래스
/// 컴파일타임에 속성이 적용된것을 스토리보드에서 확인하기 위해서 @IBDesignable 선언
/// Author: 황신택
@IBDesignable
class PaddingLabel: UILabel {
    /// 레이블의 Inset을 커스텀화하기 위한 속성
    var textEdgeInsets = UIEdgeInsets.zero {
        // 해당 속성의 값이 변경될떄마다 레이블의 고유한 contents값을 무효화시킵니다.
        didSet { invalidateIntrinsicContentSize() }
    }
    
    /// textEdgeInsets.left 값을 스토리보드에서 변경할수 있습니다.
    /// @IBInspectable은 현재 클래스를 레이블 클래스에 채용함으로써 구현한 계산속성으로 스토리보드에서 속성을 변경할수있습니다.
    @IBInspectable
    var paddingLeft: CGFloat {
        set { textEdgeInsets.left = newValue }
        get { return textEdgeInsets.left }
    }
    
    /// textEdgeInsets.right 값을 스토리보드에서 변경할수 있습니다.
    @IBInspectable
    var paddingRight: CGFloat {
        set { textEdgeInsets.right = newValue }
        get { return textEdgeInsets.right }
    }
    
    /// textEdgeInsets.Top 값을 스토리보드에서 변경할수 있습니다.
    @IBInspectable
    var paddingTop: CGFloat {
        set { textEdgeInsets.top = newValue }
        get { return textEdgeInsets.top }
    }
    
    /// textEdgeInsets.Bottom 값을 스토리보드에서 변경할수 있습니다.
    @IBInspectable
    var paddingBottom: CGFloat {
        set { textEdgeInsets.bottom = newValue }
        get { return textEdgeInsets.bottom }
    }
    
    
    /// 이 메소드는 반드시 오버라이드 해야하며, 레이블의 기본 그리기 동작을 수정하고싶을때 호출합니다.
    /// - Parameter rect: 텍스트를 수정할 rectangle
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textEdgeInsets))
    }
    
    
    ///  레이블의 bounding rectangle의 커스텀화가 필요하다면 오바라이딩 합니다.
    /// - Parameters:
    ///   - bounds: 레이블의 사각형 바운드
    ///   - numberOfLines:  레이블에 사용할 최대 줄 수
    /// - Returns: 계산된 레이블의 직사각형
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = bounds.inset(by: textEdgeInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textEdgeInsets.top, left: -textEdgeInsets.left, bottom: -textEdgeInsets.bottom, right: -textEdgeInsets.right)
        
        return textRect.inset(by: invertedInsets)
    }
  
}
