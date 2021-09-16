//
//  FriendLectureViewController.swift
//  FriendLectureViewController
//
//  Created by 안상희 on 2021/07/28.
//

import Elliotable
import UIKit


/// TimeTable 탭에서 친구 시간표를 볼 수 있는 ViewController 클래스
/// - Author: 안상희
class FriendLectureViewController: UIViewController {

    /// 친구 이름이 저장된 속성
    var friendName: String?
    
    /// 요일 (월, 화, 수, 목, 금) 정보를 담은 배열
    let weekdays = Lecture.shared.dayString
    
    /// 강의 정보를 담은 Dummy Data
    let courseList: [ElliottEvent] =
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

    
    
    /// 친구 이름을 나타내는 UILabel
    @IBOutlet weak var friendNameLabel: UILabel!
    
    /// 시간표를 나타내는 View
    @IBOutlet weak var timeTableView: Elliotable!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Delegate 설정
        timeTableView.delegate = self
        timeTableView.dataSource = self
        
        
        // TimeTableView의 기본 속성 설정
        timeTableView.elliotBackgroundColor = UIColor.white
        timeTableView.borderWidth = 1
        timeTableView.borderColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        timeTableView.textEdgeInsets = UIEdgeInsets(top: 2, left: 3, bottom: 2, right: 10)
        timeTableView.courseItemMaxNameLength = 18
        timeTableView.courseItemTextSize = 12.5
        timeTableView.courseTextAlignment = .left
        timeTableView.borderCornerRadius = 24
        timeTableView.roomNameFontSize = 8
        timeTableView.courseItemHeight = 70.0
        timeTableView.symbolFontSize = 14
        timeTableView.symbolTimeFontSize = 12
        timeTableView.symbolFontColor = UIColor(displayP3Red: 0.1,
                                                green: 0.1,
                                                blue: 0.1,
                                                alpha: 1.0)
        timeTableView.symbolTimeFontColor = UIColor(displayP3Red: 0.5,
                                                    green: 0.5,
                                                    blue: 0.5,
                                                    alpha: 1.0)
        timeTableView.isFullBorder = true
        timeTableView.roundCorner = .right
        timeTableView.reloadData()
        
        
        // 친구 이름 표시
        friendNameLabel.text = friendName
    }
}




extension FriendLectureViewController: ElliotableDelegate {
    /// 강의 목록을 터치하면 호출됩니다.
    /// - Parameters:
    ///   - elliotable: Elliotable
    ///   - selectedCourse: ElliottEvent
    func elliotable(elliotable: Elliotable, didSelectCourse selectedCourse: ElliottEvent) {
        
    }
    
    
    /// 강의 목록을 길게 터치하면 호출됩니다.
    /// - Parameters:
    ///   - elliotable: Elliotable
    ///   - longSelectedCourse: ElliottEvent
    func elliotable(elliotable: Elliotable, didLongSelectCourse longSelectedCourse: ElliottEvent) {
        
    }
}




extension FriendLectureViewController: ElliotableDataSource {
    /// 요일 텍스트를 가져옵니다.
    /// - Parameters:
    ///   - elliotable: Elliotable
    ///   - dayPerIndex: 요일의 갯수 (월, 화, 수, 목, 금의 5개)
    /// - Returns: 요일 정보 (월, 화, 수, 목, 금)
    func elliotable(elliotable: Elliotable, at dayPerIndex: Int) -> String {
        return weekdays[dayPerIndex]
    }
    
    
    /// 요일이 몇 개 있는지 가져옵니다.
    /// - Parameter elliotable: Elliotable
    /// - Returns: 요일의 갯수
    func numberOfDays(in elliotable: Elliotable) -> Int {
        return weekdays.count
    }
    
    
    /// 강의 정보를 가져옵니다.
    /// - Parameter elliotable: Elliotable
    /// - Returns: 강의 정보 리스트
    func courseItems(in elliotable: Elliotable) -> [ElliottEvent] {
        return courseList
    }
}
