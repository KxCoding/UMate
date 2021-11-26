//
//  PlaceDto.swift
//  UMate
//
//  Created by Effie on 2021/11/22.
//

import Foundation


/// 상점 정보 DTO
///
/// 상점 목록을 표시하기 위한 전송용 객체입니다.
/// - Author: 박혜정(mailmelater11@gmail.com)
struct PlaceSimpleDto: Codable {
    let placeId: Int
    let name: String
    
    let district: String
    let latitude: Double
    let longitude: Double
    
    let type: String
    let keywords: String
    let thumbnailImageUrl: String?
}



/// 상점 정보 DTO
///
/// 상점 상세 정보를 표시하기 위한 전송용 객체입니다.
/// - Author: 박혜정(mailmelater11@gmail.com)
struct PlaceDto: Codable {
    let placeId: Int
    let name: String
    
    let district: String
    let latitude: Double
    let longitude: Double
    
    let type: String
    let keywords: String
    
    let tel: String?
    let instagramId: String?
    let websiteUrl: String?
    
    let thumbnailImageUrl: String?
    let placeImageUrl0: String?
    let placeImageUrl1: String?
    let placeImageUrl2: String?
    let placeImageUrl3: String?
    let placeImageUrl4: String?
    let placeImageUrl5: String?
}



/// 대학 정보 DTO
///
/// 대학교 상세 정보를 표시하기 위한 전송용 객체입니다.
/// - Author: 박혜정(mailmelater11@gmail.com)
struct UniversityDto: Codable {
    let universityId: Int
    
    let name: String
    
    let homepage: String
    let portal: String
    let library: String
    let map: String
    
    let latitude: Double?
    let longitude: Double?
}



/// 대학 정보 DTO
///
/// 대학교 위치 정보를 표시하기 위한 전송용 객체입니다.
/// - Author: 박혜정(mailmelater11@gmail.com)
struct UniversityPlaceMainDto: Codable {
    let universityId: Int
    
    let name: String
    
    let latitude: Double?
    let longitude: Double?
}
