//
//  PlaceList.swift
//  UMate
//
//  Created by Effie on 2021/09/14.
//

import Foundation


#warning("서버 구현 이후 타입명을 바꾸거나 새로운 타입으로 대체해야 합니다")
/// 대학가 주변 상점 정보 DTO
/// - Author: 박혜정(mailmelater11@gmail.com)
struct PlaceList: Codable {
    
    /// 대학 이름
    var university: String
    
    /// 주변 상점
    var places: [Place]
}
