//
// SearchListUniversityViewController.swift
// SearchListUniversityViewController
//
//  Created by 황신택 on 2021/08/06.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

/// 학교 이름을 포스팅 할 새로운 이름 생성
/// - Author: 황신택 (sinadsl1457@gmail.com)
extension Notification.Name {
    static let didTapSendUniversityName = Notification.Name("didTapSendUniversityName")
}

/// 학교 이름 검색 화면
/// - Author: 황신택 (sinadsl1457@gmail.com)
class SearchListUniversityViewController: CommonViewController {
    /// 학교 이름 검색 화면 서치바
    @IBOutlet weak var searchBar: UISearchBar!
    
    /// 검색 결과 테이블뷰
    @IBOutlet weak var listTableView: UITableView!
    
    /// 학교 이름 배열
    var universityNameList = [UniversityName]()
    
    /// 학교 이름 UserInfo 키
    static let universityNameTransitionKey = "universityNameTransitionKey"
    
    /// 이전 화면으로 이동합니다.
    /// - Parameter sender: cancelButton
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    /// 학교 선택 여부를 확인합니다.
    /// 선택한 대학교 이름을 노티피케이션으로 포스팅하고 화면을 닫습니다.
    /// - Parameter sender: completeButton
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    @IBAction func checkToUniversityName(_ sender: Any) {
        guard let searchBarText = searchBar.text, searchBarText.count != 0 else {
            alert(title: "알림", message: "학교를 선택해주세요.", handler: nil)
            return
        }
        
        NotificationCenter.default.post(name: .didTapSendUniversityName, object: nil, userInfo: [SearchListUniversityViewController.universityNameTransitionKey: searchBarText])
        
        dismiss(animated: true, completion: nil)
    }
    
    
    /// 초기화 작업을 진행합니다.
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    override func viewDidLoad() {
        super.viewDidLoad()
        listTableView.isHidden = true
        
        navigationItem.leftBarButtonItem?.tintColor = UIColor.dynamicColor(light: .darkGray, dark: .lightGray)
        navigationItem.rightBarButtonItem?.tintColor = UIColor.dynamicColor(light: .darkGray, dark: .lightGray)
        
        // Asset에 있는 UniversityName.txt 파일을 파싱합니다.
        // 파일의 내용을 Data 형식으로 읽어온 후 String 형식으로 변환하는 코드입니다.
        guard let universityNameData = NSDataAsset(name: "UniversityName")?.data else { return }
        guard let universityNameStr = String(data: universityNameData, encoding: .utf8) else { return }
        
        // trimmingCharacters로 해결안되는 txt 파일의 불필요한 공백을 제거합니다.
        let removeSpace = universityNameStr.replacingOccurrences(of: " ", with: "")
        
        // 쉼표 기준으로 문자를 배열로 만듭니다.
        let names = removeSpace.components(separatedBy: ",")
        
        names.forEach {
            let name = UniversityName(name: $0)
            universityNameList.append(name)
        }
        
        // 서치바 검색 유무에 따라 테이블 뷰에 표시되는 학교 목록이 달라집니다.
        searchBar.rx.text.orEmpty
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .map { [unowned self] query -> [UniversityName] in
                if isSearching {
                    let res = self.universityNameList.filter { $0.name.hasPrefix(query) }
                    return res
                } else {
                    return universityNameList
                }
            }
            .do(onNext: { _ in
                self.isSearching = true
                self.listTableView.reloadData()
            })
            .bind(to: listTableView.rx.items(cellIdentifier: "cell")) { row, name, cell in
                cell.textLabel?.text = name.name
            }
            .disposed(by: rx.disposeBag)
        
        // 데이터 모델의 value와 index의 짝을 맞춰서 방출합니다.
        Observable.zip(listTableView.rx.modelSelected(UniversityName.self), listTableView.rx.itemSelected)
            .bind { [unowned self] university, indexPath in
                self.listTableView.deselectRow(at: indexPath, animated: true)
                self.searchBar.text = university.name
            }
            .disposed(by: rx.disposeBag)
        
        searchBar.rx.setDelegate(self)
            .disposed(by: rx.disposeBag)
        
    }
            
}



extension SearchListUniversityViewController: UISearchBarDelegate {
    /// 서치바를 탭하면 테이블 뷰가 보이도록 구현합니다.
    /// - Parameter searchBar: 서치바를 탭하면 전달
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        listTableView.isHidden = false
    }
}
