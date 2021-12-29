//
//  TimetableDimViewController.swift
//  UMate
//
//  Created by 안상희 on 2021/10/19.
//

import Elliotable
import Moya
import RxSwift
import UIKit


/// 시간표 상세 정보 화면
/// - Author: 안상희
class TimetableDetailViewController: CommonViewController {
    /// 강의 Id
    var id: String?

    
    /// Dim View
    @IBOutlet weak var dimView: UIView!
    
    /// 시간표 상세 정보 View
    @IBOutlet weak var mainView: UIView!
    
    /// 강의 ID Label
    @IBOutlet weak var courseIdLabel: UILabel!
    
    /// 강의 이름 Label
    @IBOutlet weak var courseNameLabel: UILabel!
    
    /// 교수님 성함 Label
    @IBOutlet weak var professorNameLabel: UILabel!
    
    /// 강의 시간 및 요일 Label
    @IBOutlet weak var courseTimeLabel: UILabel!
    
    /// 강의실 Label
    @IBOutlet weak var courseRoomLabel: UILabel!
    
    /// 강의 삭제 버튼
    @IBOutlet weak var deleteButton: UIButton!
    
    
    /// 등록한 강의를 삭제합니다.
    /// - Parameter sender: 삭제하기 버튼
    @IBAction func deleteLecture(_ sender: UIButton) {
        // 선택한 강의 정보를 삭제합니다.
        alertVersion2(title: "경고", message: "정말 삭제하시겠습니까?") { [weak self] _ in
            for i in 0..<LectureManager.shared.lectureEventList.count {
                guard let courseId = self?.courseIdLabel.text else { return }
                
                if LectureManager.shared.lectureEventList[i].courseId == courseId {
                    LectureManager.shared.lectureEventList.remove(at: i)
                    
                    let timetableId = LectureManager.shared.timetableId[i]
                    
                    self?.deleteTimetable(timetableId: timetableId)
                    
                    LectureManager.shared.timetableId.remove(at: i)
                    
                    NotificationCenter.default.post(name: .DeleteCourseNotification,
                                                                object: nil,
                                                                userInfo: ["CourseId":courseId])
                    self?.view.removeFromSuperview()
                    self?.removeFromParent()
                    return
                }
            }
        } handler2: { [weak self] _ in
            // 알림창을 dismiss 합니다.
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    
    /// 강의 상세 정보 화면을 닫습니다.
    /// - Parameter sender: Dim View
    @objc func handleTapGesture(sender: UITapGestureRecognizer) {
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    
    
    /// 시간표 정보를 삭제합니다.
    /// - Parameter timetableId: Timetable 고유 Id
    private func deleteTimetable(timetableId: Int) {
        TimetableDataManager.shared.provider.rx.request(.deleteTimetable(timetableId))
            .filterSuccessfulStatusCodes()
            .map(TimetableDeleteResponse.self)
            .subscribe(onSuccess: {
                if $0.code == ResultCode.ok.rawValue {
#if DEBUG
                        print($0.message)
#endif
                } else {
#if DEBUG
                        print($0.message)
#endif
                }
            })
    }
    
    
    
    
    /// ViewController가 메모리에 로드되면 호출됩니다.
    ///
    /// View의 초기화 작업을 진행합니다.
    override func viewDidLoad() {
        super.viewDidLoad()

        mainView.layer.cornerRadius = mainView.frame.height / 6
        
        
        deleteButton.setToEnabledButtonTheme()
        
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(handleTapGesture(sender:)))
        
        dimView.addGestureRecognizer(tapGesture)
        
        
        let token = NotificationCenter.default.addObserver(forName: .SendCourseNotification,
                                                           object: nil,
                                                           queue: .main) { [weak self] noti in
            
            guard let timetable = noti.userInfo?["Timetable"] as? TimeTableInfo else {
                return
            }
            
            self?.courseIdLabel.text = timetable.courseId
            self?.courseNameLabel.text = timetable.courseName
            self?.courseRoomLabel.text = timetable.roomName
            self?.professorNameLabel.text = timetable.professor
            
            
            var dayStr = ""
                        
            switch timetable.courseDay {
            case 1:
                dayStr = "월"
            case 2:
                dayStr = "화"
            case 3:
                dayStr = "수"
            case 4:
                dayStr = "목"
            default:
                dayStr = "금"
            }
            self?.courseTimeLabel.text = "\(dayStr) \(timetable.startTime) ~ \(timetable.endTime)"
        }
        tokens.append(token)
    }
}
