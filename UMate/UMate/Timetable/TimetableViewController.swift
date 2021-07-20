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
    var courseList = [ElliottEvent]()
    
    @IBAction func showFriends(_ sender: Any) {
        
    }
    
    @IBAction func add(_ sender: Any) {
        
    }

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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show" {
            print("show")
            let tableViewController : AddLectureTableViewController = segue.destination as! AddLectureTableViewController
            tableViewController.delegate = self
        }
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


extension TimetableViewController : SendDataDelegate {
    func sendData(data: ElliottEvent) {
        courseList.append(data)
        timetableView.reloadData()
        print(courseList)
    }
}
