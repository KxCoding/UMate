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
