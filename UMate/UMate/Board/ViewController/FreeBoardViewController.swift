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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell, let indexPath = postListTableView.indexPath(for: cell) {
            if let vc = segue.destination as? DetailPostViewController {
                vc.selectedPost = selectedBoard?.posts[indexPath.row]
            }
        }
    }
    
    var tokens = [NSObjectProtocol]()
    var newPostToken: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = selectedBoard?.boardTitle
        
        composeContainerView.layer.cornerRadius = composeContainerView.frame.height / 2
        
        var token = NotificationCenter.default.addObserver(forName: .postDidScrap, object: nil, queue: .main) { noti in
            
            if let scrappedPost = noti.userInfo?["scrappedPost"] as? Post {
                scrappedPost.isScrapped = true
                scrapBoard.posts.insert(scrappedPost, at: 0)
            }
        }
        tokens.append(token)
        
        //스크랩 버튼을 취소하면 스크랩게시판에서 게시물 빼주어야함.
        //false인 애들이 전달됨.
        token = NotificationCenter.default.addObserver(forName: .postCancelScrap, object: nil, queue: .main) { [weak self] noti in
            guard let self = self else { return }
            
            if let unscrappedPost = noti.userInfo?["unscrappedPost"] as? Post {
                
                //삭제하고 리로드
                if let unscrappedPostIndex = scrapBoard.posts.firstIndex(where: { $0 === unscrappedPost }) {
                    unscrappedPost.isScrapped = false
                    scrapBoard.posts.remove(at: unscrappedPostIndex)
                    self.postListTableView.reloadData()
                }
            }
        }
        tokens.append(token)
        
        NotificationCenter.default.addObserver(forName: ComposeViewController.newPostInsert, object: nil, queue: .main) { [weak self] noti in
            self?.postListTableView.reloadData()
        }
    }
    
    deinit {
        for token in tokens {
            NotificationCenter.default.removeObserver(token)
        }
        
        if let token = newPostToken {
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
        
        cell.configure(post: post)
        return cell
        
    }
}
