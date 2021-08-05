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
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var filteredPostList: [Post] = []
    
    var cachedText: String = ""
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell, let indexPath = postListTableView.indexPath(for: cell) {
            if let vc = segue.destination as? DetailPostViewController {
                vc.selectedPost = filteredPostList[indexPath.row]
            }
        }
    }
    
    var tokens = [NSObjectProtocol]()
    var newPostToken: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = selectedBoard?.boardTitle
        
        filteredPostList = selectedBoard?.posts ?? []
        
        setupSearchBar()
        
        composeContainerView.layer.cornerRadius = composeContainerView.frame.height / 2
        
        
        var token = NotificationCenter.default.addObserver(forName: .postDidScrap, object: nil, queue: .main) { noti in
            
            if let scrappedPost = noti.userInfo?["scrappedPost"] as? Post {
                scrapBoard.posts.insert(scrappedPost, at: 0)
            }
        }
        tokens.append(token)
        
        
        token = NotificationCenter.default.addObserver(forName: .postCancelScrap, object: nil, queue: .main) { [weak self] noti in
            guard let self = self else { return }
            
            if let unscrappedPost = noti.userInfo?["unscrappedPost"] as? Post {
                
                //삭제하고 리로드
                if let unscrappedPostIndex = scrapBoard.posts.firstIndex(where: { $0 === unscrappedPost }) {
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
    
    func setupSearchBar() {
        self.definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "검색어를 입력해주세요."
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




extension FreeBoardViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(#function)
        guard let posts = selectedBoard?.posts else { return }
        filteredPostList = posts.filter({ post in
            return post.postTitle.lowercased().contains(searchText.lowercased()) ||
            post.postContent.lowercased().contains(searchText.lowercased())
        })
        
        if let text = searchBar.text, text.isEmpty && filteredPostList.isEmpty {
            filteredPostList = selectedBoard?.posts ?? []
        }
        
        cachedText = searchText
        postListTableView.reloadData()
        print(filteredPostList.count)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if !cachedText.isEmpty && !filteredPostList.isEmpty {
            searchController.searchBar.text = cachedText
        }
    }
}



extension FreeBoardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPostList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FreeBoardTableViewCell", for: indexPath) as! FreeBoardTableViewCell
        
        let post = filteredPostList[indexPath.row]
        
        cell.configure(post: post)
        return cell
        
    }
}
