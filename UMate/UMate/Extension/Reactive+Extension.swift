//
//  Reactive+Extension.swift
//  UMate
//
//  Created by Chris Kim on 2021/11/10.
//

import Foundation
import RxSwift
import AudioToolbox


extension Reactive where Base: UITextView {

    /// keyboard의 높이를 Binder<CGFloat> 형식으로 리턴합니다.
    /// - Author: 김정민(kimjm010@icloud.com)
    var keyboardHeight: Binder<CGFloat> {
        return Binder(self.base) { (textView, height) in
            var inset = textView.contentInset
            inset.bottom = height
            textView.contentInset = inset
            
            inset = textView.verticalScrollIndicatorInsets
            inset.bottom = height
            textView.scrollIndicatorInsets = inset
        }
    }
}
