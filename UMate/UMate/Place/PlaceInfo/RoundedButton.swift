//
//  RoundedView.swift
//  RoundedView
//
//  Created by Hyunwoo Jang on 2021/07/21.
//

import UIKit

@IBDesignable
class RoundedButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    
    func setup() {
        layer.cornerRadius = frame.height / 2
    }
    
    
    override func prepareForInterfaceBuilder() {
        setup()
    }
    
    
}

