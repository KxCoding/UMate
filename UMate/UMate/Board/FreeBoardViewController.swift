//
//  FreeBoardViewController.swift
//  FreeBoardViewController
//
//  Created by 남정은 on 2021/07/21.
//

import UIKit
import CoreMedia
import CoreMIDI


/// 기본 게시판에 관한 클래스
/// - Author: 김정민, 남정은
class FreeBoardViewController: RemoveObserverViewController {
    /// 선택된 게시판의 게시글 목록을 나타내는 테이블 뷰
    /// - Author: 남정은
    @IBOutlet weak var postListTableView: UITableView!
    
    /// 게시글 작성 버튼
    /// - Author: 김정민
    @IBOutlet weak var composeButton: UIButton!
    
    /// 선택된 게시판
    /// - Author: 남정은
    var selectedBoard: Board?
    
    
    /// 검색 버튼을 눌렀을 시에 SearchViewController로 이동
    /// - Author: 남정은
    @IBAction func showSearchViewController(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "searchSegue", sender: self)
    }
    
    
    /// 게시글을 선택하거나 검색을 할 경우에 데이터 전달
    /// - Author: 남정은
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let cell = sender as? UITableViewCell,
           let indexPath = postListTableView.indexPath(for: cell) {
            /// 상세 게시글 화면에 선택된 게시글에 대한 정보 전달
            if let vc = segue.destination as? DetailPostViewController {
                vc.selectedPost = selectedBoard?.posts[indexPath.row]
            }
        }
        
        /// 검색 버튼 클릭시 선택된 게시판에 대한 정보 전달
        else if segue.identifier == "searchSegue", let vc = segue.destination as? SearchViewController {
            vc.selectedBoard = selectedBoard
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// 스크랩 게시판에 게시글 작성 버튼을 숨김
        /// - Author: 김정민(kimjm010@icloud.com)
        if selectedBoard?.boardTitle == "스크랩" {
            composeButton.isHidden = true
        }
        
        /// 글쓰기 버튼의 테마 설정
        /// - Author: 김정민(kimjm010@icloud.com)
        composeButton.setButtonTheme()

        /// 네비게이션 바에 타이틀 초기화
        /// - Author: 남정은
        self.navigationItem.title = selectedBoard?.boardTitle
        
        /// 상세 게시글 화면에서 스크랩 버튼 클릭시 스크랩 게시판에 게시글 추가
        /// - Author: 남정은
        var token = NotificationCenter.default.addObserver(forName: .postDidScrap, object: nil, queue: .main) { noti in
            
            if let scrappedPost = noti.userInfo?["scrappedPost"] as? Post {
                scrapBoard.posts.insert(scrappedPost, at: 0)
            }
        }
        tokens.append(token)
        
        
        /// 상세 게시글 화면에서 스크랩 버튼 취소시 스크랩 게시판에 게시글 삭제
        /// - Author: 남정은
        token = NotificationCenter.default.addObserver(forName: .postCancelScrap, object: nil, queue: .main) {
            [weak self] noti in
            guard let self = self else { return }
            
            if let unscrappedPost = noti.userInfo?["unscrappedPost"] as? Post {
                
                /// 삭제하고 리로드
                if let unscrappedPostIndex = scrapBoard.posts.firstIndex(where: { $0 === unscrappedPost }) {
                    scrapBoard.posts.remove(at: unscrappedPostIndex)
                    
                    self.postListTableView.reloadData()
                }
            }
        }
        tokens.append(token)
        
        
        token = NotificationCenter.default.addObserver(forName: .newPostInsert, object: nil, queue: .main, using: { [weak self] (noti) in
            if let newPost = noti.userInfo?["newPost"] as? Post {
                // 각 게시판에만 게시글이 추가될 수 있게 게시판 이름에 따라 분기하여 게시글을 저장
                switch self?.selectedBoard?.boardTitle {
                case "자유 게시판":
                    freeBoard.posts.insert(newPost, at: 0)
                case "인기글 게시판":
                    popularPostBoard.posts.insert(newPost, at: 0)
                case "졸업생 게시판":
                    graduateBoard.posts.insert(newPost, at: 0)
                case "신입생 게시판":
                    freshmanBoard.posts.insert(newPost, at: 0)
                default:
                    break
                }
                self?.postListTableView.reloadData()
            }
        })
        tokens.append(token)
    }
}



/// 기본게시판 형식의 테이블 뷰에대한 데이터소스
/// - Author: 남정은
extension FreeBoardViewController: UITableViewDataSource {
    /// 하나의 섹션안에 나타낼 row수를 지정
    /// - Parameters:
    ///   - tableView: 요청한 정보를 나타낼 객체
    ///   - section: 테이블 뷰의 섹션
    /// - Returns: 섹션안에 나타낼 row수
    /// - Author: 남정은
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedBoard?.posts.count ?? 0
    }
    
    
    /// 셀의 데이터소스를  테이블 뷰의 특정 위치에 추가하기위해 호출
    /// - Parameters:
    ///   - tableView: 요청한 정보를 나타낼 객체
    ///   - indexPath: 테이블 뷰의 row의 위치를 나타내는 인덱스패스
    /// - Returns: 구현을 완료한 셀
    /// - Author: 남정은
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FreeBoardTableViewCell", for: indexPath) as! FreeBoardTableViewCell
        
        guard let post = selectedBoard?.posts[indexPath.row] else { return cell }
        
        /// 게시글 목록에 대한 셀 초기화
        cell.configure(post: post)
        return cell
    }
}
