//
//  PlaceRequest.swift
//  UMate
//
//  Created by Effie on 2021/11/24.
//

import Foundation

/// Place 전용 네트워크 요청 데이터 타입
/// - Author: 박혜정(mailmelater11@gmail.com)
protocol PlaceRequestType: Codable {  }



/// 상점 북마크 등록용 요청 데이터
/// - Author: 박혜정(mailmelater11@gmail.com)
struct PlaceBookmarkPostData: PlaceRequestType {
    let placeId: Int
}
