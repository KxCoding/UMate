//
//  Date + Formatter.swift
//  Date + Formatter
//
//  Created by 남정은 on 2021/07/21.
//

import Foundation


fileprivate let formatter = DateFormatter()

extension Date {
    var relativeDate: String {
        let seconds = Date().timeIntervalSinceReferenceDate - self.timeIntervalSinceReferenceDate
        
        if seconds < 60 {
            return "조금 전"
        } else if seconds < 3600 {
            return "\(Int(seconds / 60))분 전"
        } else if seconds < 3600 * 24 {
            return "\(Int(seconds / 3600))시간"
        } else {
            formatter.dateFormat = "M월 d일"
            
            return formatter.string(from: self)
        }
    }
    
    var string: String {
        
        formatter.dateFormat = "MM/dd hh:mm"
        return formatter.string(from: self)
    }
    
    var commentDate: String {
        formatter.dateFormat = "MM/dd"
        formatter.timeStyle = .short
        
        return formatter.string(from: self)
    }
    
    
    /// 시간을 HH:mm 형식으로 나타내주는 속성입니다.
    var timeTableTime: String {
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
}
