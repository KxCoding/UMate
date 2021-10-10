//
//  LectureModel.swift
//  LectureModel
//
//  Created by 안상희 on 2021/07/28.
//

import Elliotable
import Foundation


/// Timetable 탭의 시간표 화면에서 서버에서 사용자의 시간표 정보 리스트를 가져와서 ElliottEvent 객체로 변환합니다.
/// - Author: 안상희
class LectureManager { // 서버에서이벤트받아와서 그걸 elliotevent 객체로 바꾸고, 배열에 저장. manager
    static let shared = LectureManager()
    
    private init() { }
    
    /// 시간표를 담을 리스트
    var lectureEventList = [ElliottEvent]()
    
    /// 시간표에 나타나는 요일 정보
    let dayString: [String] = ["월", "화", "수", "목", "금"]
}



/// 사용자의  모든 시간표 정보를 가지고 있습니다.
/// - Author: 안상희
struct UserTimeTable {
    /// 사용자의 고유 아이디
    let userId: String
    
    /// 시간표 정보를 담은 리스트
    let timetableInfo: [TimeTableInfo]
    
    
    /// 시간표 정보를 담은 구조체
    struct TimeTableInfo {
        /// 과목 Id
        let courseId: String
        
        /// 과목 이름
        let courseName: String
        
        /// 강의실 정보
        let roomName: String
        
        /// 교수님 정보
        let professor: String
        
        /// 요일 정보를 담은 리스트
        let courseDays: [CourseDayList]
        
        
        /// 요일 정보 구조체
        struct CourseDayList {
            let courseDayS: String
        }
        
        
        /// 강의 시작 시간
        let startTime: String
        
        /// 강의 마침 시간
        let endTime: String
        
        /// 시간표에 등록할 글자 색상
        let textColor: String
        
        /// 시간표에 등록할 배경 색상
        let backgroundColor: String
    }
    
    /// 친구 목록을 담은 리스트
    let friendsList: [Friends]
    
    
    /// 친구 Id를 담은 구조체
    struct Friends {
        /// 친구 Id
        let friendId: String
    }
}