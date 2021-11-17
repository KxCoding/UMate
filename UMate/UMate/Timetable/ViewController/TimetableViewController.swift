//
//  TimetableViewController.swift
//  UMate
//
//  Created by 안상희 on 2021/07/12.
//

import Elliotable
import UIKit


/// TimteTable 탭의 시간표 화면 ViewController 클래스
///
/// 본인의 시간표를 볼 수 있습니다.
/// - Author: 안상희
class TimetableViewController: CommonViewController {
    /// 요일 (월, 화, 수, 목, 금) 정보를 담은 배열입니다.
    let weekdays = LectureManager.shared.dayString
    
    /// 시간표를 나타내는 View
    @IBOutlet weak var timeTableView: Elliotable!
    
    
    /// 친구 이름을 클릭하면 화면이 넘어가기 전에 호출됩니다.
    /// - Parameters:
    ///   - segue: 뷰컨트롤러에 포함된 segue에 대한 정보를 갖는 객체
    ///   - sender: 시간표 추가 버튼. 버튼을 누르면 강의 정보를 입력할 수 있는 화면으로 이동합니다.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show" {
            let tableViewController : AddLectureTableViewController =
            segue.destination.children.first as! AddLectureTableViewController
    
            tableViewController.timeTableDelegate = self
        }
    }
    
    
    /// ViewController가 메모리에 로드되면 호출됩니다.
    ///
    /// View의 초기화 작업을 진행합니다.
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
        
        
        let token = NotificationCenter.default.addObserver(forName: .DeleteCourseNotification,
                                                           object: nil,
                                                           queue: .main) { [weak self] noti in
            self?.timeTableView.reloadData()
        }
        tokens.append(token)
    }
}



extension TimetableViewController: ElliotableDelegate {
    /// 강의 목록을 터치하면 상세 강의 정보 화면이 나타납니다.
    /// - Parameters:
    ///   - elliotable: Elliotable
    ///   - selectedCourse: ElliottEvent
    func elliotable(elliotable: Elliotable, didSelectCourse selectedCourse: ElliottEvent) {
        let storyboard = UIStoryboard.init(name: "Timetable", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TimetableDimViewSB")
        
        vc.view.backgroundColor = .clear
        
        let courseId = selectedCourse.courseId
        let courseName = selectedCourse.courseName
        let courseDay = selectedCourse.courseDay.rawValue
        let startTime = selectedCourse.startTime
        let endTime = selectedCourse.endTime
        let professor = selectedCourse.professor
        let roomName = selectedCourse.roomName
        
        print("courseDay ", courseDay)
        
        let timetable = TimeTableInfo(courseId: courseId,
                                      courseName: courseName,
                                      courseDay: courseDay,
                                      startTime: startTime,
                                      endTime: endTime,
                                      professor: professor,
                                      roomName: roomName)

        NotificationCenter.default.post(name: .SendCourseNotification,
                                        object: nil,
                                        userInfo: ["Timetable": timetable])
        
        self.view.window?.rootViewController?.addChild(vc)
        self.view.window?.addSubview(vc.view) // 탭바까지 커버
    }
    
    
    /// 강의 목록을 길게 터치하면 호출됩니다.
    /// - Parameters:
    ///   - elliotable: Elliotable
    ///   - longSelectedCourse: ElliottEvent
    func elliotable(elliotable: Elliotable, didLongSelectCourse longSelectedCourse: ElliottEvent) {
        alertVersion2(title: "경고", message: "강의 정보를 삭제하시겠습니까?") { [weak self] _ in
            // 선택한 강의 정보를 삭제합니다.
            for i in 0..<LectureManager.shared.lectureEventList.count {
                if LectureManager.shared.lectureEventList[i].courseId == longSelectedCourse.courseId {
                    LectureManager.shared.lectureEventList.remove(at: i)
                    self?.timeTableView.reloadData()
                    return
                }
            }
        } handler2: { [weak self] _ in
            // 알림창을 dismiss 합니다.
            self?.dismiss(animated: true, completion: nil)
        }
    }
}



extension TimetableViewController: ElliotableDataSource {
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
        return LectureManager.shared.lectureEventList
    }
}



extension TimetableViewController: SendTimeTableDataDelegate {
    /// 시간표 데이터를 전달합니다.
    /// - Parameter data: 시간표 정보를 담은 리스트 [ElliottEvent]
    func sendData(data: [ElliottEvent]) {
        for i in 0...data.count - 1 {
            LectureManager.shared.lectureEventList.append(data[i])
        }
        timeTableView.reloadData()
    }
}
