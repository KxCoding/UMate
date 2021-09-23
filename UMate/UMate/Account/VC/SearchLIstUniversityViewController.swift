//
//  SearchLIstUniversityViewController.swift
//  SearchLIstUniversityViewController
//
//  Created by 황신택 on 2021/08/06.
//

import UIKit

/// 새로운 노티피케이션 이름을 만듬.
extension Notification.Name {
    static let didTapSendUniversityName = Notification.Name("didTapSendUniversityName")
}

class SearchLIstUniversityViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var listTableView: UITableView!
    
    var universityName = [String]()
    /// 원하는 결과를 문자열 배열로 저장 하기 위한 속성
    var searchUniversity = [String]()
    /// 검색을 안했을때의 결과와 검색을 했을때의 결과값을 다르게 주기위해서 선언
    var searching = false
    /// Create userInfo Key
    static let universityNameTransitionKey = "universityNameTransitionKey"
    /// Back to previous View
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    
    /// 대학교이름이 들어갔는지와 대학교이름을 이전 화면에 전달
    /// - Parameter sender: completeButton
    @IBAction func checkToUniversityName(_ sender: Any) {
        guard let searchBarText = searchBar.text, searchBarText.count != 0 else {
            alert(title: "알림", message: "학교를 선택해주세요.", handler: nil)
            return
        }
        NotificationCenter.default.post(name: .didTapSendUniversityName, object: nil, userInfo: [SearchLIstUniversityViewController.universityNameTransitionKey: searchBarText])
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /// 테이블뷰 델리게이트, 데이타소스 선언
        listTableView.delegate = self
        listTableView.dataSource = self
        
        /// 서치바 델리게이트 선언
        searchBar.delegate = self
        
        /// 테이블뷰 히든속성 초기화
        listTableView.isHidden = true
        
        /// 네비게이션 왼쪽 바버튼 오른쪾 바버튼 라이트모드 다크모드 지원
        navigationItem.leftBarButtonItem?.tintColor = UIColor.dynamicColor(light: .darkGray, dark: .lightGray)
        navigationItem.rightBarButtonItem?.tintColor = UIColor.dynamicColor(light: .darkGray, dark: .lightGray)
        
        /// Asset에 있는 txt파일을 데이타로 타입을 바인딩 합니다 .
        guard let universityNameData = NSDataAsset(name: "UniversityName")?.data else { return }
       
        /// Data로 만든 파일을 String 파일로 바인딩 합니다.
        guard let universityNameStr = String(data: universityNameData, encoding: .utf8) else { return }
        
        /// trimmingCharacters로 해결안되는 txt파일 불필요한 공백을 없애줍니다.
        let removeSpace = universityNameStr.replacingOccurrences(of: " ", with: "")
        
        /// , 기준으로 문자열 배열로 만들어줍니다
        universityName = removeSpace.components(separatedBy: ",")
        
        for str in universityName {
            let value = str.trimmingCharacters(in: .whitespaces)
            universityName.append(value)

        }
     
    }
    
}


extension SearchLIstUniversityViewController: UITableViewDataSource {
    
    /// 검색시 나오는 결과값에 따라 셀의 갯수를 다르게 표현.
    /// - Parameters:
    ///   - tableView: tableView
    ///   - section: searchCountry.count or universityList.count
    /// - Returns: Int
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchUniversity.count
        }
        
        return universityName.count
    }
    
    
    /// 검색을 할때와 안할때 셀의 콘텐츠가 달라지도록 구현.
    /// - Parameters:
    ///   - tableView: UITableView
    ///   - indexPath: IndexPath
    /// - Returns: searching true일 경우에는 searchUniversity[indexPath.row] searching false 일 경우에는 universityName[indexPath.row]
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        if searching {
            cell.textLabel?.text = searchUniversity[indexPath.row]
        } else {
            cell.textLabel?.text = universityName[indexPath.row]
        }
        
        return cell
    }
    
    
}

extension SearchLIstUniversityViewController: UITableViewDelegate {
    /// 검색을 할때와 안할때 셀의 탭할시 row가 달라짐
    /// - Parameters:
    ///   - tableView: UITableView
    ///   - indexPath: IndexPath
    /// - Returns: searching true일 경우에는 searchUniversity[indexPath.row] searching false 일 경우에는 universityName[indexPath.row]
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searching {
            searchBar.text = searchUniversity[indexPath.row]
        } else {
            searchBar.text = universityName[indexPath.row]
        }
        
    }
    
}


extension SearchLIstUniversityViewController: UISearchBarDelegate {
    
    /// 등록된 모든 대학교이름 접두어 개수와 서치바에 입력된 문자열 접두어를 비교한다.
    /// - Parameters:
    ///   - searchBar: searchBar
    ///   - searchText: searchText
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searching = true
        searchUniversity = universityName.filter{ $0.prefix(searchText.count) == searchText }
        
        listTableView.reloadData()
    }
    
    
    /// 서치바를 탭할시 테이블뷰가 보이도록 구현
    /// - Parameter searchBar: searchBar
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        listTableView.isHidden = false
    }
    
}
