//
//  UserPlaceInfo.swift
//  UMate
//
//  Created by Effie on 2021/08/23.
//

import UIKit
import CoreLocation

/// Place
struct PlaceUser {
    
    /// 사용자의 소속 대학
    var university: University? = nil
    
    /// Place 사용자의 데이터 클래스
    struct UserData {
        
        /// 사용자가 북마크한 가게 목록 (ID)
        var bookmarkedPlaces = [Int]()
        
        /// 사용자가 작성한 리뷰 목록
        var reviews = [UUID]()
        
    }
    
    /// Place 사용자의 Place Info
    var userData = UserData()
    
    /// 임시 사용자
    static var tempUser: PlaceUser = {
        var user = PlaceUser()
        
        /// 속성 초기화
        user.university = University.tempUniversity
        
        /// 더미 북마크 데이터
        user.userData.bookmarkedPlaces = [1, 9, 10, 17]
        
        return user
    }()
    
}
