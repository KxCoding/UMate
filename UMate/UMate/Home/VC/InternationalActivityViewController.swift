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
    
    /// 대외활동 데이터 목록
    var contestDataList = [ContestSingleData.FavoriteContests]()
    
    /// 검색된 대외활동 데이터 목록
    var searchedDataList = [ContestSingleData.FavoriteContests]()
    
    /// 걷색  실행 플래그
    var isSearching = false
    
    
    /// 이전 화면으로 이동합니다.
    /// - Parameter sender: cancelButton
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    /// 제이슨 데이터를 파싱 하고 파싱 된 데이터를 아이디로 정렬해서 오름차순으로 저장합니다.
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    func getContestData() {
        DispatchQueue.global().async {
            guard let contestData = DataManager.shared.getObject(of: ContestSingleData.self, fromJson: "contests") else { return }
            self.contestDataList = contestData.favoriteList
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
        
        let headerNib = UINib(nibName: "Header", bundle: nil)
        listTableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "header")
    }
}



extension InternationalActivityViewController: UITableViewDataSource {
    /// 테이블 뷰 섹션의 수를 지정합니다.
    /// - Parameter tableView: 해당 정보를 요청한 테이블뷰
    /// - Returns: 섹션의 개수
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    ///  섹션에 로우의 개수를 지정합니다.
    /// - Parameters:
    ///   - tableView: 해당 정보를 요청한 테이블뷰
    ///   - section: 섹션의 위치
    /// - Returns: 테이블 뷰에 표시할 섹션 수를 리턴합니다.
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return contestDataList.count
        } else {
            return 1
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "InternationalActivityTableViewCell", for: indexPath) as! PoppularInternationalActivityTableViewCell
            
            cell.configure(with: contestDataList)
            return cell
        } else {
            return UITableViewCell()
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
    
}

