//
//  PlaceList.swift
//  UMate
//
//  Created by Effie on 2021/09/14.
//

import Foundation


/// 특정 대학과 주변 가게 정보 DTO
///
/// 요청시 대학의 id를 전달했을 때 전달된 데이터를 파싱하기 위한 전송용 객체입니다.  시뮬레이션을 위한 임시 타입입니다.
/// - Author: 박혜정(mailmelater11@gmail.com)
struct PlaceList: Codable {
    
    /// 대학 이름
    var university: String
    
    /// 주변 가게들
    var places: [Place]
}
