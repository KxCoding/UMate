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
    
    /// 시간표 고유 Id를 담는 리스트
    var timetableId = [Int]()
    
    /// 시간표에 나타나는 요일 정보
    let dayString: [String] = ["월", "화", "수", "목", "금"]
}



/// 시간표 상세 화면으로 보내는 시간표 정보 구조체
struct TimeTableInfo {
    let courseId: String
    let courseName: String
    let courseDay: Int
    let startTime: String
    let endTime: String
    let professor: String
    let roomName: String
}



/// 사용자 임시 토큰
let userTempToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiNDZjMWY1ZDgtMjEwYy00ODc1LTliYTktZDlmNTFjY2Y0NTYwIiwiaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvd3MvMjAwNS8wNS9pZGVudGl0eS9jbGFpbXMvbmFtZWlkZW50aWZpZXIiOiI0NmMxZjVkOC0yMTBjLTQ4NzUtOWJhOS1kOWY1MWNjZjQ1NjAiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9lbWFpbGFkZHJlc3MiOiJhYWFhQGFhYWEuYWFhYSIsImV4cCI6MTYzNzc1MDMxMSwiaXNzIjoiaHR0cHM6Ly9sb2NhbGhvc3Q6NTU0MTUiLCJhdWQiOiJodHRwczovL2xvY2FsaG9zdDo1NTQxNSJ9.ttof793n0pDhIWldypIuSvNZUHdS9hYiu3we0ZCgJag"
