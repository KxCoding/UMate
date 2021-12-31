//
//  PlaceImageDataType.swift
//  UMate
//
//  Created by Effie on 2021/09/14.
//

import Foundation


/// 이미지 타입
///
/// Place에서 사용하는 이미지 타입으로, 요청 방식을 결정합니다.
/// - Author: 박혜정(mailmelater11@gmail.com)
enum PlaceImageDataType {
    
    /// 플레이스 홀더
    ///
    /// 이미지 데이터가 없거나 다운로드에 실패했을 때 표시하는 이미지 형식입니다.
    case placeholder
    
    /// blur hash 이미지
    ///
    /// 원본 이미지를 자체 알고리즘으로 인코딩한 고유 문자열을 디코딩해 얻을 수 있는 블러 이미지입니다.  (https://blurha.sh/)
    case blurHash
    
    /// 미리보기 이미지
    case thumbnail
    
    /// 상세 이미지
    ///
    /// 상세 정보 화면에서 표시하는 이미지입니다.
    case detailImage
    
}
