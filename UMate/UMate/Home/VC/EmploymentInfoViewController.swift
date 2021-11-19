//
//  EmploymentInfoViewController.swift
//  EmploymentInfoViewController
//
//  Created by 황신택 on 2021/09/14.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import RxAlamofire


/// 채용정보 화면
/// - Author: 황신택 (sinadsl1457@gmail.com)
class EmploymentInfoViewController: CommonViewController {
    /// 채정정보 테이블 뷰
    @IBOutlet weak var listTableView: UITableView!
    
    /// 서치바
    @IBOutlet weak var searchBar: UISearchBar!

    var list = BehaviorSubject<[JobData.Job]>(value: [])
    
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
        overrideUserInterfaceStyle = .light
        
        // 다크모드 라이트모드 상관없이 항상 타이틀 색상을 darkGray로 지정합니다.
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.dynamicColor(light: .darkGray, dark: .darkGray)]
        
        navigationItem.leftBarButtonItem?.tintColor = UIColor.dynamicColor(light: .darkGray, dark: .darkGray)
        
        // 파싱 메소드 호출 합니다.
        getJobData()
        
        // 서치바의 바운드의 라인을 제거합니다.
        searchBar.backgroundImage = UIImage()
        
        didTapMakeLowerKeyboard()
        
        // 검색 유무에 따라 테이블뷰 채용정보 목록 결과가 달라집니다.
        searchBar.rx.text.orEmpty
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .map {[unowned self] query -> [JobData.Job] in
                if self.isSearching {
                    let res = self.jobList.filter { $0.title.hasPrefix(query) || $0.field.hasPrefix(query) }
                    return res
                } else {
                    return self.jobList
                }
            }
            .do(onNext: { _ in
                self.isSearching = true
                self.listTableView.reloadData()
            })
            .bind(to: listTableView.rx.items(cellIdentifier: "CompanyTableViewCell", cellType: EmploymentInfoTableViewCell.self)) { row, element, cell in
                cell.configureCompany(with: element)
            }
            .disposed(by: rx.disposeBag)

                
        listTableView.rx.setDelegate(self)
            .disposed(by: rx.disposeBag)
        
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
