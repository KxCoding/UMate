//
//  FreeBoardViewController.swift
//  FreeBoardViewController
//
//  Created by 남정은 on 2021/07/21.
//

import UIKit


class FreeBoardViewController: UIViewController {
    
    var selectedBoard: Board?
    
    @IBOutlet weak var postListTableView: UITableView!
    @IBOutlet weak var composeContainerView: UIView!
    
    /// 검색 버튼을 눌렀을 시에 SearchViewController로 이동
    @IBAction func showSearchViewController(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "searchSegue", sender: self)
    }
    
    
    /// tableView header에 넣을 UIView
    var tableViewHeaderView: UIView = {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 5))
        return headerView
    }()
    
    
    var tokens = [NSObjectProtocol]()
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let cell = sender as? UITableViewCell,
           let indexPath = postListTableView.indexPath(for: cell) {
            /// 상세 게시글 화면에 선택된 post에 대한 정보 전달
            if let vc = segue.destination as? DetailPostViewController {
                vc.selectedPost = selectedBoard?.posts[indexPath.row]
            }
        }
        /// 검색 버튼 클릭시 선택된 board에 대한 정보 전달
        else if segue.identifier == "searchSegue", let vc = segue.destination as? SearchViewController {
            vc.selectedBoard = selectedBoard
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = selectedBoard?.boardTitle
        postListTableView.tableHeaderView = tableViewHeaderView
        composeContainerView.layer.cornerRadius = composeContainerView.frame.height / 2
        
        /// 네비게이션 바 초기화
        let navigationBarImage = getImage(withColor: UIColor.white, andSize: CGSize(width: 10, height: 10))
        navigationController?.navigationBar.setBackgroundImage(navigationBarImage, for: .default)
        navigationController?.navigationBar.shadowImage = navigationBarImage
        
        /// 상세 게시글 화면에서 스크랩 버튼 클릭시 스크랩 게시판에 게시글 추가
        var token = NotificationCenter.default.addObserver(forName: .postDidScrap, object: nil, queue: .main) { noti in
            
            if let scrappedPost = noti.userInfo?["scrappedPost"] as? Post {
                scrapBoard.posts.insert(scrappedPost, at: 0)
            }
        }
        tokens.append(token)
        
        
        /// 상세 게시글 화면에서 스크랩 버튼 취소시 스크랩 게시판에 게시글 삭제
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
        
        
        token = NotificationCenter.default.addObserver(forName: .newPostInsert, object: nil, queue: .main) {
            [weak self] noti in
            if let newPost = noti.userInfo?["newPost"] as? Post {
                self?.selectedBoard?.posts.insert(newPost, at: 0)
            }
            self?.postListTableView.reloadData()
        }
        tokens.append(token)
    }
    
    
    deinit {
        for token in tokens {
            NotificationCenter.default.removeObserver(token)
        }
    }
}




extension FreeBoardViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedBoard?.posts.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FreeBoardTableViewCell", for: indexPath) as! FreeBoardTableViewCell
        
        guard let post = selectedBoard?.posts[indexPath.row] else { return cell }
        
        /// 게시글 목록에 대한 cell 초기화
        cell.configure(post: post)
        return cell
    }
}




