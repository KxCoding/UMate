//
//  PlaceResponse.swift
//  UMate
//
//  Created by Effie on 2021/11/23.
//

import Foundation


/// Place 전용 응답 코드
/// - Author: 박혜정(mailmelater11@gmail.com)
//enum PlaceResultCode: Int {
//    case ok = 200
//    case fail = -999
//    case notFound = 404
//    
//    case existAlready = 5000
//    case cannotFindData = 6000
//}



/// Place 전용 응답 데이터 타입
/// - Author: 박혜정(mailmelater11@gmail.com)
protocol PlaceResponseType: Codable {
    var code: Int { get set }
    var message: String? { get set }
    var clientAlertMessage: String? { get set }
}



/// Place 전용 공통 응답 데이터
/// - Author: 박혜정(mailmelater11@gmail.com)
struct PlaceCommonResponse: PlaceResponseType {
    var code: Int
    var message: String?
    var clientAlertMessage: String?
}



/// 상점 목록 응답 데이터
/// - Author: 박혜정(mailmelater11@gmail.com)
struct PlaceListResponse: PlaceResponseType {
    var code: Int
    var message: String?
    var clientAlertMessage: String?
        
    let university: UniversityPlaceMainDto?
    let totalCount: Int
    let places: [PlaceSimpleDto]?
}



/// 상점 상제 정보 응답 데이터
/// - Author: 박혜정(mailmelater11@gmail.com)
struct PlaceResponse: PlaceResponseType {
    var code: Int
    var message: String?
    var clientAlertMessage: String?

    let place: PlaceDto?
}



/// 상점 북마크 목록 응답 데이터
/// - Author: 박혜정(mailmelater11@gmail.com)
struct PlaceBookmarkListResponse: PlaceResponseType {
    var code: Int
    var message: String?
    var clientAlertMessage: String?
    
    let userId: String
    let totalCount: Int
    let places: [PlaceSimpleDto]
}



/// 상점 북마크 확인 응답 데이터
/// - Author: 박혜정(mailmelater11@gmail.com)
struct PlaceBookmarkCheckResponse: PlaceResponseType {
    var code: Int
    var message: String?
    var clientAlertMessage: String?
    
    let userId: String
    let placeName: String
    let isBookmarked: Bool
}
