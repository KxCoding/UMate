//
//  BoardViewController.swift
//  UMate
//
//  Created by 안상희 on 2021/07/12.
//

import UIKit


/// 게시판 목록 뷰 컨트롤러
/// - Author: 남정은(dlsl7080@gmail.com)
class BoardViewController: CommonViewController {
    /// 게시판 목록 테이블 뷰
    @IBOutlet weak var boardListTableView: UITableView!
    
    /// 북마크 속성에 관한 딕셔너리
    var bookmarks: [Int:Bool] = [:]
    
    /// 선택된 게시판의 indexPath
    var index: IndexPath?
    
    /// 게시판 목록
    var boardList = [BoardDtoResponseData.BoardDto]()
    
    /// 스크랩 게시물 목록
    var scrapPostList = [PostListDtoResponseData.PostDto]()
    
    
    /// 게시판 즐겨찾기 버튼의 색상 & 즐겨찾기 속성을 변경합니다.
    /// - Parameter sender: UIButton. 즐겨찾기 핀버튼
    /// - Author: 남정은(dlsl7080@gmail.com)
    @IBAction func updateBookmark(_ sender: UIButton) {
        sender.tintColor = sender.tintColor == UIColor.init(named: "lightGrayNonSelectedColor") ? UIColor.init(named: "blackSelectedColor") : UIColor.init(named: "lightGrayNonSelectedColor")
        
        if bookmarks.keys.contains(sender.tag) {
            if let isBookmarked = bookmarks[sender.tag] {
                bookmarks[sender.tag] = !isBookmarked
            }
        }
    }
    
    
    /// 게시판 정보를 불러옵니다.
    /// - Author: 남정은(dlsl7080@gmail.com)
    private func fetchBoardList() {
        DispatchQueue.global().async {
            guard let url = URL(string: "https://board1104.azurewebsites.net/api/board") else { return }
            
            BoardDataManager.shared.session.dataTask(with: url) { data, resposne, error in
    
                if let error = error {
                    print(error)
                    return
                }
                
                guard let response = resposne as? HTTPURLResponse, response.statusCode == 200 else {
                    return
                }
                
                guard let data = data else {
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let res = try decoder.decode(BoardDtoResponseData.self, from: data)
                    
                    if res.resultCode == ResultCode.ok.rawValue {
                        self.boardList = res.list
                        
                        DispatchQueue.main.async {
                            self.boardListTableView.reloadData()
                        }
                    }
                } catch {
                    print(error)
                }
            }.resume()
        }
    }
    
    
    /// 사용자가 스크랩한 게시글 목록을 불러옵니다.
    /// - Parameter userId: 사용자 Id
    /// - Author: 남정은(dlsl7080@gmail.com)
    private func fetchScrapPostList(userId: String) {
        guard let url = URL(string:"https://board1104.azurewebsites.net/api/scrapPost/?userId=\(userId)") else { return }
        
        BoardDataManager.shared.session.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let data = try decoder.decode(PostListDtoResponseData.self, from: data)
           
                if data.resultCode == ResultCode.ok.rawValue {
                    self.scrapPostList = data.list
                }
            } catch {
                print(error)
            }
        }.resume()
    }
    
    
    /// 강의정보 화면에서 게시판목록 화면으로 돌아올 때 사용합니다.
    /// - Parameter unwindSegue: DetailLectureReviewViewController -> BoardViewController
    /// - Author: 남정은(dlsl7080@gmail.com)
    @IBAction func unwindToBoard(_ unwindSegue: UIStoryboardSegue) {
    }
    
    
    /// 지정된 식별자의 segue의 실행여부를 결정합니다.
    /// - Parameters:
    ///   - identifier: segue의 식별자
    ///   - sender: segue가 시작된 객체
    /// - Returns: segue를 실행하길 원한다면 true, 아니라면 false
    /// - Author: 남정은(dlsl7080@gmail.com)
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if let cell = sender as? UITableViewCell, let indexPath = boardListTableView.indexPath(for: cell) {
            // 강의 평가 게시판과 정보 게시판은 performSegue를 이용
            if indexPath == IndexPath(row: 5, section: 1) || indexPath == IndexPath(row: 0, section: 3) {
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
    ///   - Author: 남정은(dlsl7080@gmail.com)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "infoSegue", let vc = segue.destination as? FreeBoardViewController {
            vc.selectedBoard = boardList.first(where: { $0.boardId == 11 })
        }
        
        if let cell = sender as? UITableViewCell,
           let indexPath = boardListTableView.indexPath(for: cell),
           let firstBoardinSection = boardList.first(where: { $0.section == indexPath.section }) {
            
            let selectedBoard = boardList.first(where: { $0.boardId == indexPath.row + firstBoardinSection.boardId })
            
            if let vc = segue.destination as? FreeBoardViewController {
                vc.selectedBoard = selectedBoard
            }
            else if let vc = segue.destination as? CategoryBoardViewController {
                vc.selectedBoard = selectedBoard
            }
        }
    }
    
    
    /// 뷰 컨트롤러의 뷰 계층이 메모리에 올라간 뒤 호출됩니다.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchBoardList()
        
        // 커스텀 테이블 뷰 헤더 등록
        let headerNib = UINib(nibName: "BoardCustomHeader", bundle: nil)
        boardListTableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "sectionHeader")
        
        // 게시판 목록 section별로 펼치고 접는 동작
        let token = NotificationCenter.default.addObserver(forName: .expandOrFoldSection, object: nil, queue: .main) { [weak self] noti in
            if let section = noti.userInfo?["section"] as? Int {
                guard let self = self else { return }
                
                var indexPathArr = [IndexPath]()
                
                let expandableBoardList = self.boardList.filter { $0.section == section }
                
                // expandableBoard의 각 게시판에 대한 indexPath를 배열로 추가
                for row in expandableBoardList.indices {
                    let indexPath = IndexPath(row: row, section: section)
                    indexPathArr.append(indexPath)
                }
                
                // isExpanded가 true라면 펼친 상태
                if expandableArray[section] {
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
        
        for board in boardList {
            bookmarks[board.section * 100 + board.boardId] = false
        }
    }
}



/// 게시판 목록
/// - Author: 남정은(dlsl7080@gmail.com)
extension BoardViewController: UITableViewDataSource {
    /// 게시판 그룹 수를 리턴합니다.
    /// - Parameter tableView: 게시판 목록 테이블 뷰
    /// - Returns: section 수
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    
    /// 하나의 그룹 안에 들어갈 게시판의 개수를 리턴합니다.
    /// - Parameters:
    ///   - tableView: 게시판 목록 테이블 뷰
    ///   - section: 테이블 뷰의 section을 구분하는 index number
    /// - Returns: section안에 나타낼 row수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionBoardList = boardList.filter({ $0.section == section})
        
        if section >= 2 {
            return expandableArray[section] ? sectionBoardList.count : 0
        }
        return sectionBoardList.count
    }
    
 
    /// 각각의 게시판 셀을 구성합니다.
    /// - Parameters:
    ///   - tableView: 게시판 목록 테이블 뷰
    ///   - indexPath: 게시판 셀의 indexPath
    /// - Returns: 게시판 셀
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let filteredBoardList = boardList.filter { $0.section == indexPath.section }
        
        if indexPath.section < 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NonExpandableBoardTableViewCell", for: indexPath) as! NonExpandableBoardTableViewCell
            
            cell.configure(boardList: filteredBoardList, indexPath: indexPath, bookmarks: bookmarks)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpandableBoardTableViewCell", for: indexPath) as! ExpandableBoardTableViewCell
        
        cell.configure(boardList: filteredBoardList, indexPath: indexPath, bookmarks: bookmarks)
        return cell
    }
}



/// 게시판 목록 테이블 뷰 동작 처리
/// - Author: 남정은(dlsl7080@gmail.com)
extension BoardViewController: UITableViewDelegate {
    /// 지정된 셀을 선택 시에 '강의 평가 게시판' 혹은 '정보 게시판'으로 이동합니다.
    /// - Parameters:
    ///   - tableView: 게시판 목록 테이블 뷰
    ///   - indexPath: 게시판 셀의 indexPath
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 강의평가 게시판으로 이동
        if indexPath.section == 1 && indexPath.row == 5 {
            performSegue(withIdentifier: "lectureSegue", sender: self)
        }
        // 정보 게시판으로 이동
        else if indexPath.section == 3 && indexPath.row == 0 {
            performSegue(withIdentifier: "infoSegue", sender: self)
        }
    }
    
    
    /// 특정 section에 사용할 header의 높이를 설정합니다.
    /// - Parameters:
    ///   - tableView: 게시판 목록 테이블 뷰
    ///   - section: 테이블 뷰의 section을 구분하는 index number
    /// - Returns: header의 높이
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
    
    
    /// 게시판 그룹의 section header를 설정합니다.
    /// - Parameters:
    ///   - tableView: 게시판 목록 테이블 뷰
    ///   - section: 테이블 뷰의 section을 구분하는 index number
    /// - Returns: 게시판 그룹을 묶는 헤더 뷰
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section >= 2 {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "sectionHeader") as! BoardCustomHeaderView
            
            headerView.backView.backgroundColor = .systemBackground
            headerView.configure(section: section, boardList: boardList)
            return headerView
        }
        let header = UIView()
        return header
    }
}


