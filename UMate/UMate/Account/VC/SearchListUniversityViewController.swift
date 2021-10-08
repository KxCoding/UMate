//
//  SearchLIstUniversityViewController.swift
//  SearchLIstUniversityViewController
//
//  Created by 황신택 on 2021/08/06.
//

import UIKit

/// 학교 이름을 포스팅 할 새로운 노티피케이션 이름 생성
/// Author: 황신택 (sinadsl1457@gmail.com)
extension Notification.Name {
    static let didTapSendUniversityName = Notification.Name("didTapSendUniversityName")
}

/// 학교이름 검색 화면
/// Author: 황신택 (sinadsl1457@gmail.com)
class SearchListUniversityViewController: UIViewController {
    /// 학교 이름 검색 화면 서치바
    @IBOutlet weak var searchBar: UISearchBar!
    
    /// 검색 결과 테이블뷰
    @IBOutlet weak var listTableView: UITableView!
    
    /// 학교 이름 배열
    var universityNames = [String]()
    
    /// 검색된 학교 이름 배열
    var searchedUniversity = [String]()
    
    /// 검색 진행 플래그
    var searching = false
    
    /// 학교 이름 유저인포 키
    static let universityNameTransitionKey = "universityNameTransitionKey"
    
    
    /// 이전 화면으로 이동합니다.
    /// - Parameter sender: cancelButton
    /// Author: 황신택 (sinadsl1457@gmail.com)
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    
    
    /// 학교 선택 여부를 확인합니다.
    /// 선택한 대학교 이름을 노티피케이션으로 포스팅하고 화면을 닫습니다.
    /// - Parameter sender: completeButton
    /// Author: 황신택 (sinadsl1457@gmail.com)
    @IBAction func checkToUniversityName(_ sender: Any) {
        guard let searchBarText = searchBar.text, searchBarText.count != 0 else {
            alert(title: "알림", message: "학교를 선택해주세요.", handler: nil)
            return
        }
        NotificationCenter.default.post(name: .didTapSendUniversityName, object: nil, userInfo: [SearchListUniversityViewController.universityNameTransitionKey: searchBarText])
        
        dismiss(animated: true, completion: nil)
    }
    
    
    /// 초기화 작업은 진행합니다.
    /// Author: 황신택 (sinadsl1457@gmail.com)
    override func viewDidLoad() {
        super.viewDidLoad()
        listTableView.delegate = self
        listTableView.dataSource = self

        listTableView.isHidden = true
    
        navigationItem.leftBarButtonItem?.tintColor = UIColor.dynamicColor(light: .darkGray, dark: .lightGray)
        navigationItem.rightBarButtonItem?.tintColor = UIColor.dynamicColor(light: .darkGray, dark: .lightGray)
        
        // Asset에 있는 UniversityName.txt파일을 파싱합니다.
        // 파일의 내용을 Data 형식으로 읽어온 후 String 형식으로 변환하는 코드입니다.
        guard let universityNameData = NSDataAsset(name: "UniversityName")?.data else { return }
        guard let universityNameStr = String(data: universityNameData, encoding: .utf8) else { return }

        // trimmingCharacters로 해결안되는 txt파일의 불필요한 공백을 제거 합니다.
        let removeSpace = universityNameStr.replacingOccurrences(of: " ", with: "")
        
        // 쉼표 기준으로 문자를 배열로 만듭니다.
        universityNames = removeSpace.components(separatedBy: ",")

        for str in universityNames {
            let value = str.trimmingCharacters(in: .whitespaces)
            universityNames.append(value)
        }
    }
}



extension SearchListUniversityViewController: UITableViewDataSource {
    /// 검색시 나오는 결과값에 따라 셀의 개수를 다르게 표현합니다.
    /// - Parameters:
    ///   - tableView: 검색 결과 테이블뷰
    ///   - section:섹션 Index
    /// - Returns: 섹션에 표시할 셀 수를 리턴합니다.
    /// Author: 황신택 (sinadsl1457@gmail.com)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchedUniversity.count
        }
        return universityNames.count
    }
    
    
    /// 검색 결과 셀을 구성합니다. 검색 상태에 따라서 셀에 출력하는 내용이 달라집니다.
    /// - Parameters:
    ///   - tableView: 검색 결과 테이블뷰
    ///   - indexPath: 셀의 indexPath
    /// - Returns: 검색중일 경우에는 검색된 학교 이름의 셀이 리턴됩니다. 아닌 경우는 전체 학교 리스트가 리턴됩니다.
    /// Author: 황신택 (sinadsl1457@gmail.com)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        if searching {
            cell.textLabel?.text = searchedUniversity[indexPath.row]
        } else {
            cell.textLabel?.text = universityNames[indexPath.row]
        }
        
        return cell
    }
}



extension SearchListUniversityViewController: UITableViewDelegate {
    /// 검색 중일 시 셀을 탭 하면 검색된 학교이름이 서치바 텍스트에 저장됩니다.
    /// 아닐 시 전체 학교이름중 하나가 텍스트에 저장됩니다.
    /// - Parameters:
    ///   - tableView: 검색 결과 테이블뷰
    ///   - indexPath: 셀의 indexPath
    /// Author: 황신택 (sinadsl1457@gmail.com)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searching {
            searchBar.text = searchedUniversity[indexPath.row]
        } else {
            searchBar.text = universityNames[indexPath.row]
        }
        
    }
    
}



/// 서치바 델리게이트를 구현하는 익스텐션
/// Author: 황신택 (sinadsl1457@gmail.com)
extension SearchListUniversityViewController: UISearchBarDelegate {
    /// 등록된 모든 대학교이름 접두어 개수와 서치바에 입력된 문자열 접두어를 비교합니다.
    /// - Parameters:
    ///   - searchBar: 서치바
    ///   - searchText: 서치바 텍스트 필드 안에 있는 현재 텍스트
    /// Author: 황신택 (sinadsl1457@gmail.com)
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searching = true
        searchedUniversity = universityNames.filter{ $0.prefix(searchText.count) == searchText }
        
        listTableView.reloadData()
    }
    
    
    /// 서치바를 탭할시 테이블뷰가 보이도록 구현 합니다.
    /// - Parameter searchBar: 서치바 를 탭하면 전달
    /// Author: 황신택 (sinadsl1457@gmail.com)
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        listTableView.isHidden = false
    }
    
}
