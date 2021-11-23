//
//  TimetableListResponse.swift
//  UMate
//
//  Created by 안상희 on 2021/11/18.
//

import Foundation

/// 사용자의 시간표 정보 전체를 받아오는 Response 모델
struct TimetableListResponse: Codable {
    let list: [TimetableList]
    struct TimetableList: Codable {
        let timetableId: Int
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
    
    let code: Int
    let message: String?
}
