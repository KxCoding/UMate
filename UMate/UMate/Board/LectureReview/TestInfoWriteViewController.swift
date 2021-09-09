//
//  TestInfoWriteTableViewController.swift
//  UMate
//
//  Created by 남정은 on 2021/09/07.
//

import UIKit
import DropDown


extension Notification.Name {
    static let shareTestInfo = Notification.Name("shareTestInfo")
}


class TestInfoWriteViewController: UIViewController {

    @IBOutlet weak var testInfoTableView: UITableView!
    
    var selectedLecture: LectureInfo?
    
    var tokens = [NSObjectProtocol]()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        /// 알림창 노티피케이션
        NotificationCenter.default.addObserver(forName: .sendAlert, object: nil, queue: .main) { [weak self] noti in
            guard let self = self else { return }
            if let alertKey = noti.userInfo?["alertKey"] as? Int {
                switch alertKey {
                case 0:
                    self.alert(message: "이 과목을 수강하신 학기를 선택해주세요.")
                case 1:
                    self.alert(message: "시험 종류를 선택해주세요")
                case 2:
                    self.alert(message: "시험 전략에 대해 좀 더 성의있는 작성을 부탁드립니다 :)")
                case 3:
                    self.alert(message: "문제 유형을 선택해주세요.")
                case 4:
                    self.alert(message: "문제 예시를 적어주세요.")
                default:
                    break
                }
            }
        }

        /// 입력란 추가시 테이블 뷰 리로드
        var token = NotificationCenter.default.addObserver(forName: .insertTestInfoInputField, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else { return }
                self.testInfoTableView.reloadData()
        }
        tokens.append(token)
        
        /// 시험정보 공유 버튼 클릭시 화면 dismiss
        token = NotificationCenter.default.addObserver(forName: .shareTestInfo, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
        }
        tokens.append(token)
    }
    
    
    deinit {
        for token in tokens {
            NotificationCenter.default.removeObserver(token)
        }
    }
}




extension TestInfoWriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TestInfoWriteTableViewCell", for: indexPath) as! TestInfoWriteTableViewCell
        guard let lecture = selectedLecture else {
            return cell
        }
        
        let semesters = lecture.openingSemester.components(separatedBy: "/")
        cell.receiveSemestersAndAddDropDownData(openingSemester: semesters)
        return cell
    }
}
