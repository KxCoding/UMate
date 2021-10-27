//
//  Date + Formatter.swift
//  Date + Formatter
//
//  Created by 남정은 on 2021/07/21.
//

import Foundation


fileprivate let formatter = DateFormatter()

extension Date {
    /// 현재 시간과 비교하여 시간을 나타내는 속성
    /// - Author: 남정은
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
    
    /// 게시글 상세화면에 나타낼 데이트 형식
    /// - Author: 남정은
    var detailPostDate: String {
        formatter.dateFormat = "MM/dd hh:mm"
        return formatter.string(from: self)
    }
    
    /// 댓글, 대댓글에 표시할 데이트 형식
    /// - Author: 김정민(kimjm010@icloud.com)
    var commentDate: String {
            formatter.dateFormat = "yy.MM.dd \t HH:mm"
            
            return formatter.string(from: self)
        }
    
    /// 가게 정보 페이지의 리뷰탭에서 사용하는 날짜 형식입니다.
    /// - Author: 장현우(heoun3089@gmail.com)
    var reviewDate: String {
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: self)
    }
    
    /// 시간을 HH:mm 형식으로 나타내주는 속성입니다.
    var timeTableTime: String {
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
    
    var minimumOfYear: String? {
        let calendar = Calendar.current
        let compo = calendar.dateComponents([.year], from: self)
        var componet = DateComponents()
        if let maxYear = compo.year {
            componet.year = maxYear - 14
        }
        
        guard let date = calendar.date(from: componet) else { return nil }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter.string(from: date)
        
    }
    
    var maxOfYear: String? {
        let calendar = Calendar.current
        let compo = calendar.dateComponents([.year], from: self)
        var componet = DateComponents()
        if let maxYear = compo.year {
            componet.year = maxYear
        }
        
        guard let date = calendar.date(from: componet) else { return nil }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter.string(from: date)
        
    }
}
