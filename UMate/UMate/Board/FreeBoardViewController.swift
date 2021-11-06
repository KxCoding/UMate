//
//  FreeBoardViewController.swift
//  FreeBoardViewController
//
//  Created by 남정은 on 2021/07/21.
//

import UIKit
import CoreMedia
import CoreMIDI


/// 기본 게시판 뷰 컨트롤러
/// - Author: 김정민(kimjm010@icloud.com), 남정은(dlsl7080@gmail.com)
class FreeBoardViewController: CommonViewController {
    /// 선택된 게시판의 게시글 목록 테이블 뷰
    @IBOutlet weak var postListTableView: UITableView!
    
    /// 게시글 작성 버튼
    @IBOutlet weak var composeButton: UIButton!
    
    /// 선택된 게시판
    var selectedBoard: BoardDtoResponseData.BoardDto?
    
    /// 게시판 indexPath
    /// indexPath를 통해 게시글 작성할 수 있는 버튼을 조절합니다.
    var index: IndexPath?
    
    /// 게시글 목록
    var postList = [PostListDtoResponseData.PostDto]()
    
    /// 검색 버튼을 눌렀을 시에 SearchViewController로 이동합니다.
    /// - Parameter sender: 검색 버튼
    /// - Author: 남정은(dlsl7080@gmail.com)
    @IBAction func showSearchViewController(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "searchSegue", sender: self)
    }
    
    
    /// 게시판에 해당하는 게시글 목록을 불러옵니다.
    /// - Parameters:
    ///   - boardId: 게시판 Id
    ///   - userId: 사용자 Id
    /// - Author: 남정은(dlsl7080@gmail.com)
    private func fetchPostList(boardId: Int, userId: String) {
        DispatchQueue.global().async {
            guard let url = URL(string: "https://board1104.azurewebsites.net/api/boardPost?boardId=\(boardId)&userId=\(userId)") else { return }
            
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
                    let res = try decoder.decode(PostListDtoResponseData.self, from: data)
                    
                    if res.resultCode == ResultCode.ok.rawValue {
                        self.postList = res.list
                        
                        DispatchQueue.main.async {
                            self.postListTableView.reloadData()
                        }
                    }
                } catch {
                    print(error)
                }
            }.resume()
        }
    }
    
   
    /// 게시글을 선택하거나 검색을 할 경우에 데이터를 전달합니다.
    /// - Parameters:
    ///   - segue: 호출된 segue
    ///   - sender: segue가 시작된 객체
    /// - Author: 남정은(dlsl7080@gmail.com)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let cell = sender as? UITableViewCell,
           let indexPath = postListTableView.indexPath(for: cell) {
            // 상세 게시글 화면에 선택된 게시글에 대한 정보 전달
            if let vc = segue.destination as? DetailPostViewController {
                vc.selectedPostId = postList[indexPath.row].postId
            }
        }
        // 검색 버튼 클릭 시 선택된 게시판에 대한 정보 전달
        else if segue.identifier == "searchSegue", let vc = segue.destination as? SearchViewController {
            vc.postList = postList
            
        }
        // 글 쓰기 버튼 클릭시 선택된 board 및 카테고리 정보 전달
        else if segue.identifier == "composeSegue", let vc = segue.destination.children.first as? ComposeViewController {
         
            guard let selectedBoard = selectedBoard else { return }
            vc.selectedBoard = selectedBoard
            vc.categoryList = selectedBoard.categories
        }
    }
    
    
    /// 뷰 컨트롤러의 뷰 계층이 메모리에 올라간 뒤 호출됩니다.
    override func viewDidLoad() {
        super.viewDidLoad()
   
        #warning("사용자 수정")
        fetchPostList(boardId: selectedBoard?.boardId ?? 1, userId: "6c1c72d6-fa9b-4af6-8730-bb98fded0ad8")
        
        if let boardId = selectedBoard?.boardId, boardId <= 4 {
            composeButton.isHidden = true
        }

        composeButton.setToEnabledButtonTheme()

        // 네비게이션 바에 타이틀 초기화
        self.navigationItem.title = selectedBoard?.name
        
        // 스크랩 취소하면 스크랩 게시판에서 삭제
        var token = NotificationCenter.default.addObserver(forName: .postCancelScrap, object: nil, queue: .main) { [weak self] noti in
            guard let self = self else { return }
            guard self.selectedBoard?.boardId == 3 else { return }
            if let unscrappedPostId = noti.userInfo?["postId"] as? Int,
               let index = self.postList.firstIndex(where: { $0.postId == unscrappedPostId }) {
                self.postList.remove(at: index)
                self.postListTableView.reloadData()
            }
        }
        tokens.append(token)
        
        // 일반 게시판에 게시글 추가
        token = NotificationCenter.default.addObserver(forName: .newPostInsert, object: nil, queue: .main) { [weak self] noti in
            guard let self = self else { return }
            if let post = noti.userInfo?["newPost"] as? PostListDtoResponseData.PostDto,
               let board = self.selectedBoard {
                if board.categories.isEmpty {
                    self.postList.insert(post, at: 0)
                    self.postListTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                }
            }
        }
        tokens.append(token)
    }
}



/// 기본 게시판 게시글 목록
/// - Author: 남정은(dlsl7080@gmail.com)
extension FreeBoardViewController: UITableViewDataSource {
    ///  게시글 수를 리턴합니다.
    /// - Parameters:
    ///   - tableView: 게시글 목록 테이블 뷰
    ///   - section: 게시글을 나누는 section index
    /// - Returns: 게시글 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postList.count
    }
    
    
    /// 게시글 목록 셀을 설정합니다.
    /// - Parameters:
    ///   - tableView: 게시글 목록 테이블 뷰
    ///   - indexPath: 게시글 목록 셀의 indexPath
    /// - Returns: 게시글 목록 셀
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FreeBoardTableViewCell", for: indexPath) as! FreeBoardTableViewCell
        
        let post = postList[indexPath.row]
        
        // 게시글 목록 셀 초기화
        cell.configure(post: post)
        return cell
    }
}
