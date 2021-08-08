//
//  SearchViewController.swift
//  SearchViewController
//
//  Created by 남정은 on 2021/08/09.
//

import UIKit

/* TODO: -
 1. search controller extension으로 빼기.
 2. return button 눌렀을 시에 검색되도록
 3. 검색된 테이블 뷰 셀 클릭 시에 detailPost 보여주기
 */

class SearchViewController: UIViewController {

    @IBOutlet weak var postListTableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var selectedBoard: Board?
    
    var filteredPostList: [Post] = []
    
    var cachedText: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSearchBar()
        
        postListTableView.alpha = 0
    }
    
    
    func setupSearchBar() {
        self.definesPresentationContext = true
        self.navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "검색어를 입력해주세요."
        searchController.searchBar.showsCancelButton = false
    }
}




extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        postListTableView.alpha = 1
        
        guard let posts = selectedBoard?.posts else { return }

        filteredPostList = posts.filter({ post in
            return post.postTitle.lowercased().contains(searchText.lowercased()) ||
            post.postContent.lowercased().contains(searchText.lowercased())
        })

        cachedText = searchText
        postListTableView.reloadData()
    }


    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if let text = cachedText, !(text.isEmpty || filteredPostList.isEmpty) {
            searchController.searchBar.text = text
        }
    }
}




extension SearchViewController: UITableViewDataSource {
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
