//
//  LectureInfo.swift
//  LectureInfo
//
//  Created by 남정은 on 2021/08/20.
//

import Foundation


/// 강의 정보 모델 클래스
/// - Author: 남정은(dlsl7080@gmail.com)
class LectureInfo {
    /// 교과목명
    let lectureTitle: String
    
    /// 교수명
    let professor: String
    
    /// 개설학기
    let openingSemester: String
    
    /// 교재명
    let textbookName: String
    
    /// 교재정보로 가는 링크
    let bookLink: String
    
    /// 강의정보에 포함된 리뷰를 담은 배열
    var reviews: [LectureReview]
    
    /// 강의정보에 포함된 시험정보를 담은 배열
    var testInfoList: [TestInfo]
    
    
    init(lectureTitle: String, professor: String, openingSemester: String, textbookName: String, bookLink: String, reviews: [LectureReview] = [], testInfoList: [TestInfo] = []) {
        
        self.lectureTitle = lectureTitle
        self.professor = professor
        self.openingSemester = openingSemester
        self.textbookName = textbookName
        self.bookLink = bookLink
        self.reviews = reviews
        self.testInfoList = testInfoList
    }
}





