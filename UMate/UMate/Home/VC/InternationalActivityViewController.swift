//
//  ContestViewController.swift
//  ContestViewController
//
//  Created by 황신택 on 2021/09/14.
//

import UIKit

/// 대외활동 화면
/// - Author: 황신택 (sinadsl1457@gmail.com)
class InternationalActivityViewController: UIViewController {
    /// 대외활동 테이블 뷰
    @IBOutlet weak var listTableView: UITableView!
    
    /// 대외활동 서치바
    @IBOutlet weak var contestSearchBar: UISearchBar!
    
    /// 인기 대외활동 데이터 목록
    var contestDataList = [ContestSingleData.FavoriteContests]()
    
    /// 대외활동 데이터 목록
    var contestDetailDataList = [ContestSingleData.Contests]()
    
    /// 검색된 대외활동 목록
    var searchedContestDataList = [ContestSingleData.Contests]()
    
    /// 걷색  진행 플래그
    var isSearching = false
    
    /// 대외활동 데이터 패칭 플래그
    var isFetching = false
    
    
    /// 이전 화면으로 이동합니다.
    /// - Parameter sender: cancelButton
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    /// 제이슨 데이터를 파싱 하고 파싱 된 데이터를 아이디로 정렬해서 오름차순으로 저장합니다.
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    func getContestData() {
        guard !isFetching else { return }
        isFetching = true
        
        DispatchQueue.global().async {
            guard let contestData = PlaceDataManager.shared.getObject(of: ContestSingleData.self, fromJson: "contests") else { return }
            
            self.contestDataList = contestData.favoriteList
            self.contestDetailDataList = contestData.contestList.sorted(by: { $0.id < $1.id})
        }
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
        
        // 대외활동 서치바의 바운드의 라인을 제거합니다.
        contestSearchBar.backgroundImage = UIImage()
        
        let headerNib = UINib(nibName: "Header", bundle: nil)
        listTableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "header")
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(InternationalActivityViewController.backgroundTap))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    /// 뷰를 탭하면 키보드를 내립니다.
    /// 뷰 전체가 탭 영역입니다.
    /// - Parameter sender: UITapGestureRecognizer
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    @objc func backgroundTap(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}



extension InternationalActivityViewController: UITableViewDataSource {
    ///  섹션에 로우의 개수를 지정합니다.
    /// - Parameters:
    ///   - tableView: 해당 정보를 요청한 테이블뷰
    ///   - section: 섹션의 위치
    /// - Returns: 테이블 뷰에 표시할 섹션 수를 리턴합니다.
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return searchedContestDataList.count
        } else {
            return contestDetailDataList.count
        }
    }
    
    
    /// 인기 대외활동과 대외활동 데이터가 담긴 셀을 구현합니다.
    /// - Parameters:
    ///   - tableView: 정보를 요청한 테이블뷰
    ///   - indexPath: 해당하는 셀에 indexPath
    /// - Returns: 대외활동 데이터가 담긴 셀이 리턴됩니다.
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PoppularInternationalActivityTableViewCell", for: indexPath) as! PoppularInternationalActivityTableViewCell
            
            cell.configure(with: contestDataList)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InternationalActivityTableViewCell", for: indexPath) as! InternationalActivityTableViewCell
            
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
    
    
    /// 인기 대외활동 헤더뷰를 구현합니다.
    /// - Parameters:
    ///   - tableView: 뷰를 요청한 테이블뷰
    ///   - section: 헤더뷰가 포함된 섹션의 개수
    /// - Returns: 인기 대외활동 헤더뷰를 리턴합니다.
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as! InternationalHeaderView
        
        header.titleLabel.text = "인기 대외활동"
        return header
    }
}



extension InternationalActivityViewController: UITableViewDelegate {
    /// 셀의 높이를 지정합니다
    /// - Parameters:
    ///   - tableView: 해당 정보를 요청한 테이블뷰
    ///   - indexPath: 셀의 위치를 지정할 indexPath
    /// - Returns: 셀의 높이가 리턴됩니다.
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 300
        } else {
            return 150
        }
    }
}



extension InternationalActivityViewController: UISearchBarDelegate {
    /// 등록된 모든 회사 이름 또는 분야의 이름 접두어 개수와 서치바에 입력된 문자열 접두어를 비교합니다.
    /// - Parameters:
    ///   - searchBar: 편집중인 서치바
    ///   - searchText: 서치바에 포함된 텍스트
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        DispatchQueue.global().async {
            self.isSearching = true
            self.searchedContestDataList = self.contestDetailDataList.filter({
                $0.description.prefix(searchText.count) == searchText || $0.website.prefix(searchText.count) == searchText
            })
            DispatchQueue.main.async {
                self.listTableView.reloadData()
            }
        }
    }
}


extension InternationalActivityViewController: UITableViewDataSourcePrefetching {
    /// 테이블뷰 셀을 프리패칭합니다.
    /// 데이터 패칭이 안된경우에만 프리패칭을합니다.
    /// - Parameters:
    ///   - tableView:  프리패칭 요청한 테이블뷰
    ///   - indexPaths: 프리패칭할 아이템의 index 를 지정할수있습니다.
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
