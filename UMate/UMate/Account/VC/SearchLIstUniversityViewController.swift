//
//  SearchLIstUniversityViewController.swift
//  SearchLIstUniversityViewController
//
//  Created by 황신택 on 2021/08/06.
//

import UIKit

/// 학교 이름 포스팅할 새로운 이름 생성
/// 황신택 (sinadsl1457@gmail.com)
extension Notification.Name {
    static let didTapSendUniversityName = Notification.Name("didTapSendUniversityName")
}

/// 학교이름 검색 화면
/// 황신택 (sinadsl1457@gmail.com)
class SearchListUniversityViewController: UIViewController {
    /// 서치바
    @IBOutlet weak var searchBar: UISearchBar!
    
    /// 검색 결과를 보여주는 테이블뷰
    @IBOutlet weak var listTableView: UITableView!
    
    /// 학교리스트 문자열 배열
    var universityNames = [String]()
    
    /// 검색시 나오는 학교리스트 문자열 배열
    var searchedUniversity = [String]()
    
    /// 검색 유무의 차이를 주는 속성
    var searching = false
    
    /// 학교 이름 유저인포 키
    static let universityNameTransitionKey = "universityNameTransitionKey"
    
    
    /// 이전화면으로 갑니다.
    /// - Parameter sender: cancelButton
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    
    
    /// 학교 선택 여부를 확인합니다.
    /// 선택한 대학교이름을 노티피케이션으로 포스팅 하고 화면을 닫습니다.
    /// - Parameter sender: completeButton
    /// 황신택 (sinadsl1457@gmail.com)
    @IBAction func checkToUniversityName(_ sender: Any) {
        guard let searchBarText = searchBar.text, searchBarText.count != 0 else {
            alert(title: "알림", message: "학교를 선택해주세요.", handler: nil)
            return
        }
        NotificationCenter.default.post(name: .didTapSendUniversityName, object: nil, userInfo: [SearchListUniversityViewController.universityNameTransitionKey: searchBarText])
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 테이블뷰 델리게이트, 데이타소스 설정
        listTableView.delegate = self
        listTableView.dataSource = self
        
        // 서치바 델리게이트 설정
        searchBar.delegate = self
        
        // 테이블뷰 히든속성 초기화
        listTableView.isHidden = true
        
        // 네비게이션 왼쪽 바버튼 오른쪽 바버튼 라이트모드 다크모드 지원
        navigationItem.leftBarButtonItem?.tintColor = UIColor.dynamicColor(light: .darkGray, dark: .lightGray)
        navigationItem.rightBarButtonItem?.tintColor = UIColor.dynamicColor(light: .darkGray, dark: .lightGray)
        
        // Asset에 있는 txt파일을 데이타로 타입을 바인딩
        guard let universityNameData = NSDataAsset(name: "UniversityName")?.data else { return }
       
        // Data로 만든 파일을 String 파일로 바인딩
        guard let universityNameStr = String(data: universityNameData, encoding: .utf8) else { return }
        
        // trimmingCharacters로 해결안되는 txt파일 불필요한 공백을 제거
        let removeSpace = universityNameStr.replacingOccurrences(of: " ", with: "")
        
        // 쉼표 기준으로 문자를 배열로 만든다.
        universityNames = removeSpace.components(separatedBy: ",")
        
        // 배열로 만든 universityName을 포인문을 이용하여 공백을 제거하고 universityName배열에 추가
        for str in universityNames {
            let value = str.trimmingCharacters(in: .whitespaces)
            universityNames.append(value)

        }
     
    }
    
}


extension SearchListUniversityViewController: UITableViewDataSource {
    
    /// 검색시 나오는 결과값에 따라 셀의 개수를 다르게 표현합니다.
    /// - Parameters:
    ///   - tableView: 해당 작업을 요청한 테이블뷰
    ///   - section: 검색할시 검색된 대학교이름 리스트를 기본값은  전체 학교리스트 개수
    /// - Returns: 섹션의 로우 개수를 리턴합니다.
    /// 황신택 (sinadsl1457@gmail.com)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchedUniversity.count
        }
        
        return universityNames.count
    }
    
    
    /// 검색을 할때와 안할때 셀의 콘텐츠가 달라지도록 구현 합니다.
    /// - Parameters:
    ///   - tableView: 해당 작업을 요청한 테이블뷰
    ///   - indexPath: 셀의 indexPath
    /// - Returns: 검색중일 경우에는 검색된 학교 이름을 셀의 text에 저장한 셀이 리턴
    ///  아닌 경우에는 전체 학교이름중 하나를 셀의 text에 저장한 셀이 리턴 합니다.
    ///  황신택 (sinadsl1457@gmail.com)
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
    ///   - tableView: 해당 작업을 요청한 테이블뷰
    ///   - indexPath: 셀의 indexPath
    ///   황신택 (sinadsl1457@gmail.com)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searching {
            searchBar.text = searchedUniversity[indexPath.row]
        } else {
            searchBar.text = universityNames[indexPath.row]
        }
        
    }
    
}



/// 서치바를 기능적으로 구현하기 위한 확장자
/// 황신택 (sinadsl1457@gmail.com)
extension SearchListUniversityViewController: UISearchBarDelegate {
    /// 등록된 모든 대학교이름 접두어 개수와 서치바에 입력된 문자열 접두어를 비교합니다.
    /// - Parameters:
    ///   - searchBar: 서치바 텍스트 편집시 전달
    ///   - searchText: 서치바 텍스트 필드 안에있는 현재 텍스트
    ///   황신택 (sinadsl1457@gmail.com)
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searching = true
        searchedUniversity = universityNames.filter{ $0.prefix(searchText.count) == searchText }
        
        listTableView.reloadData()
    }
    
    
    /// 서치바를 탭할시 테이블뷰가 보이도록 구현 합니다.
    /// - Parameter searchBar: searchBar를 탭하면 전달
    /// 황신택 (sinadsl1457@gmail.com)
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        listTableView.isHidden = false
    }
    
}
