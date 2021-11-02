//
//  Dummy.swift
//  Dummy
//
//  Created by 안상희 on 2021/08/06.
//

import Elliotable
import Foundation
import UIKit


// MARK: Board Dummy

/// 게시판 접힙, 펼침 속성
var expandableArray = [false, false, false, true]



// MARK: - Place Dummy

/// placeholder 이미지
let placeholderImage = UIImage(named: "dummy-image-landscape")

/// dummy URL
let tempUrl = URL(string: "https://kxcoding.com")!



// MARK: - TimeTable Dummy
/// 강의 정보를 담은 Dummy Data 리스트
/// - Author: 안상희
let friendCourseList: [ElliottEvent] =
[ElliottEvent(courseId: "F1234",
              courseName: "자료구조",
              roomName: "팔308",
              professor: "교수님",
              courseDay: .monday,
              startTime: "09:00",
              endTime: "10:15",
              textColor: UIColor.white,
              backgroundColor: .purple),
 ElliottEvent(courseId: "F1234",
              courseName: "자료구조",
              roomName: "팔308",
              professor: "교수님",
              courseDay: .wednesday,
              startTime: "09:00",
              endTime: "10:15",
              textColor: UIColor.white,
              backgroundColor: .purple),
 ElliottEvent(courseId: "F5678",
              courseName: "컴퓨터그래픽스",
              roomName: "팔1025",
              professor: "교수님",
              courseDay: .monday,
              startTime: "10:30",
              endTime: "11:45",
              textColor: UIColor.white,
              backgroundColor: .cyan),
 ElliottEvent(courseId: "F5678",
              courseName: "컴퓨터그래픽스",
              roomName: "팔1025",
              professor: "교수님",
              courseDay: .thursday,
              startTime: "10:30",
              endTime: "11:45",
              textColor: UIColor.white,
              backgroundColor: .cyan)]
