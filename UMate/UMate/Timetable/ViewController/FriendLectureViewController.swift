//
//  FriendLectureViewController.swift
//  FriendLectureViewController
//
//  Created by 안상희 on 2021/07/28.
//

import UIKit
import Elliotable

class FriendLectureViewController: UIViewController {

    // 친구 이름이 저장된 속성
    var name: String?
    
    // 요일 (월, 화, 수, 목, 금) 정보를 담은 배열
    let weekdays = Lecture.shared.dayString
    
    let courseList: [ElliottEvent] = [ElliottEvent(courseId: "F1234", courseName: "자료구조", roomName: "팔308", professor: "교수님", courseDay: .monday, startTime: "09:00", endTime: "10:15", textColor: UIColor.white, backgroundColor: .purple), ElliottEvent(courseId: "F1234", courseName: "자료구조", roomName: "팔308", professor: "교수님", courseDay: .wednesday, startTime: "09:00", endTime: "10:15", textColor: UIColor.white, backgroundColor: .purple), ElliottEvent(courseId: "F5678", courseName: "컴퓨터그래픽스", roomName: "팔1025", professor: "교수님", courseDay: .monday, startTime: "10:30", endTime: "11:45", textColor: UIColor.white, backgroundColor: .cyan), ElliottEvent(courseId: "F5678", courseName: "컴퓨터그래픽스", roomName: "팔1025", professor: "교수님", courseDay: .thursday, startTime: "10:30", endTime: "11:45", textColor: UIColor.white, backgroundColor: .cyan)]

    
    @IBOutlet weak var friendNameLabel: UILabel!
    @IBOutlet weak var timeTableView: Elliotable!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        timeTableView.delegate = self
        timeTableView.dataSource = self
        
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
        timeTableView.symbolFontColor = UIColor(displayP3Red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        timeTableView.symbolTimeFontColor = UIColor(displayP3Red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        
        timeTableView.isFullBorder = true
        timeTableView.roundCorner = .right
        
        timeTableView.reloadData()
        
        friendNameLabel.text = name
    }
}




extension FriendLectureViewController: ElliotableDelegate {
    func elliotable(elliotable: Elliotable, didSelectCourse selectedCourse: ElliottEvent) {
        
    }
    
    
    func elliotable(elliotable: Elliotable, didLongSelectCourse longSelectedCourse: ElliottEvent) {
        
    }
}




extension FriendLectureViewController: ElliotableDataSource {
    func elliotable(elliotable: Elliotable, at dayPerIndex: Int) -> String {
        return weekdays[dayPerIndex]
    }
    
    
    func numberOfDays(in elliotable: Elliotable) -> Int {
        return weekdays.count
    }
    
    
    func courseItems(in elliotable: Elliotable) -> [ElliottEvent] {
        return courseList
    }
}
