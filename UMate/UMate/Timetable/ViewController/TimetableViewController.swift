//
//  TimetableViewController.swift
//  UMate
//
//  Created by 안상희 on 2021/07/12.
//

import Elliotable
import UIKit


/// 본인의 시간표를 볼 수 있는 ViewController 클래스
/// - Author: 안상희
class TimetableViewController: UIViewController {
    
    /// 요일 (월, 화, 수, 목, 금) 정보를 담은 배열입니다.
    let weekdays = Lecture.shared.dayString
    
    /// 시간표를 나타내는 View
    @IBOutlet weak var timeTableView: Elliotable!
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show" {
            let tableViewController : AddLectureTableViewController =
            segue.destination.children.first as! AddLectureTableViewController
            
            tableViewController.timeTableDelegate = self
        }
    }
    
    
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
    }
}




extension TimetableViewController: ElliotableDelegate {
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
        return Lecture.shared.courseList
    }
}




extension TimetableViewController: SendTimeTableDataDelegate {
    /// 시간표 데이터를 전달합니다.
    /// - Parameter data: 시간표 정보를 담은 리스트 [ElliottEvent]
    func sendData(data: [ElliottEvent]) {
        
        for i in 0...data.count - 1 {
            Lecture.shared.courseList.append(data[i])
        }
        
        timeTableView.reloadData()
    }
}
