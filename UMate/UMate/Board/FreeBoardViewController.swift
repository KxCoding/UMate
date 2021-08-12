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
    
    
    @IBAction func showSearchViewController(_ sender: UIBarButtonItem) {
    
        performSegue(withIdentifier: "searchSegue", sender: self)
    }
    
    var filteredPostList: [Post] = []
    
    var tableViewHeaderView: UIView = {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 5))
        return headerView
    }()

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let cell = sender as? UITableViewCell,
           let indexPath = postListTableView.indexPath(for: cell) {
            
            if let vc = segue.destination as? DetailPostViewController {
                vc.selectedPost = filteredPostList[indexPath.row]
            }
            
        } else if segue.identifier == "searchSegue", let vc = segue.destination as? SearchViewController {
            vc.selectedBoard = selectedBoard
        }
    }
    
    
    var tokens = [NSObjectProtocol]()
    var newPostToken: NSObjectProtocol?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = selectedBoard?.boardTitle
        postListTableView.tableHeaderView = tableViewHeaderView
        composeContainerView.layer.cornerRadius = composeContainerView.frame.height / 2
        
        let navigationBarImage = getImage(withColor: UIColor.white, andSize: CGSize(width: 10, height: 10))
        navigationController?.navigationBar.setBackgroundImage(navigationBarImage, for: .default)
        navigationController?.navigationBar.shadowImage = navigationBarImage
        
        filteredPostList = selectedBoard?.posts ?? []
        
        var token = NotificationCenter.default.addObserver(forName: .postDidScrap, object: nil, queue: .main) { noti in
            
            if let scrappedPost = noti.userInfo?["scrappedPost"] as? Post {
                scrapBoard.posts.insert(scrappedPost, at: 0)
            }
        }
        tokens.append(token)
        
        
        token = NotificationCenter.default.addObserver(forName: .postCancelScrap, object: nil, queue: .main) {
            [weak self] noti in
            guard let self = self else { return }
            
            if let unscrappedPost = noti.userInfo?["unscrappedPost"] as? Post {
                
                //삭제하고 리로드
                if let unscrappedPostIndex = scrapBoard.posts.firstIndex(where: { $0 === unscrappedPost }) {
                    scrapBoard.posts.remove(at: unscrappedPostIndex)
                    
                    if self.selectedBoard?.boardTitle == scrapBoard.boardTitle {
                        self.filteredPostList = scrapBoard.posts
                    }
                    
                    self.postListTableView.reloadData()
                }
            }
        }
        tokens.append(token)
        
        newPostToken = NotificationCenter.default.addObserver(forName: .newPostInsert, object: nil, queue: .main) {
            [weak self] noti in
            if let newPost = noti.userInfo?["newPost"] as? Post {
                self?.filteredPostList.insert(newPost, at: 0)
            }
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
        return filteredPostList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FreeBoardTableViewCell", for: indexPath) as! FreeBoardTableViewCell
        
        let post = filteredPostList[indexPath.row]
        
        cell.configure(post: post)
        return cell
    }
}




extension FreeBoardViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
}
