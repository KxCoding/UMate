//
//  UserPlaceInfo.swift
//  UMate
//
//  Created by Effie on 2021/08/23.
//

import CoreLocation
import UIKit


#warning("User 클래스로 통합해야 합니다")
/// Place 사용자 클래스
/// - Author: 박혜정(mailmelater11@gmail.com)
struct PlaceUser {
    
    /// Place 사용자의 데이터 클래스
    /// - Author: 박혜정(mailmelater11@gmail.com)
    struct UserData {
        
        /// 사용자가 북마크한 상점 목록 (ID)
        var bookmarkedPlaces = [Int]()
        
        /// 사용자가 작성한 리뷰 목록
        var reviews = [UUID]()
        
        /// 자주 사용하는 문장 (템플릿)
        var reviewTemplate: [ReviewTemplate] = [ReviewTemplate.temp1,
                                                ReviewTemplate.temp2,
                                                ReviewTemplate.temp3]
    }
    
    /// 사용자의 소속 대학
    var university: University? = nil
    
    /// 사용자 데이터
    var userData = UserData()
    
    #warning("임시 데이터입니다")
    static var tempUser: PlaceUser = {
        var user = PlaceUser()
        
        /// 속성 초기화
        user.university = University.tempUniversity
        
        /// 더미 북마크 데이터
        user.userData.bookmarkedPlaces = [1, 9, 10, 17]
        
        return user
    }()
    
}
