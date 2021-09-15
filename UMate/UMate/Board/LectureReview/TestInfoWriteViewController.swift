//
//  TestInfoWriteTableViewController.swift
//  UMate
//
//  Created by 남정은 on 2021/09/07.
//

import DropDown
import Loaf
import UIKit


/// 시험정보작성 화면에서 공유하기 버튼을 눌렀을 때 처리되는 동작에대한 노티피케이션
/// - Author: 남정은
extension Notification.Name {
    static let shareTestInfo = Notification.Name("shareTestInfo")
}


/// 시험작성 공유화면에대한 클래스
/// - Author: 남정은
class TestInfoWriteViewController: RemoveObserverViewController {
    /// 시험작성 공유에대한 테이블 뷰
    @IBOutlet weak var testInfoTableView: UITableView!
    
    /// 테이블 뷰의 바텀 제약
    @IBOutlet weak var tableViewbottomConstraint: NSLayoutConstraint!
    
    /// 선택된 강의
    var selectedLecture: LectureInfo?
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// 키보드 노티피케이션
        var token = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil, using: {noti in
            if let value = noti.userInfo?[
                UIResponder.keyboardFrameEndUserInfoKey] as? NSValue{
                
                let height = value.cgRectValue.height
                self.tableViewbottomConstraint.constant = height
                
                /// firstResponder가 UITextField라면 하단스크롤
                if let _ = self.view.window?.firstResponder as? UITextField {
                    DispatchQueue.main.async {
                        self.testInfoTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .bottom, animated: true)
                    }
                }
                
            }
        })
        tokens.append(token)
        
        token = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil, using: { noti in
            self.tableViewbottomConstraint.constant = 0
        })
        tokens.append(token)
       
        
        /// 알림창 노티피케이션
        token = NotificationCenter.default.addObserver(forName: .sendAlert, object: nil, queue: .main) { [weak self] noti in
            guard let self = self else { return }
            
            if let alertKey = noti.userInfo?["alertKey"] as? Int {
                switch alertKey {
                case 0:
                    Loaf("이 과목을 수강하신 학기를 선택해주세요.", state: .custom(.init(backgroundColor: .black)), sender: self).show()
                case 1:
                    Loaf("시험 종류를 선택해주세요.", state: .custom(.init(backgroundColor: .black)), sender: self).show()
                case 2:
                    Loaf("시험 전략에 대해 좀 더 성의있는 작성을 부탁드립니다 :)", state: .custom(.init(backgroundColor: .black)), sender: self).show()
                case 3:
                    Loaf("문제 유형을 선택해주세요.", state: .custom(.init(backgroundColor: .black)), sender: self).show()
                case 4:
                    Loaf("문제 예시를 적어주세요.", state: .custom(.init(backgroundColor: .black)), sender: self).show()
                default:
                    break
                }
            }
        }
        tokens.append(token)

        
        /// 입력란 추가시 테이블 뷰 리로드
        token = NotificationCenter.default.addObserver(forName: .insertTestInfoInputField, object: nil, queue: .main) { [weak self] noti in
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
}



/// 시험작성 공유 테이블 뷰에대한 데이터소스
/// - Author: 남정은
extension TestInfoWriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    /// 시험정보공유화면 셀 설정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TestInfoWriteTableViewCell", for: indexPath) as! TestInfoWriteTableViewCell
        guard let lecture = selectedLecture else {
            return cell
        }
        
        /// 개설학기를 담는 배열
        let semesters = lecture.openingSemester.components(separatedBy: "/")
        cell.receiveSemestersAndAddDropDownData(openingSemester: semesters)
        return cell
    }
}


/// 텍스트필드가 firstReponder일 때를 알기위해 사용
/// - Author: 남정은
extension UIView {
    /// 현재 firstResponder를 리턴해주는 속성
    var firstResponder: UIView? {
        /// 현재 uiview가 firstResponder라면 자신을 리턴
        guard !isFirstResponder else { return self }

        /// 아니라면 하위뷰들 중에 firstResponder를 찾아서 리턴
        for subview in subviews {
            if let firstResponder = subview.firstResponder {
                return firstResponder
            }
        }

        return nil
    }
}
