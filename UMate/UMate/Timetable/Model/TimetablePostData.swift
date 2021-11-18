//
//  TimetablePostData.swift
//  UMate
//
//  Created by 안상희 on 2021/11/18.
//

import Foundation

/// 시간표 등록 POST 모델
struct TimetablePostData: Codable {
    let courseId: String
    let courseName: String
    let roomName: String
    let professorName: String
    let courseDay: String
    let startTime: String
    let endTime: String
    let backgroundColor: String
    let textColor: String
}
