//
//  ContestViewController.swift
//  ContestViewController
//
//  Created by 황신택 on 2021/09/14.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

/// 대외활동 / 공모전 화면
/// - Author: 황신택 (sinadsl1457@gmail.com)
class ContestsViewController: CommonViewController {
    /// 대외활동 테이블 뷰
    @IBOutlet weak var listTableView: UITableView!
    
    /// 대외활동 서치바
    @IBOutlet weak var contestSearchBar: UISearchBar!
    
    /// 이전 화면으로 이동합니다.
    /// - Parameter sender: cancelButton
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
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
        getContestData()
        
        overrideUserInterfaceStyle = .light
        
        // 다크모드 라이트모드 상관없이 항상 타이틀 색상을 darkGray로 지정합니다.
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.dynamicColor(light: .darkGray, dark: .darkGray)]
        
        // 대외활동 서치바의 바운드의 라인을 제거합니다.
        contestSearchBar.backgroundImage = UIImage()
        
        let headerNib = UINib(nibName: "Header", bundle: nil)
        listTableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "header")
        
        didTapMakeLowerKeyboard()
    }
    
}



extension ContestsViewController: UITableViewDataSource {
    ///  섹션에 표시할 셀 수를 리턴합니다.
    /// - Parameters:
    ///   - tableView: 해당 정보를 요청한 테이블뷰
    ///   - section: 섹션 인덱스
    /// - Returns: 섹션에 표시할 셀 수
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return searchedContestDataList.count
        } else {
            return contestDetailDataList.count
        }
    }


    /// 인기 대외활동과 대외활동 데이터가 담긴 셀을 구성합니다.
    /// - Parameters:
    ///   - tableView: 정보를 요청한 테이블뷰
    ///   - indexPath: 셀의 indexPath
    /// - Returns: 대외활동 셀
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PopularContestsTableViewCell", for: indexPath) as! PopularContestsTableViewCell
            cell.configure(with: contestDataList)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContestsTableViewCell", for: indexPath) as! ContestsTableViewCell

            if isSearching {
                let model = searchedContestDataList[indexPath.row]
                cell.configure(with: model)
            } else {
                let model = contestDetailDataList[indexPath.row]
                cell.configure(with: model)
            }
            return cell
        }
    }


    /// 인기 대외활동 헤더뷰를 리턴합니다
    /// - Parameters:
    ///   - tableView: 뷰를 요청한 테이블뷰
    ///   - section: 섹션 인덱스
    /// - Returns: 인기 대외활동 헤더뷰
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as! ContestHeaderView

        header.titleLabel.text = "인기 대외활동"
        return header
    }
}



extension ContestsViewController: UITableViewDelegate {
    /// 셀의 높이를 지정합니다
    /// - Parameters:
    ///   - tableView: 해당 정보를 요청한 테이블뷰
    ///   - indexPath: 셀의 위치를 지정할 indexPath
    /// - Returns: 셀 높이
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 300
        } else {
            return 150
        }
    }
}



extension ContestsViewController: UISearchBarDelegate {
    /// 등록된 모든 회사 이름 또는 분야의 이름 접두어 개수와 서치바에 입력된 문자열 접두어를 비교합니다.
    /// - Parameters:
    ///   - searchBar: 편집중인 서치바
    ///   - searchText: 서치바에 포함된 텍스트
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        DispatchQueue.global().async {
            self.isSearching = true
            self.searchedContestDataList = self.contestDetailDataList.filter({
                $0.description.hasPrefix(searchText) || $0.field.hasPrefix(searchText)
            })
            DispatchQueue.main.async {
                self.listTableView.reloadData()
            }
        }
    }
}



extension ContestsViewController: UITableViewDataSourcePrefetching {
    /// - Parameters:
    ///   - tableView:  프리패칭을 요청한 테이블뷰
    ///   - indexPaths: 프리패칭 할 아이템의 indexPath 배열
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        /// 마지막 셀이 디큐되는 시점보다 -5를 해서 미리 데이터를 프리패칭하게 합니다.
        guard indexPaths.contains(where: { $0.row >= self.contestDetailDataList.count - 5}) else {
            return
        }
        if !isFetching {
            getContestData()
        }
    }
}
