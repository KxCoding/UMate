//
//  LectureModel.swift
//  LectureModel
//
//  Created by 안상희 on 2021/07/28.
//


import Elliotable
import Foundation

class Lecture {
    static let shared = Lecture()

    private init() {
        
    }
    
    var courseList = [ElliottEvent]()
    
    let dayString: [String] = ["월", "화", "수", "목", "금"]
}



struct LectureModel {
    let userId: String
    let timetableInfo: [TimeTableInfo]
    
    struct TimeTableInfo {
        let courseId: String
        let courseName: String
        let roomName: String
        let professor: String
        let courseDays: [CourseDayList]
        struct CourseDayList {
            let courseDayS: String
        }
        
        let startTime: String
        let endTime: String
        let textColor: String
        let backgroundColor: String
    }
    
    
    let friendsList: [Friends]
    
    struct Friends {
        let friendId: String
    }
}
