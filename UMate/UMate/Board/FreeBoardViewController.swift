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
/// - Author: 김정민, 남정은(dlsl7080@gmail.com)
class FreeBoardViewController: CommonViewController {
    /// 선택된 게시판의 게시글 목록 테이블 뷰
    @IBOutlet weak var postListTableView: UITableView!
    
    /// 게시글 작성 버튼
    /// - Author: 김정민
    @IBOutlet weak var composeButton: UIButton!
    
    /// 선택된 게시판
    var selectedBoard: Board?
    
    
    /// 검색 버튼을 눌렀을 시에 SearchViewController로 이동합니다.
    /// - Parameter sender: 검색 버튼
    /// - Author: 남정은(dlsl7080@gmail.com)
    @IBAction func showSearchViewController(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "searchSegue", sender: self)
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
                vc.selectedPost = selectedBoard?.posts[indexPath.row]
            }
        }
        // 검색 버튼 클릭 시 선택된 게시판에 대한 정보 전달
        else if segue.identifier == "searchSegue", let vc = segue.destination as? SearchViewController {
            vc.selectedBoard = selectedBoard
        }
    }
    
    
    /// 뷰 컨트롤러의 뷰 계층이 메모리에 올라간 뒤 호출됩니다.
    override func viewDidLoad() {
        super.viewDidLoad()

        // 스크랩 게시판에 게시글 작성 버튼을 숨김
        // - Author: 김정민
        if selectedBoard?.boardTitle == "스크랩" {
            composeButton.isHidden = true
        }

        // 글쓰기 버튼의 테마 설정
        // - Author: 김정민(kimjm010@icloud.com)
        composeButton.setToEnabledButtonTheme()

        // 네비게이션 바에 타이틀 초기화
        self.navigationItem.title = selectedBoard?.boardTitle
        
        // 상세 게시글 화면에서 스크랩 버튼 클릭 시 스크랩 게시판에 게시글 추가
        var token = NotificationCenter.default.addObserver(forName: .postDidScrap, object: nil, queue: .main) { noti in
            
            if let scrappedPost = noti.userInfo?["scrappedPost"] as? Post {
                scrapBoard.posts.insert(scrappedPost, at: 0)
            }
        }
        tokens.append(token)
        
        
        // 상세 게시글 화면에서 스크랩 버튼 취소 시 스크랩 게시판에 게시글 삭제
        token = NotificationCenter.default.addObserver(forName: .postCancelScrap, object: nil, queue: .main) {
            [weak self] noti in
            guard let self = self else { return }
            
            if let unscrappedPost = noti.userInfo?["unscrappedPost"] as? Post {
                
                // 삭제하고 리로드
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



/// 기본 게시판 게시글 목록
/// - Author: 남정은(dlsl7080@gmail.com)
extension FreeBoardViewController: UITableViewDataSource {
    ///  게시글 수를 리턴합니다.
    /// - Parameters:
    ///   - tableView: 게시글 목록 테이블 뷰
    ///   - section: 게시글을 나누는 section
    /// - Returns: 게시글 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedBoard?.posts.count ?? 0
    }
    
    
    /// 게시글 목록 셀을 설정합니다.
    /// - Parameters:
    ///   - tableView: 게시글 목록 테이블 뷰
    ///   - indexPath: 게시글 목록 셀의 indexPath
    /// - Returns: 게시글 목록 셀
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FreeBoardTableViewCell", for: indexPath) as! FreeBoardTableViewCell
        
        guard let post = selectedBoard?.posts[indexPath.row] else { return cell }
        
        // 게시글 목록 셀 초기화
        cell.configure(post: post)
        return cell
    }
}
