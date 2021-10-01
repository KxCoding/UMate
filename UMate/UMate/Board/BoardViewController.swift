//
//  BoardViewController.swift
//  UMate
//
//  Created by 안상희 on 2021/07/12.
//

import UIKit


/// 게시판 목록에 관한 뷰 컨트롤러
/// - Author: 남정은(dlsl7080@gmail.com)
class BoardViewController: CommonViewController {
    /// 게시판 목록에 대한 정보를 나타내는 테이블 뷰
    @IBOutlet weak var boardListTableView: UITableView!
    
    /// 북마크 속성에 관한 딕셔너리
    var bookmarks: [Int:Bool] = [:]
    
    
    /// 게시판 즐겨찾기 버튼의 색상 변경 & 즐겨찾기 속성을 변경합니다.
    /// - Parameter sender: UIButton. 즐겨찾기 핀버튼
    @IBAction func updateBookmark(_ sender: UIButton) {
        sender.tintColor = sender.tintColor == UIColor.init(named: "lightGrayNonSelectedColor") ? UIColor.init(named: "blackSelectedColor") : UIColor.init(named: "lightGrayNonSelectedColor")
        
        if bookmarks.keys.contains(sender.tag) {
            if let isBookmarked = bookmarks[sender.tag] {
                bookmarks[sender.tag] = !isBookmarked
            }
        }
    }
    
    
    /// 강의평가 게시판에서 게시판 화면으로 돌아올 때 사용합니다.
    /// - Parameter unwindSegue: DetailLectureReviewViewController -> BoardViewController
    @IBAction func unwindToBoard(_ unwindSegue: UIStoryboardSegue) {
    }
    
    
    /// 지정된 식별자의 segue의 실행여부를 결정합니다.
    /// - Parameters:
    ///   - identifier: segue의 식별자
    ///   - sender: segue가 시작된 객체
    /// - Returns: segue를 실행하길 원한다면 true, 아니라면 false
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if let cell = sender as? UITableViewCell, let indexPath = boardListTableView.indexPath(for: cell) {
            // 강의 평가 게시판은 performSegue를 이용
            if let _ = sender as? NonExpandableBoardTableViewCell, indexPath == IndexPath(row: 5, section: 1) {
                return false
            }
            
            // 정보게시판은 performSegue를 이용
            if let _ = sender as? ExpandableBoardTableViewCell, indexPath == IndexPath(row: 0, section: 3){
                return false
            }
        }
        return true
    }
    
    
    /// 곧 실행될 뷰 컨트롤러를 준비합니다.
    ///
    /// 새로운 뷰 컨트롤러가 실행되기 전에 설정할 수 있습니다.
    /// - Parameters:
    ///   - segue: 호출된 segue
    ///   - sender: segue가 시작된 객체
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /// 정보게시판 더미데이터 전달
        if let vc = segue.destination as? FreeBoardViewController, segue.identifier == "infoSegue" {
            vc.selectedBoard = infoBoard
        }
        
        // 나머지 게시판 더미데이터 전달
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 커스텀 테이블 뷰 헤더 등록
        let headerNib = UINib(nibName: "BoardCustomHeader", bundle: nil)
        boardListTableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "sectionHeader")
        
        // 게시판 목록 section별로 펼치고 접는 동작
        let token = NotificationCenter.default.addObserver(forName: .expandOrFoldSection, object: nil, queue: .main) { [weak self] noti in
            if let section = noti.userInfo?["section"] as? Int {
                guard let self = self else { return }
                
                var indexPathArr = [IndexPath]()
                
                // expandableBoard의 각 게시판에 대한 indexPath를 배열로 추가
                for row in expandableBoardList[section - 2].boardNames.indices {
                    let indexPath = IndexPath(row: row, section: section)
                    indexPathArr.append(indexPath)
                }
                
                // isExpanded가 true라면 펼친 상태
                if expandableBoardList[section - 2].isExpanded {
                    self.boardListTableView.insertRows(at: indexPathArr, with: .fade)
                    if section == 3 {
                        DispatchQueue.main.async {
                            self.boardListTableView.scrollToRow(at: IndexPath(row: 1, section: 3),
                                                                at: .bottom, animated: true)
                        }
                    }
                }
                // isExpanded가 false라면 접힌 상태
                else {
                    self.boardListTableView.deleteRows(at: indexPathArr, with: .fade)
                }
                
                self.boardListTableView.reloadSections(IndexSet(section...section), with: .automatic)
            }
        }
        tokens.append(token)
        
        // nonExpandableBoard에대한 북마크 속성 초기화
        for row in 0..<nonExpandableBoardList.count {
            bookmarks[row + 200] = false
        }
        
        // expandableBoard에대한 북마크 속성 초기화
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
extension BoardViewController: UITableViewDataSource {
    ///  게시판 그룹 수를 설정합니다.
    /// - Parameter tableView: 게시판 목록을 나타내는 tableView
    /// - Returns: 나타낼 section 수
    /// - Author: 남정은
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    
    /// 하나의 섹션안에 들어갈 게시판 수를 설정합니다.
    /// - Parameters:
    ///   - tableView: 게시판 목록을 나타내는 tableView
    ///   - section: section. 게시판 그룹을 나타냅니다.
    /// - Returns: 섹션안에 나타낼 row수
    /// - Author: 남정은
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        /// 내가 쓴 글, 댓글 단 글, 남긴 강의 정보
        case 0:
            return 3
            
        // non expandable board
        case 1:
            return nonExpandableBoardList.count
            
        // expandable board
        case 2,3:
            if expandableBoardList[section - 2].isExpanded {
                return expandableBoardList[section - 2].boardNames.count
            }
            return 0
            
        default: return 0
        }
    }
    
    
    /// 각 게시판에 대한 정보를 셀에 나타냅니다.
    /// - Parameters:
    ///   - tableView: 게시판 목록을 나타내는 tableView
    ///   - indexPath: 게시판 목록을 나타내는 cell의 indexPath
    /// - Returns: 구현을 완료한 셀
    /// - Author: 남정은
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 내가 남긴 글
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NonExpandableBoardTableViewCell", for: indexPath) as! NonExpandableBoardTableViewCell
            
            cell.configure(indexPath: indexPath)
            return cell
        }
        
        // nonExxpandableBoard cell을 구성
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NonExpandableBoardTableViewCell", for: indexPath) as! NonExpandableBoardTableViewCell
            
            cell.configure(boardList: nonExpandableBoardList, indexPath: indexPath)
            return cell
        }
        
        // expandableBoard cell을 구성
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpandableBoardTableViewCell", for: indexPath) as! ExpandableBoardTableViewCell
        
        cell.board = self
        cell.configure(boardList: expandableBoardList, indexPath: indexPath)
        return cell
    }
}



/// 게시판 목록을 표시한 테이블 뷰에대한  동작 처리
extension BoardViewController: UITableViewDelegate {
    /// 선택된 셀을 통해 특정 게시판으로 이동합니다.
    /// - Parameters:
    ///   - tableView: 게시판 목록을 나타내는 tableView
    ///   - indexPath: 게시판 목록을 나타내는 cell의 indexPath
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // IndexPath( row: 5, section: 1 ) 인 cell을 선택시 강의평가 게시판으로 이동
        if indexPath.section == 1 && indexPath.row == 5 {
            performSegue(withIdentifier: "lectureSegue", sender: self)
        }
        // IndexPath( row: 0, section: 3 ) 인 cell을 선택시 정보 게시판으로 이동
        else if indexPath.section == 3 && indexPath.row == 0 {
            performSegue(withIdentifier: "infoSegue", sender: self)
        }
    }
    
    
    /// 각 section에 사용할 헤더의 높이를 설정합니다.
    /// - Parameters:
    ///   - tableView: 게시판 목록을 나타내는 tableView
    ///   - section: section. 게시판 그룹을 나타냅니다.
    /// - Returns: 헤더의 높이
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
    
    
    /// 커스텀 헤더뷰를 원하는 section에 보여줍니다.
    /// - Parameters:
    ///   - tableView: 게시판 목록을 나타내는 tableView
    ///   - section: section. 게시판 그룹을 나타냅니다.
    /// - Returns: 지정될 섹션위에 나타낼 UILabel, UIImageView, 혹은 커스 텀 뷰
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section >= 2 {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "sectionHeader") as! BoardCustomHeaderView
            
            headerView.backView.backgroundColor = .systemBackground
            headerView.configure(section: section)
            return headerView
        }
        let header = UIView()
        return header
    }
}


