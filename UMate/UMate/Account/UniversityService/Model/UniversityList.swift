//
//  UniversityListResponse.swift
//  UMate
//
//  Created by Hyunwoo Jang on 2021/11/28.
//

import Foundation


/// 대학교 목록 응답 모델
/// - Author: 장현우(heoun3089@gmail.com)
struct UniversityList: Codable {
    
    /// 대학교 모델
    struct University: Codable {
        
        /// 대학교 아이디
        let universityId: Int
        
        /// 대학교 이름
        let name: String
        
        /// 홈페이지
        let homepage: String?
        
        /// 포탈
        let portal: String?
        
        /// 도서관
        let library: String?
        
        /// 캠퍼스맵
        let map: String?
        
        /// 위도
        let latitude: Double?
        
        /// 경도
        let longitude: Double?
    }
    
    /// 총 대학교 수
    let totalCount: Int
    
    /// 대학교 목록
    let universities: [University]
    
    /// 서버 상태 코드
    let code: Int
    
    /// 서버 메시지
    let message: String?
    
    
    /// 서버 응답 데이터를 파싱합니다.
    /// - Parameters:
    ///   - data: 서버 응답 데이터
    ///   - vc: 이 메소드를 호출하는 뷰컨트롤러
    /// - Returns: 대학교 목록
    static func parse(data: Data, vc: CommonViewController) -> [University] {
        var list = [University]()
        
        do {
            let decoder = JSONDecoder()
            let universityList = try decoder.decode(UniversityList.self, from: data)
            
            if universityList.code == ResultCode.ok.rawValue {
                list = universityList.universities
            }
        } catch {
            vc.alert(message: error.localizedDescription)
        }
        
        return list
    }
}
