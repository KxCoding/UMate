//
//  PaddingLabelView.swift
//  UMate
//
//  Created by 황신택 on 2021/10/05.
//

import Foundation
import UIKit

/// 레이블의 왼쪽, 오른쪽, 위, 아래 padding 값을 커스터마이징 합니다.
/// 라이브 렌더링을 지원합니다.
/// - Author: 황신택 (sinadsl1457@gmail.com)
@IBDesignable
class PaddingLabel: UILabel {
    /// 레이블의 Inset 속성
    var textEdgeInsets = UIEdgeInsets.zero {
        // 값이 변경될떄마다 레이블의 고유한 contents값을 무효화시킵니다.
        didSet { invalidateIntrinsicContentSize() }
    }
    
    /// 왼쪽 여백을 설정합니다.
    @IBInspectable
    var paddingLeft: CGFloat {
        set { textEdgeInsets.left = newValue }
        get { return textEdgeInsets.left }
    }
    
    /// 오른쪽 여백을 설정합니다.
    @IBInspectable
    var paddingRight: CGFloat {
        set { textEdgeInsets.right = newValue }
        get { return textEdgeInsets.right }
    }
    
    /// 위쪽 여백을 설정합니다.
    @IBInspectable
    var paddingTop: CGFloat {
        set { textEdgeInsets.top = newValue }
        get { return textEdgeInsets.top }
    }
    
    /// 아래쪽 여백을 설정합니다.
    @IBInspectable
    var paddingBottom: CGFloat {
        set { textEdgeInsets.bottom = newValue }
        get { return textEdgeInsets.bottom }
    }
    
    
    /// 이 메소드는 반드시 오버라이드 해야 하며, 레이블의 기본 그리기 동작을 수정하고 싶을 때 호출합니다.
    /// - Parameter rect: 텍스트 출력 영역
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textEdgeInsets))
    }
    
    
    ///  레이블의 bounding rectangle을 커스터마이징 할 때 오바라이딩 합니다.
    /// - Parameters:
    ///   - bounds: 레이블의 사각형 바운드
    ///   - numberOfLines:  최대 줄 수
    /// - Returns: 계산된 레이블의 직사각형
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = bounds.inset(by: textEdgeInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textEdgeInsets.top, left: -textEdgeInsets.left, bottom: -textEdgeInsets.bottom, right: -textEdgeInsets.right)
        
        return textRect.inset(by: invertedInsets)
    }
}
