//
//  NotificationUserInfoKey.swift
//  UMate
//
//  Created by Effie on 2021/11/30.
//

import Foundation


/// 요청한 url의 타입을 전달하기 위한 notification user info key
///
/// 대응되는 value는 URLType 인스턴스입니다.
/// - Author: 박혜정(mailmelater11@gmail.com)
let urlOpenRequestNotificationUrlType = "urlOpenRequestNotificationUrlType"

/// 요청한 url을 전달하기 위한 notification user info key
///
/// 대응되는 value는 URL 인스턴스입니다.
/// - Author: 박혜정(mailmelater11@gmail.com)
let urlOpenRequestNotificationUrl = "urlOpenRequestNotificationUrl"

/// 선택한 하위 탭을 전달하기 위한 notification user info key
///
/// 대응되는 value는 SubTab 인스턴스입니다.
/// - Author: 박혜정(mailmelater11@gmail.com)
let placeInfoTabSelectedNotificationSelectedTab = "placeInfoTabSelectedNotificationSelectedTab"

/// 거리순으로 정렬된 상점 목록을 전달하기 위한 notification user info key
/// - Author: 장현우(heoun3089@gmail.com)
let sortByDistanceButtonSeletedNotificationSortedPlaceList = "sortByDistanceButtonSeletedNotificationSortedPlaceList"

/// 필터링 된 상점 목록을 전달하기 위한 notification user info key
/// - Author: 장현우(heoun3089@gmail.com)
let filterWillAppliedNotificationFilteredPlaceList = "filterWillAppliedNotificationFilteredPlaceList"
