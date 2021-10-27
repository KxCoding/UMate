//
//  EmploymentInfoViewController.swift
//  EmploymentInfoViewController
//
//  Created by 황신택 on 2021/09/14.
//

import UIKit

/// 채용정보 화면
/// - Author: 황신택 (sinadsl1457@gmail.com)
class EmploymentInfoViewController: CommonViewController {
    /// 채정정보 테이블 뷰
    @IBOutlet weak var listTableView: UITableView!
    
    /// 서치바
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    /// 이전 화면으로 이동합니다.
    /// - Parameter sender: cancelButton
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    /// 화면에 진입하면 채용정보 테이블 뷰를 리로드 하여 바로 보여줄 수 있도록 합니다.
    /// - Parameter animated: true이면 애니메이션을 이용해서 뷰를 윈도우에 추가
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        listTableView.reloadData()
    }
    
    
    /// 초기화 작업을 진행합니다.
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem?.tintColor = UIColor.dynamicColor(light: .darkGray, dark: .lightGray)
        
        // 파싱 메소드 호출 합니다.
        getJobData()
        
        // 서치바의 바운드의 라인을 제거합니다.
        searchBar.backgroundImage = UIImage()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EmploymentInfoViewController.backgroundTap))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    /// 뷰를 탭하면 키보드를 내립니다.
    /// 뷰 전체가 탭 영역입니다.
    /// - Parameter sender: UITapGestureRecognizer생성자의 action
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    @objc func backgroundTap(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}



extension EmploymentInfoViewController: UISearchBarDelegate {
    /// 등록된 모든 회사 이름 또는 분야의 이름 접두어 개수와 서치바에 입력된 문자열 접두어를 비교합니다.
    /// - Parameters:
    ///   - searchBar: 편집중 인 서치바
    ///   - searchText: 서치바에 포함된 텍스트
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        DispatchQueue.global().async {
            self.isSearching = true
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
    /// - Parameters:
    ///   - tableView:  프리패칭을 요청한 테이블뷰
    ///   - indexPaths: 프리패칭 할 아이템의 indexPath 배열
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        /// 마지막 셀이 디큐되는 시점보다 -5를 해서 미리 데이터를 프리패칭하게 합니다.
        guard indexPaths.contains(where: { $0.row >= self.jobList.count - 5}) else {
            return
        }
        
        if !isFetching {
            getJobData()
        }
    }
}



extension EmploymentInfoViewController: UITableViewDataSource {
    ///  섹션에 표시할 셀 수를 리턴합니다.
    /// - Parameters:
    ///   - tableView: 해당 정보를 요청한 테이블뷰
    ///   - section: 섹션 인덱스
    /// - Returns: 섹션에 표시할 셀 수
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return searchedList.count
        } else {
            return jobList.count
        }
    }
    
    
    /// 채용정보 셀을 구성합니다.
    /// 검색 상태에 따라 표시하는 셀이 달라집니다.
    /// - Parameters:
    ///   - tableView: 정보를 요청한 테이블뷰
    ///   - indexPath: 셀의  indexPath
    /// - Returns: 채용정보 셀
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyTableViewCell", for: indexPath) as! EmploymentInfoTableViewCell
        
        if isSearching {
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
    ///   - tableView: 해당 정보를 요청한 테이블뷰
    ///   - indexPath: 셀의 indexPath
    /// - Returns: 셀의 높이
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
