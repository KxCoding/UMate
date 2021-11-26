//
//  String+Formatter.swift
//  UMate
//
//  Created by Hyunwoo Jang on 2021/11/24.
//

import Foundation


fileprivate let formatter = DateFormatter()



extension String {
    
    /// 서버에서 내려오는 문자열 형식의 날짜를 Date 형식으로 변환합니다.
    /// - Author: 장현우(heoun3089@gmail.com)
    var reviewDBDate: Date? {
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        formatter.timeZone = TimeZone(identifier: "UTC")
        if let date = formatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
}
