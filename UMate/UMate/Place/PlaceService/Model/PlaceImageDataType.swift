//
//  PlaceImageDataType.swift
//  UMate
//
//  Created by Effie on 2021/09/14.
//

import Foundation


/// 이미지 타입
///
/// 이미지는 타입에 따라서 요청 방식이 달라집니다
/// - Author: 박혜정(mailmelater11@gmail.com)
enum PlaceImageDataType {
    /// used on Place
    case placeholder
    case blurHash
    case thumbnail
    case detailImage
}
