//
//  TestInfoWriteTableViewController.swift
//  UMate
//
//  Created by 남정은 on 2021/09/07.
//

import DropDown
import Loaf
import UIKit


/// 시험정보 작성 화면에서 '공유하기' 버튼을 눌렀을 때 처리되는 동작에 대한 노티피케이션
/// - Author: 남정은(dlsl7080@gmail.com)
extension Notification.Name {
    static let shareTestInfo = Notification.Name("shareTestInfo")
}


/// 시험정보 작성 화면에 대한 클래스
/// - Author: 남정은(dlsl7080@gmail.com)
class TestInfoWriteViewController: CommonViewController {
    /// 시험작성 공유 화면 테이블 뷰
    @IBOutlet weak var testInfoTableView: UITableView!
    
    /// 테이블 뷰의 바텀 제약
    @IBOutlet weak var tableViewbottomConstraint: NSLayoutConstraint!
    
    /// 선택된 강의
    var selectedLecture: LectureInfo?
    
    
    /// 강의정보 화면으로 돌아갑니다.
    /// - Parameter sender: 엑스 버튼
    @IBAction func showDetailLectureVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    /// 뷰 컨트롤러의 뷰 계층이 메모리에 올라간 뒤 호출됩니다.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 키보드 노티피케이션
        var token = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil, using: {noti in
            if let value = noti.userInfo?[
                UIResponder.keyboardFrameEndUserInfoKey] as? NSValue{
                
                let height = value.cgRectValue.height
                self.tableViewbottomConstraint.constant = height
                
                // firstResponder가 UITextField라면 하단스크롤
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
       
        
        // 알림창 노티피케이션
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

        
        // 입력란 추가시 테이블 뷰 리로드
        token = NotificationCenter.default.addObserver(forName: .insertTestInfoInputField, object: nil, queue: .main) { [weak self] noti in
            guard let self = self else { return }
            
            self.testInfoTableView.reloadData()
        }
        tokens.append(token)
        
        
        // 시험정보 공유 버튼 클릭시 화면 dismiss
        token = NotificationCenter.default.addObserver(forName: .shareTestInfo, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
        }
        tokens.append(token)
    }
}



/// 시험정보 작성 화면을 나타냄
/// - Author: 남정은(dlsl7080@gmail.com)
extension TestInfoWriteViewController: UITableViewDataSource {
    /// 시험정보 작성 화면 셀의 개수를 리턴합니다.
    /// - Parameters:
    ///   - tableView: 시험정보 작성 화면 테이블 뷰
    ///   - section: 시험정보 작성 화면을 나누는 section
    /// - Returns: section 안에 포함된 row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    /// 시험정보 작성 화면 셀을 구성합니다.
    /// - Parameters:
    ///   - tableView: 시험정보 작성 화면 테이블 뷰
    ///   - indexPath: 시험정보 작성 화면 셀의 indexPath
    /// - Returns: 시험정보 작성 화면 셀
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TestInfoWriteTableViewCell", for: indexPath) as! TestInfoWriteTableViewCell
        guard let lecture = selectedLecture else {
            return cell
        }
        
        // 개설학기를 담는 배열
        let semesters = lecture.openingSemester.components(separatedBy: "/")
        cell.receiveSemestersAndAddDropDownData(openingSemester: semesters)
        return cell
    }
}



/// 텍스트필드가 firstResponder일 때를 알기 위해 사용
/// - Author: 남정은(dlsl7080@gmail.com)
extension UIView {
    /// 현재 firstResponder를 리턴해 주는 속성
    var firstResponder: UIView? {
        // 현재 UIView가 firstResponder라면 자신을 리턴
        guard !isFirstResponder else { return self }

        // 아니라면 하위뷰들 중에 firstResponder를 찾아서 리턴
        for subview in subviews {
            if let firstResponder = subview.firstResponder {
                return firstResponder
            }
        }
        return nil
    }
}
