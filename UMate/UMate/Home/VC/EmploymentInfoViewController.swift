//
//  EmploymentInfoViewController.swift
//  EmploymentInfoViewController
//
//  Created by 황신택 on 2021/09/14.
//

import UIKit

/// 채용정보 뷰를 담당하는 클래스
/// Author: 황신택
class EmploymentInfoViewController: UIViewController {
    /// 테이블뷰 아울렛
    @IBOutlet weak var listTableView: UITableView!
    
    /// Json파싱 데이타
    var jobList = [JobData.Job]()
    
    /// 추가 데이터가 존재할 때만 파싱을 위해 선언한 속성
    var hasMore = true
    
    /// 패치 중복 방지를 위한 속성
    var isFetching = false
    
    
    /// 이전화면
    /// - Parameter sender: UiButton
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    /// Json 데이타를 파싱하고 파싱된 데이타를 jobList에 아이디를 오름차순으로 저장합니다.
    func getJobData() {
        guard let jobData = DataManager.shared.getObject(of: JobData.self, fromJson: "companies") else { return }
        jobList = jobData.jobs.sorted(by: { $0.id < $1.id })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /// 네비게이션 왼쪽 바버튼 다크로드 라이트모드 지원
        navigationItem.leftBarButtonItem?.tintColor = UIColor.dynamicColor(light: .darkGray, dark: .lightGray)
        
        /// 파싱 메소드 호출
        getJobData()
        
        /// 프리패칭 데이타소스 설정
        listTableView.prefetchDataSource = self
        
    }
    
}


extension EmploymentInfoViewController: UITableViewDataSourcePrefetching {
    /// 테이블뷰 셀을 프리패칭합니다.
    /// - Parameters:
    ///   - tableView:  프리패칭 요청을 실행할 테이블뷰
    ///   - indexPaths: 프리패칭할 아이템의 인덱스 를 지정할수있습니다.
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        /// 마지막 셀이 디큐되는 시점보다 -5를 해서 미리 데이타를 프리패칭하게 한다.
        guard indexPaths.contains(where: { $0.row >= self.jobList.count - 5}) else {
            return
        }
        getJobData()
    }
}



extension EmploymentInfoViewController: UITableViewDataSource {
    /// 테이블뷰 섹션의 수
    /// - Parameter tableView: 해당 정보를 요청한 UITableView
    /// - Returns: 섹션의 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    /// 하나의 섹션에 로우의 개수를 지정하는 메소드
    /// - Parameters:
    ///   - tableView: 해당 정보를 요청한 UITableView
    ///   - section: 섹션의 위치
    /// - Returns: 로우의 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        } else  {
            return jobList.count
        }
        
    }
    
    
    /// 셀에 데이타를 지정하는 메소드
    /// - Parameters:
    ///   - tableView: 정보를 요청한 UITableView
    ///   - indexPath: 해당하는 셀에 indexPath
    /// - Returns: 데이타가 들어간 셀
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "search", for: indexPath) as! SearchBarTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyTableViewCell", for: indexPath) as! CompanyTableViewCell
            let model = jobList[indexPath.row]
            cell.configureCompany(with: model)
            return cell
        }
        
    }
    
}



extension EmploymentInfoViewController: UITableViewDelegate {
    
    /// 셀의 높이를 지정합니다
    /// - Parameters: 
    ///   - tableView: 해당 정보를 요청한 UITableView
    ///   - indexPath: 셀의 위치를 지정할 indexPath
    /// - Returns: 셀의 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 50
        } else {
            return 150
        }
    }
   
}
