//
//  BoardViewController.swift
//  UMate
//
//  Created by 안상희 on 2021/07/12.
//

import UIKit


// TODO: section접었다 펼쳤을 때 스크롤 조정해야함

class BoardViewController: UIViewController {
    
    var bookmarks: [Int:Bool] = [:]
    
    @IBOutlet weak var boardListTableView: UITableView!
    
    
    /// 게시판 즐겨찾기 버튼의 색상 변경 & 즐겨찾기 속성 변경
    /// - Parameter sender: 즐겨찾기 핀버튼
    @IBAction func updateBookmark(_ sender: UIButton) {
        sender.tintColor = sender.tintColor == .lightGray ? .black : .lightGray
        
        if bookmarks.keys.contains(sender.tag) {
            if let isBookmarked = bookmarks[sender.tag] {
                bookmarks[sender.tag] = !isBookmarked
            }
        }
    }
    
    
    /// 지정된 identifier의 segue의 실행여부를 결정하는 메소드
    /// - Parameters:
    ///   - identifier: segue의 identifier
    ///   - sender: segue가 시작된 객체
    /// - Returns: segue를 실행하길 원한다면 true, 아니라면 false
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if let cell = sender as? UITableViewCell, let indexPath = boardListTableView.indexPath(for: cell) {
            /// 강의 평가 게시판은 performSegue를 이용
            if cell.reuseIdentifier == "NonExpandableBoardTableViewCell" && indexPath.row == 5 {
                return false
            }
            /// 정보게시판은 performSegue를 이용
            if cell.reuseIdentifier == "ExpandableBoardTableViewCell" && indexPath == IndexPath(row: 0, section: 2){
                return false
            }
        }
        return true
    }
    
    
    /// 곧 실행될 view controller에 대해 알리는 메소드.
    /// 새로운 view controller가 실행되기 전에 설정할 수 있다
    /// - Parameters:
    ///   - segue: 호출된 segue
    ///   - sender: segue가 시작된 객체
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        /// 정보게시판 더미데이터 전달
        if let vc = segue.destination as? FreeBoardViewController, segue.identifier == "infoSegue" {
            vc.selectedBoard = infoBoard
        }
        
        /// 나머지 게시판 더미데이터 전달
        if let cell = sender as? UITableViewCell, let indexPath = boardListTableView.indexPath(for: cell) {
            let boardKey = (indexPath.section + 1) * 100 + (indexPath.row)
            
            boardDict.forEach { element in
                if element.key == boardKey {
                    if let vc = segue.destination as? FreeBoardViewController {
                        vc.selectedBoard = element.value
                    } else if let vc = segue.destination as? CategoryBoardViewController {
                        vc.selectedBoard = element.value
                    }
                }
            }
        }
    }
    
    
    /// view가 view계층에 추가되기 직전에 view controller에게 알리는 메소드
    /// - Parameter animated: view가 window에 뜰 때 애니메이션의 유무
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /// 네비게이션 바 초기화
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
    }
    
    
    /// controller의 view가 메모리에 올라간 뒤 호출되는 메소드
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// custom tableView header등록
        boardListTableView.register(BoardCustomHeaderView.self, forHeaderFooterViewReuseIdentifier: "sectionHeader")
        
        /// nonExpandableBoard에대한 북마크 속성 초기화
        for row in 0..<nonExpandableBoardList.count {
            bookmarks[row + 100] = false
        }
        
        /// expandableBoard에대한 북마크 속성 초기화
        var sectionNum = 2
        for section in expandableBoardList {
            for row in 0..<section.boardNames.count {
                bookmarks[sectionNum * 100 + row] = false
            }
            sectionNum += 1
        }
    }
}




extension BoardViewController: UITableViewDataSource {
    
    /// tableView section의 개수를 지정하는 메소드
    /// - Parameter tableView: 요청한 정보를 나타낼 객체
    /// - Returns: 나타낼 section 수
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    
    /// 하나의 section안에 나타낼 row수를 지정하는 메소드
    /// - Parameters:
    ///   - tableView: 요청한 정보를 나타낼 객체
    ///   - section: tableView의 section index number
    /// - Returns: section안에 나타낼 row수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        /// non expandable board
        case 0:
            return nonExpandableBoardList.count
            
        /// expandable board
        case 1,2:
            if expandableBoardList[section - 1].isExpanded {
                return expandableBoardList[section - 1].boardNames.count
            }
            return 0
            
        default: return 0
        }
    }
    
    
    /// cell의 data source를  tableView의 특정 위치에 insert하기위해 호출하는 메소드
    /// - Parameters:
    ///   - tableView: 요청한 정보를 나타낼 객체
    ///   - indexPath: tableView의 row의 위치를 나타내는 index path
    /// - Returns: 구현을 완료한 cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /// nonExxpandableBoard cell을 구성
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NonExpandableBoardTableViewCell", for: indexPath) as! NonExpandableBoardTableViewCell
            
            cell.configure(boardList: nonExpandableBoardList, indexPath: indexPath)
            return cell
        }
        
        /// expandableBoard cell을 구성
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpandableBoardTableViewCell", for: indexPath) as! ExpandableBoardTableViewCell
        
        cell.board = self
        cell.configure(boardList: expandableBoardList, indexPath: indexPath)
        return cell
    }
}




extension BoardViewController: UITableViewDelegate {
    
    /// 선택된 cell을 delegate에게 알려주는 메소드
    /// - Parameters:
    ///   - tableView: 요청한 정보를 나타낼 객체
    ///   - indexPath: 선택된 cell에 대한 index path
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        /// IndexPath( row: 5, section: 0 ) 인 cell을 선택시 강의평가 게시판으로 이동
        if indexPath.section == 0 && indexPath.row == 5 {
            performSegue(withIdentifier: "lectureSegue", sender: self)
        }
        /// IndexPath( row: 0, section: 2 ) 인 cell을 선택시 정보 게시판으로 이동
        else if indexPath.section == 2 && indexPath.row == 0 {
            performSegue(withIdentifier: "infoSegue", sender: self)
        }
    }
    
    
    /// 특정 section에 사용할 header의 높이를 delegate에게 알려주는 메소드
    /// - Parameters:
    ///   - tableView: 요청한 정보를 나타낼 객체
    ///   - section: tableView의 section을 구분할 index number
    /// - Returns: header의 높이
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 10
        case 1, 2:
            return 80
        default: break
        }
        return 0
    }
    
    
    /// 지정된 section의 header에 나타낼 view를 delegate에게 알려주는 메소드
    /// - Parameters:
    ///   - tableView: 요청한 정보를 나타낼 객체
    ///   - section: tableView의 section을 구분할 index number
    /// - Returns: 지정될 section위에 나타낼 UILabel, UIImageView, 혹은 커스 텀 뷰
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        /// header에 들어갈 버튼
        if section != 0 {
            let button = UIButton(type: .custom)
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "sectionHeader") as! BoardCustomHeaderView
            view.title.text = expandableBoardList[section - 1].sectionName
            view.title.textColor = .darkGray
            view.title.font = UIFont.boldSystemFont(ofSize: 23)
            view.image.image = UIImage(named: "downarrow")
            view.image.tintColor = .darkGray
            
            view.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                button.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                button.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                button.topAnchor.constraint(equalTo: view.topAnchor),
                button.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
            
            button.addTarget(self, action: #selector(handleExpandClose(button:)), for: .touchUpInside)
            
            ///  버튼 태그는 1,2
            button.tag = section
            return view
        }
        
        let header = UIView()
        return header
    }
    
    
    /// section에 들어갈 버튼에 action부여
    /// - Parameter button: header의 button
    @objc func handleExpandClose(button: UIButton) {
        ///  섹션은 1,2
        let section = button.tag
        
        var indexPathArr = [IndexPath]()
        
        /// expandableBoard의 각 게시판에 대한 indexPath를 배열로 추가
        for row in expandableBoardList[section - 1].boardNames.indices {
            let indexPath = IndexPath(row: row, section: section)
            indexPathArr.append(indexPath)
        }
        
        /// expandableBoard의 펼침 /접힘에 대한 속성 변경
        expandableBoardList[section - 1].isExpanded = !expandableBoardList[section - 1].isExpanded
        
        /// isExpanded가 true라면 펼친 상태
        if expandableBoardList[section - 1].isExpanded {
            boardListTableView.insertRows(at: indexPathArr, with: .fade)
        }
        /// isExpanded가 false라면 접힌 상태
        else {
            boardListTableView.deleteRows(at: indexPathArr, with: .fade)
        }
    }
}


