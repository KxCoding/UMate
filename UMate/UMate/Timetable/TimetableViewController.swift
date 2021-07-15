//
//  TimetableViewController.swift
//  UMate
//
//  Created by 안상희 on 2021/07/12.
//

import UIKit
import Elliotable

class TimetableViewController: UIViewController {

    let dayString: [String] = ["월", "화", "수", "목", "금"]
    let courseList: [ElliottEvent] = [ElliottEvent(courseId: "F1234", courseName: "자료구조", roomName: "팔308", professor: "교수님", courseDay: .monday, startTime: "09:00", endTime: "10:15", textColor: UIColor.white, backgroundColor: .purple), ElliottEvent(courseId: "F1234", courseName: "자료구조", roomName: "팔308", professor: "교수님", courseDay: .wednesday, startTime: "09:00", endTime: "10:15", textColor: UIColor.white, backgroundColor: .purple), ElliottEvent(courseId: "F5678", courseName: "컴퓨터그래픽스", roomName: "팔1025", professor: "교수님", courseDay: .monday, startTime: "10:30", endTime: "11:45", textColor: UIColor.white, backgroundColor: .cyan), ElliottEvent(courseId: "F5678", courseName: "컴퓨터그래픽스", roomName: "팔1025", professor: "교수님", courseDay: .thursday, startTime: "10:30", endTime: "11:45", textColor: UIColor.white, backgroundColor: .cyan)]

    @IBOutlet weak var timetableView: Elliotable!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        timetableView.delegate = self
        timetableView.dataSource = self
        
        timetableView.elliotBackgroundColor = UIColor.white
        timetableView.borderWidth = 1
        timetableView.borderColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        
        timetableView.textEdgeInsets = UIEdgeInsets(top: 2, left: 3, bottom: 2, right: 10)
        timetableView.courseItemMaxNameLength = 18
        timetableView.courseItemTextSize = 12.5
        timetableView.courseTextAlignment = .left
        
        timetableView.borderCornerRadius = 24
        timetableView.roomNameFontSize = 8
        
        timetableView.courseItemHeight = 70.0
        timetableView.symbolFontSize = 14
        timetableView.symbolTimeFontSize = 12
        timetableView.symbolFontColor = UIColor(displayP3Red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        timetableView.symbolTimeFontColor = UIColor(displayP3Red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        
        timetableView.reloadData()
    }

}


extension TimetableViewController: ElliotableDelegate {
    func elliotable(elliotable: Elliotable, didSelectCourse selectedCourse: ElliottEvent) {
        
    }
    
    func elliotable(elliotable: Elliotable, didLongSelectCourse longSelectedCourse: ElliottEvent) {
        
    }
    
    
}





extension TimetableViewController: ElliotableDataSource {
    func elliotable(elliotable: Elliotable, at dayPerIndex: Int) -> String {
        return dayString[dayPerIndex]
    }
    
    func numberOfDays(in elliotable: Elliotable) -> Int {
        return dayString.count
    }
    
    func courseItems(in elliotable: Elliotable) -> [ElliottEvent] {
        return courseList
    }
    
    
}
