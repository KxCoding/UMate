//
//  PlaceList.swift
//  UMate
//
//  Created by Effie on 2021/09/14.
//

import Foundation


/// 특정 대학 주변 상가 정보를 포함하는 전송 객체(DTO) 형식
///
/// 파싱 시뮬레이션을 위한 임시 타입입니다. 학교 주변 상가 데이터를 받기 위해서는 대학교 Id로 요청합니다.
/// - Author: 박혜정(mailmelater11@gmail.com)
struct PlaceList: Codable {
    var university: String
    var places: [Place]
}
