//
//  TimetableDimViewController.swift
//  UMate
//
//  Created by 안상희 on 2021/10/19.
//

import Elliotable
import UIKit


/// 시간표 상세 정보 화면
/// - Author: 안상희
class TimetableDimViewController: CommonViewController {
    /// 강의 Id
    var id: String?
    
    /// Dim View
    @IBOutlet weak var dimView: UIView!
    
    /// 시간표 상세 정보 View
    @IBOutlet weak var mainView: UIView!
    
    /// 강의 ID Label
    @IBOutlet weak var courseId: UILabel!
    
    /// 강의 이름 Label
    @IBOutlet weak var courseName: UILabel!
    
    /// 교수님 성함 Label
    @IBOutlet weak var professorName: UILabel!
    
    /// 강의 시간 및 요일 Label
    @IBOutlet weak var courseTime: UILabel!
    
    /// 강의실 UILabel
    @IBOutlet weak var courseRoom: UILabel!
    
    /// 강의 정보 수정 버튼
    @IBOutlet weak var modifyButton: UIButton!
    
    /// 강의평 보러 가기 버튼
    @IBOutlet weak var reviewButton: UIButton!
    
    /// 강의 삭제 버튼
    @IBOutlet weak var deleteButton: UIButton!
    
    
    /// 강의 정보를 수정합니다.
    /// - Parameter sender: 수정하기 버튼
    @IBAction func modify(_ sender: UIButton) {
    }
    
    /// 강의평 화면으로 이동합니다.
    /// - Parameter sender: 강의평 보러 가기 버튼
    @IBAction func showReview(_ sender: UIButton) {
    }
    
    
    /// 등록한 강의를 삭제합니다.
    /// - Parameter sender: 삭제하기 버튼
    @IBAction func deleteLecture(_ sender: UIButton) {
        // 선택한 강의 정보를 삭제합니다.
        alertVersion2(title: "경고", message: "정말 삭제하시겠습니까?") { [weak self] _ in
            // 선택한 강의 정보를 삭제합니다.
            for i in 0..<LectureManager.shared.lectureEventList.count {
                guard let courseId = self?.courseId.text else { return }
                if LectureManager.shared.lectureEventList[i].courseId == courseId {
                    LectureManager.shared.lectureEventList.remove(at: i)
                    
                    NotificationCenter.default.post(name: .DeleteCourseNotification,
                                                                object: nil,
                                                                userInfo: ["CourseId":courseId])
                    self?.dismiss(animated: true, completion: nil)
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
        dismiss(animated: true, completion: nil)
    }
    
    
    /// ViewController가 메모리에 로드되면 호출됩니다.
    ///
    /// View의 초기화 작업을 진행합니다.
    override func viewDidLoad() {
        super.viewDidLoad()

        mainView.layer.cornerRadius = mainView.frame.height / 6
        
        [modifyButton, reviewButton, deleteButton].forEach {
            $0?.setToEnabledButtonTheme()
        }
        
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(handleTapGesture(sender:)))
        
        dimView.addGestureRecognizer(tapGesture)
        
        
        var token = NotificationCenter.default.addObserver(forName: .SendCourseNotification,
                                                           object: nil,
                                                           queue: .main) { [weak self] noti in
            guard let id = noti.userInfo?["CourseId"] as? String else {
                print(noti.userInfo?["CourseId"])
                return
            }
            
            guard let name = noti.userInfo?["CourseName"] as? String else {
                return
            }
            
            guard let day = noti.userInfo?["CourseDay"] else {
                return
            }
            
            guard let startTime = noti.userInfo?["StartTime"] as? String else {
                return
            }
            
            guard let endTime = noti.userInfo?["EndTime"] as? String else {
                return
            }
            
            guard let professor = noti.userInfo?["Professor"] as? String else {
                return
            }
            
            guard let roomName = noti.userInfo?["RoomName"] as? String else {
                return
            }
            
            self?.courseId.text = id
            self?.courseName.text = name
            self?.courseRoom.text = roomName
            self?.professorName.text = professor
        }
        tokens.append(token)
    }
}
