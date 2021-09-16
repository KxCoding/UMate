//
//  PlaceImageDataType.swift
//  UMate
//
//  Created by Effie on 2021/09/14.
//

import Foundation


/// 요청 URL을 필요한 이미지 유형에 따라 다르게 설정하기 위한 타입
/// - Author: 박혜정(mailmelater11@gmail.com)
enum PlaceImageDataType {
    /// used on Place
    case placeholder
    case blurHash
    case thumbnail
    case detailImage
}
