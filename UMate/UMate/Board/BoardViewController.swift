//
//  BoardViewController.swift
//  UMate
//
//  Created by 안상희 on 2021/07/12.
//

import UIKit


/// 게시판 목록에 관한 클래스
/// - Author: 남정은
class BoardViewController: UIViewController {
    /// 게시판 목록에 대한 정보를 나타내는 테이블 뷰
    /// - Author: 남정은
    @IBOutlet weak var boardListTableView: UITableView!
    
    /// 북마크 속성에 관한 딕셔너리
    var bookmarks: [Int:Bool] = [:]
    
    
    /// 게시판 즐겨찾기 버튼의 색상 변경 & 즐겨찾기 속성 변경
    /// - Parameter sender: 즐겨찾기 핀버튼
    @IBAction func updateBookmark(_ sender: UIButton) {
        sender.tintColor = sender.tintColor == UIColor.init(named: "lightGrayNonSelectedColor") ? UIColor.init(named: "blackSelectedColor") : UIColor.init(named: "lightGrayNonSelectedColor")
        
        if bookmarks.keys.contains(sender.tag) {
            if let isBookmarked = bookmarks[sender.tag] {
                bookmarks[sender.tag] = !isBookmarked
            }
        }
    }
    
    
    /// 강의평가 게시판에서 게시판 화면으로 돌아올 때 사용
    /// - Author: 남정은
    @IBAction func unwindToBoard(_ unwindSegue: UIStoryboardSegue) {
    }
    
    
    /// 지정된 식별자의 세그의 실행여부를 결정
    /// - Parameters:
    ///   - identifier: 세그의 식별자
    ///   - sender: 세그가 시작된 객체
    /// - Returns: 세그를 실행하길 원한다면 true, 아니라면 false
    /// - Author: 남정은
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if let cell = sender as? UITableViewCell, let indexPath = boardListTableView.indexPath(for: cell) {
            /// 강의 평가 게시판은 performSegue를 이용
            if let _ = sender as? NonExpandableBoardTableViewCell, indexPath == IndexPath(row: 5, section: 1) {
                return false
            }
            
            /// 정보게시판은 performSegue를 이용
            if let _ = sender as? ExpandableBoardTableViewCell, indexPath == IndexPath(row: 0, section: 3){
                return false
            }
        }
        return true
    }
    
    
    /// 곧 실행될 뷰 컨트롤러에 대해 알림
    /// 새로운 뷰 컨트롤러r가 실행되기 전에 설정할 수 있다
    /// - Parameters:
    ///   - segue: 호출된 세그
    ///   - sender: 세그가 시작된 객체
    /// - Author: 남정은
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
    
    
    /// 뷰컨트롤러의 뷰계층이 메모리에 올라간 뒤 호출됨.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// 커스텀 테이블 뷰 헤더 등록
        boardListTableView.register(BoardCustomHeaderView.self, forHeaderFooterViewReuseIdentifier: "sectionHeader")
        
        /// nonExpandableBoard에대한 북마크 속성 초기화
        for row in 0..<nonExpandableBoardList.count {
            bookmarks[row + 200] = false
        }
        
        /// expandableBoard에대한 북마크 속성 초기화
        var sectionNum = 3
        for section in expandableBoardList {
            for row in 0..<section.boardNames.count {
                bookmarks[sectionNum * 100 + row] = false
            }
            sectionNum += 1
        }
    }
}



/// 게시판 목록을 나타내는 테이블 뷰에대한 데이터소스
/// - Author: 남정은
extension BoardViewController: UITableViewDataSource {
    /// 테이블 뷰 섹션의 개수를 지정
    /// - Parameter tableView: 요청한 정보를 나타낼 객체
    /// - Returns: 나타낼 섹션 수
    /// - Author: 남정은
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    
    /// 하나의 섹션안에 나타낼 row수를 지정
    /// - Parameters:
    ///   - tableView: 요청한 정보를 나타낼 객체
    ///   - section: 테이블 뷰의 섹션
    /// - Returns: 섹션안에 나타낼 row수
    /// - Author: 남정은
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        /// 내가 쓴 글, 댓글 단 글, 남긴 강의 정보
        case 0:
            return 3
            
        /// non expandable board
        case 1:
            return nonExpandableBoardList.count
            
        /// expandable board
        case 2,3:
            if expandableBoardList[section - 2].isExpanded {
                return expandableBoardList[section - 2].boardNames.count
            }
            return 0
            
        default: return 0
        }
    }
    
    
    /// 셀의 데이터소스를  테이블 뷰의 특정 위치에 추가하기위해 호출
    /// - Parameters:
    ///   - tableView: 요청한 정보를 나타낼 객체
    ///   - indexPath: 테이블 뷰의 row의 위치를 나타내는 인덱스패스
    /// - Returns: 구현을 완료한 셀
    /// - Author: 남정은
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /// 내가 남긴 글
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NonExpandableBoardTableViewCell", for: indexPath) as! NonExpandableBoardTableViewCell
            
            cell.configure(indexPath: indexPath)
            return cell
        }
        
        /// nonExxpandableBoard cell을 구성
        if indexPath.section == 1 {
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



/// 게시판 목록을 표시한 테이블 뷰에대한  동작 처리
/// - Author: 남정은
extension BoardViewController: UITableViewDelegate {
    /// 선택된 셀을 델리게이트에게 알려주어 특정 게시판으로 이동
    /// - Parameters:
    ///   - tableView: 요청한 정보를 나타낼 객체
    ///   - indexPath: 선택된 셀에 대한 인덱스
    /// - Author: 남정은
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        /// IndexPath( row: 5, section: 0 ) 인 cell을 선택시 강의평가 게시판으로 이동
        if indexPath.section == 1 && indexPath.row == 5 {
            performSegue(withIdentifier: "lectureSegue", sender: self)
        }
        /// IndexPath( row: 0, section: 2 ) 인 cell을 선택시 정보 게시판으로 이동
        else if indexPath.section == 3 && indexPath.row == 0 {
            performSegue(withIdentifier: "infoSegue", sender: self)
        }
    }
    
    
    /// 특정 섹션에 사용할 헤더의 높이를 델리게이트에게 알려줌
    /// - Parameters:
    ///   - tableView: 요청한 정보를 나타낼 객체
    ///   - section: 테이블 뷰의 섹션을 구분할 인덱스
    /// - Returns: 헤더의 높이
    /// - Author: 남정은
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 1:
            return 10
        case 2,3:
            return 80
        default: break
        }
        return 0
    }
    
    
    /// 지정된 섹션의 헤더에 나타낼 뷰를 델리게이트에게 알려줌
    /// - Parameters:
    ///   - tableView: 요청한 정보를 나타낼 객체
    ///   - section: 테이블 뷰의 섹션을 구분할 인덱스
    /// - Returns: 지정될 섹션위에 나타낼 UILabel, UIImageView, 혹은 커스 텀 뷰
    /// - Author: 남정은
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        /// header에 들어갈 버튼
        if section > 1 {
            let button = UIButton(type: .custom)
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "sectionHeader") as! BoardCustomHeaderView
            
            headerView.title.text = expandableBoardList[section - 2].sectionName
            headerView.title.textColor = UIColor.init(named: "blackSelectedColor")
            headerView.title.font = UIFont.preferredFont(forTextStyle: .title2)
            headerView.title.adjustsFontForContentSizeCategory = true
           
            headerView.summary.adjustsFontForContentSizeCategory = true
            /// isExpanded가 true라면 펼친 상태
            if expandableBoardList[section - 2].isExpanded {
                headerView.summary.isHidden = true
                headerView.image.image = UIImage(named: "up-arrow")
            }
            /// isExpanded가 false라면 접힌 상태
            else {
               
                headerView.summary.isHidden = false
                headerView.summary.text = expandableBoardList[section - 2].boardNames.joined(separator: ",")
                headerView.summary.textColor = UIColor.init(named: "darkGraySubtitleColor")
                headerView.summary.font = UIFont.preferredFont(forTextStyle: .caption1)
                headerView.image.image = UIImage(named: "down-arrow")
            }
            
            headerView.image.tintColor = UIColor.init(named: "lightGrayNonSelectedColor")
            
            headerView.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                button.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
                button.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
                button.topAnchor.constraint(equalTo: headerView.topAnchor),
                button.bottomAnchor.constraint(equalTo: headerView.bottomAnchor)
            ])
            
            button.addTarget(self, action: #selector(handleExpandClose(button:)), for: .touchUpInside)
            
            ///  버튼 태그는 2,3
            button.tag = section
            return headerView
        }
        
        let header = UIView()
        return header
    }
    
    
    /// 섹션에 들어갈 버튼에 액션부여
    /// - Parameter button: 헤더의 버튼
    /// - Author: 남정은
    @objc func handleExpandClose(button: UIButton) {
        ///  섹션은 2,3
        let section = button.tag
        
        var indexPathArr = [IndexPath]()
        
        /// expandableBoard의 각 게시판에 대한 indexPath를 배열로 추가
        for row in expandableBoardList[section - 2].boardNames.indices {
            let indexPath = IndexPath(row: row, section: section)
            indexPathArr.append(indexPath)
        }
        
        /// expandableBoard의 펼침 /접힘에 대한 속성 변경
        expandableBoardList[section - 2].isExpanded = !expandableBoardList[section - 2].isExpanded
        
        /// isExpanded가 true라면 펼친 상태
        if expandableBoardList[section - 2].isExpanded {
            boardListTableView.insertRows(at: indexPathArr, with: .fade)
            if section == 3 {
                DispatchQueue.main.async {
                    self.boardListTableView.scrollToRow(at: IndexPath(row: 1, section: 3),
                                                        at: .bottom, animated: true)
                }
            }
        }
        /// isExpanded가 false라면 접힌 상태
        else {
            boardListTableView.deleteRows(at: indexPathArr, with: .fade)
        }
        
        boardListTableView.reloadSections(IndexSet(section...section), with: .automatic)
    }
}


