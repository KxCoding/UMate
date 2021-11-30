//
//  CommonResponseType.swift
//  UMate
//
//  Created by Hyunwoo Jang on 2021/11/30.
//

import Foundation


/// 기본 서버 응답 타입
/// - Author: 장현우(heoun3089@gmail.com)
protocol CommonResponseType {
    
    /// 응답 코드
    var code: Int { get }
    
    /// 서버 메시지
    var message: String? { get }
}
