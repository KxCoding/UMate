//
//  BoardDataManager.swift
//  UMate
//
//  Created by 남정은 on 2021/11/02.
//

import Foundation
import UIKit


/// 게시판에 사용되는 데이터 관리
/// - Author: 남정은(dlsl7080@gmail.com)
class BoardDataManager {
    
    static let shared = BoardDataManager()
    private init() { }
    
    /// 데이터 엔코더
    let encoder = JSONEncoder()
    
    /// 날짜 파싱 포매터
    let postDateFormatter: ISO8601DateFormatter = {
       let f = ISO8601DateFormatter()
        f.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
        return f
    }()
    
    /// 서버 날짜를 Date로 변환할 때 사용
    let decodingFormatter: DateFormatter = {
       let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        f.calendar = Calendar(identifier: .iso8601)
        f.timeZone = TimeZone(secondsFromGMT: 0)
        f.locale = Locale(identifier: "en_US_POSIX")
        
        return f
    }()
    
    /// 서버 요청 API
    let session = URLSession.shared
    
    
    /// URL을 Data로 변환하여 이미지를 얻습니다.
    /// - Parameter urlString: url주소 문자
    /// - Returns: 이미지
    /// - Author: 남정은(dlsl7080@gmail.com)
    func getImage(urlString: String) -> UIImage? {
        if let url = URL(string: urlString),
           let data = try? Data(contentsOf: url),
           let image = UIImage(data: data) {
            
            return image
        }
        return nil
    }
}


