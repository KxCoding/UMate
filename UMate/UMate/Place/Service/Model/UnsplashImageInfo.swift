//
//  UnsplashImage.swift
//  UMate
//
//  Created by Effie on 2021/09/09.
//

import Foundation


/// Unsplash 응답 데이터
/// - Author: 박혜정(mailmelater11@gmail.com)
struct UnsplashImagesInfo: Codable {
    
    /// 이미지 타입별 url 정보를 저장하는 객체
    struct Urls: Codable {
        let small: String
        let thumb: String
        //let regular: String
        //let full: String
        //let raw: String
    }
    
    
    /// placeholder 이미지를 위한 blur hash 문자열
    ///
    /// blur hash 알고리즘을 통해 블러 이미지를 만드는 고유 문자열입니다. (https://blurha.sh/)
    let blur_hash: String
    
    /// 이미지 타입별 url 정보를 저장하는 객체
    let urls: Urls
}
