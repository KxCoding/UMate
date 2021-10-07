//
//  PlaceList.swift
//  UMate
//
//  Created by Effie on 2021/09/14.
//

import Foundation


<<<<<<< HEAD
#warning("서버 구현 이후 타입명을 바꾸거나 새로운 타입으로 대체해야 합니다")
/// 대학가 주변 상점 정보 DTO
=======
/// 대학가 주변 가게 정보 DTO
///
/// 요청시 대학의 id를 전달했을 때 전달된 데이터를 파싱하기 위한 전송용 객체입니다.  시뮬레이션을 위한 임시 타입입니다.
>>>>>>> phj
/// - Author: 박혜정(mailmelater11@gmail.com)
struct PlaceList: Codable {
    
    /// 대학 이름
    var university: String
    
    /// 주변 상점
    var places: [Place]
}
