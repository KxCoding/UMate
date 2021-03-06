//
//  NSNotification+Extension.swift
//  NSNotification+Extension
//
//  Created by 안상희 on 2021/09/03.
//

import Foundation

extension NSNotification.Name {
    
    /// 카테고리가 없는 게시글이 추가될 때 Broadcast 하기 위한 Notification속성
    /// - Author: 김정민(kimjm010@icloud.com)
    static let newPostInsert = Notification.Name(rawValue: "newPostInsert")
    
    /// 카테고리가 있는 게시글이 추가될 때 Broadcast하기 위한 Notification속성
    /// - Author: 김정민(kimjm010@icloud.com)
    static let newCategoryPostInsert = Notification.Name(rawValue: "newCategoryPostInsert")
    
    /// 게시글에 추가할 이미지를 선택할 때 Broadcast 하기 위한 Notification속성
    /// - Author: 김정민(kimjm010@icloud.com)
    static let imageDidSelect = Notification.Name(rawValue: "imageDidSelect")
    
    /// 댓글이 추가될 때 Broadcast 하기 위한 Notification속성
    /// - Author: 김정민(kimjm010@icloud.com)
    static let newCommentDidInsert = Notification.Name(rawValue: "newCommentDidInsert")
    
    /// 새로운 강의평가가 등록될 때 Broadcast 하기 위한 Notification속성
    /// - Author: 김정민(kimjm010@icloud.com)
    static let newLectureReviewDidInput = Notification.Name(rawValue: "newLectureReviewDidInput")
    
    /// 카메라를 통해 켭쳐한 이미지를 Broadcast 하기 위한 Notification속성
    /// - Author: 김정민(kimjm010@icloud.com)
    static var imagehasCaptured = Notification.Name(rawValue: "imagehasCaptured")
    
    /// 캡쳐한 이미지를 게시글에 첨부하기 위한 Notification을 Broadcast 하기 위한 속성
    /// - Author: 김정민(kimjm010@icloud.com)
    static let newImageCaptured = Notification.Name(rawValue: "newImageCaptured")
    
    
    /// 강의 ID를 강의 정보 상세 화면으로 보내기 위한 속성
    /// - Author: 안상희
    static let SendCourseNotification = Notification.Name(rawValue: "SendCourse")
    
    
    /// 시간표에서 강의 정보를 삭제하기 위한 속성
    /// - Author: 안상희
    static let DeleteCourseNotification = Notification.Name(rawValue: "DeleteCourse")
}
