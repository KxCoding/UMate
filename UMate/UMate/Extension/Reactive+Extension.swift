//
//  Reactive+Extension.swift
//  UMate
//
//  Created by Chris Kim on 2021/11/10.
//

import Foundation
import RxSwift


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



extension Reactive where Base: UITableView {

    /// keyboard의 높이를 Binder<CGFloat> 형식으로 리턴합니다.
    /// - Author: 김정민(kimjm010@icloud.com)
    var keyboardHeight: Binder<CGFloat> {
        return Binder(self.base) { (tableView, height) in
            var inset = tableView.contentInset
            inset.bottom = height
            tableView.contentInset = inset
            
            inset = tableView.verticalScrollIndicatorInsets
            inset.bottom = height
            tableView.verticalScrollIndicatorInsets = inset
        }
    }
}
