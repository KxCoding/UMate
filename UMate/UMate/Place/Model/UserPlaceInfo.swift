//
//  UserPlaceInfo.swift
//  UMate
//
//  Created by Effie on 2021/08/23.
//

import UIKit

/// Place
struct PlaceUser {
    
    /// Place 사용자의 데이터 클래스
    struct UserData {
        
        /// 사용자가 북마크한 가게 목록 (가게 이름 > id로 식별할 예정)
        var bookmarkedPlaces = [String]()
        
        /// 사용자가 작성한 리뷰 목록
        var reviews = [UUID]()
    }
    
    /// Place 사용자의 Place Info
    var userData = UserData()
    
    /// 임시 사용자
    static var tempUser: PlaceUser = {
        var user = PlaceUser()
        
        /// 더미 북마크 데이터
        user.userData.bookmarkedPlaces = ["데일리루틴", "오오비"]
        
        return user
    }()
    
}
