//
//  BoardCommonTableViewCell.swift
//  UMate
//
//  Created by 남정은 on 2021/11/02.
//

import UIKit


/// 서버 요청 공통 셀 클래스
///  - Author: 남정은(dlsl7080@gmail.com)
class BoardCommonTableViewCell: UITableViewCell {
    /// 데이터 엔코더
    let encoder = JSONEncoder()
    
    /// 날짜 파싱 포매터
    let postDateFormatter: ISO8601DateFormatter = {
       let f = ISO8601DateFormatter()
        f.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
        return f
    }()
    
    /// 서버 요청 API
    lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config, delegate: self, delegateQueue: .main)
        return session
    }()
}



/// local에서 인증서 문제가 발생할 때 사용
///  - Author: 남정은(dlsl7080@gmail.com)
extension BoardCommonTableViewCell: URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let trust = challenge.protectionSpace.serverTrust!
        
        completionHandler(.useCredential, URLCredential(trust: trust))
    }
}
