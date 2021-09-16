//
//  RoundedView.swift
//  RoundedView
//
//  Created by Hyunwoo Jang on 2021/07/21.
//

import UIKit


@IBDesignable
/// 버튼 외곽선을 깎는 버튼 클래스
/// - Author: 장현우(heoun3089@gmail.com)
class RoundedButton: UIButton {
    /// 버튼을 외곽선이 둥그란 네모난 모양으로 깎습니다.
    /// - Author: 장현우(heoun3089@gmail.com)
    func setup() {
        layer.cornerRadius = frame.height / 4
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    
    override func prepareForInterfaceBuilder() {
        setup()
    }
}

