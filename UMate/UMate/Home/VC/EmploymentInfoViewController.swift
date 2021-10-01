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
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    /// Json파싱 데이타
    var jobList = [JobData.Job]()
    
    /// 검색시 나오는 회사 리스트
    var searchedList = [JobData.Job]()
    
    /// 검색 유무에 따른 리스트 결과를 보여주기 위한  속성
    var isSerching = false
    
    
    
    /// 이전화면으로 돌아 갑니다.
    /// - Parameter sender: UiButton
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    /// Json 데이타를 파싱하고 파싱된 데이타를 jobList에 아이디를 오름차순으로 저장합니다.
    func getJobData() {
        DispatchQueue.global().async {
            guard let jobData = DataManager.shared.getObject(of: JobData.self, fromJson: "companies") else { return }
            self.jobList = jobData.jobs.sorted(by: { $0.id < $1.id })
        }
        
    }
    
    
    /// 사용자가 해당텝을 누를시 Url이미지를 뷰에 즉시 보이게 하기 위한 메소드입니다.
    /// - Parameter animated: true라면 해당뷰가 애니메이션이 적용되면서 window에 추가됩니다.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        listTableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 네비게이션 왼쪽 바버튼 다크로드 라이트모드 지원
        navigationItem.leftBarButtonItem?.tintColor = UIColor.dynamicColor(light: .darkGray, dark: .lightGray)
        // 파싱 메소드 호출
        getJobData()
        
        // 프리패칭 데이타소스 설정
        listTableView.prefetchDataSource = self
        
        searchBar.delegate = self
        
        // 서치바의 바운드의 라인을 제거
        searchBar.backgroundImage = UIImage()
        
    }
    
}



extension EmploymentInfoViewController: UISearchBarDelegate {
    /// 등록된 모든 회사 이름 또는 분야의 이름 접두어 개수와 서치바에 입력된 문자열 접두어를 비교합니다.
    /// - Parameters:
    ///   - searchBar: searchBar
    ///   - searchText: searchText
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        DispatchQueue.global().async {
            self.isSerching = true
            self.searchedList = self.jobList.filter({
                $0.title.prefix(searchText.count) == searchText || $0.field.prefix(searchText.count) == searchText
            })
            DispatchQueue.main.async {
                self.listTableView.reloadData()
            }
        }
    
    }
}



extension EmploymentInfoViewController: UITableViewDataSourcePrefetching {
    /// 테이블뷰 셀을 프리패칭합니다.
    /// - Parameters:
    ///   - tableView:  프리패칭 요청을 실행할 테이블뷰
    ///   - indexPaths: 프리패칭할 아이템의 인덱스 를 지정할수있습니다.
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        /// 마지막 셀이 디큐되는 시점보다 -5를 해서 미리 데이타를 프리패칭하게 합니다.
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
        return 1
    }
    
    
    /// 하나의 섹션에 로우의 개수를 지정하는 메소드
    /// - Parameters:
    ///   - tableView: 해당 정보를 요청한 UITableView
    ///   - section: 섹션의 위치
    /// - Returns: 로우의 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     if isSerching {
            return searchedList.count
        } else {
            return jobList.count
        }
        
    }
    
    
    /// 셀에 데이타를 지정하는 메소드
    /// - Parameters:
    ///   - tableView: 정보를 요청한 UITableView
    ///   - indexPath: 해당하는 셀에 indexPath
    /// - Returns: 데이타가 들어간 셀
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyTableViewCell", for: indexPath) as! CompanyTableViewCell
        
        if isSerching {
            let model = searchedList[indexPath.row]
            cell.configureCompany(with: model)
        } else {
            let model = jobList[indexPath.row]
            cell.configureCompany(with: model)
           
        }
        
        return cell
    }
    
}



extension EmploymentInfoViewController: UITableViewDelegate {
    
    /// 셀의 높이를 지정합니다
    /// - Parameters:
    ///   - tableView: 해당 정보를 요청한 UITableView
    ///   - indexPath: 셀의 위치를 지정할 indexPath
    /// - Returns: 셀의 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 150
    }
    
}
