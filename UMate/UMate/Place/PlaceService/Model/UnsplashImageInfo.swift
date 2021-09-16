//
//  UnsplashImage.swift
//  UMate
//
//  Created by Effie on 2021/09/09.
//

import Foundation


/// Unsplash 응답 데이터를 파싱하기 위한 타입
/// - Author: 박혜정(mailmelater11@gmail.com)
struct UnsplashImagesInfo: Codable {
    
    /// 이미지가 로드되기 전에 표시할 placeholder 이미지를 위한 blur hash  문자열
    let blur_hash: String
    
    struct Urls: Codable {
        let small: String
        let thumb: String
        //let regular: String
        //let full: String
        //let raw: String
    }
    
    let urls: Urls
}
