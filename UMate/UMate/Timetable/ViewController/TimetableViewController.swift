//
//  TimetableViewController.swift
//  UMate
//
//  Created by 안상희 on 2021/07/12.
//

import UIKit
import Elliotable

class TimetableViewController: UIViewController {
    
    // 요일 (월, 화, 수, 목, 금) 정보를 담은 배열
    let weekdays = Lecture.shared.dayString
    
    @IBOutlet weak var timeTableView: Elliotable!
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show" {
            let tableViewController : AddLectureTableViewController =
            segue.destination.children.first as! AddLectureTableViewController
            
            tableViewController.delegate = self
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeTableView.delegate = self
        timeTableView.dataSource = self
        
        timeTableView.elliotBackgroundColor = UIColor.white
        timeTableView.borderWidth = 1
        timeTableView.borderColor = UIColor(red: 0.85,
                                            green: 0.85,
                                            blue: 0.85,
                                            alpha: 1.0)
        
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
    func elliotable(elliotable: Elliotable, didSelectCourse selectedCourse: ElliottEvent) {
        
    }
    
    func elliotable(elliotable: Elliotable, didLongSelectCourse longSelectedCourse: ElliottEvent) {
        
    }
}




extension TimetableViewController: ElliotableDataSource {
    func elliotable(elliotable: Elliotable, at dayPerIndex: Int) -> String {
        return weekdays[dayPerIndex]
    }
    
    
    func numberOfDays(in elliotable: Elliotable) -> Int {
        return weekdays.count
    }
    
    
    func courseItems(in elliotable: Elliotable) -> [ElliottEvent] {
        return Lecture.shared.courseList
    }
}




extension TimetableViewController : SendDataDelegate {
    func sendData(data: [ElliottEvent]) {
        
        for i in 0...data.count - 1 {
            Lecture.shared.courseList.append(data[i])
        }
        
        
        timeTableView.reloadData()
    }
}
