//
//  TestInfoWriteTableViewController.swift
//  UMate
//
//  Created by 남정은 on 2021/08/30.
//

import UIKit

class TestInfoWriteViewController: UIViewController {
    
    @IBOutlet weak var testInfoTableView: UITableView!
    
    var token: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// 입력란 추가시 테이블 뷰 리로드
        token = NotificationCenter.default.addObserver(forName: .insertTestInfoInputField, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            self.testInfoTableView.reloadData()
        }
    }
    
    
    deinit {
        if let token = token {
            NotificationCenter.default.removeObserver(token)
        }
    }
}

extension TestInfoWriteViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        switch indexPath.section {
        /// 타이틀
        case 0:
            return tableView.dequeueReusableCell(withIdentifier: "TestInfoHeaderTableViewCell", for: indexPath) as! TestInfoHeaderTableViewCell
          
        /// 응시한 시험
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ApplicatedTestTableViewCell", for: indexPath) as! ApplicatedTestTableViewCell
            
            return cell
        
        /// 시험 전략
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TestStrategyTableViewCell", for: indexPath) as! TestStrategyTableViewCell
            
            return cell
            
        /// 문제 유형
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TypesOfQuestionsTableViewCell", for: indexPath) as! TypesOfQuestionsTableViewCell
            
            return cell
            
        /// 문제 예시
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExamplesOfQuestionsTableViewCell", for: indexPath) as! ExamplesOfQuestionsTableViewCell
            
            return cell
            
        default:
            return UITableViewCell()
        }
    }
}


