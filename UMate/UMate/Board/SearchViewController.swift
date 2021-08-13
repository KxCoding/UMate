//
//  SearchViewController.swift
//  SearchViewController
//
//  Created by 남정은 on 2021/08/09.
//

import UIKit

/* TODO: -
 1. search controller extension으로 빼기.
 */

class SearchViewController: UIViewController {
    
    @IBOutlet weak var postListTableView: UITableView!
    
    var tableViewHeaderView: UIView = {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 5))
        return headerView
    }()
    
    /// search bar와의 상호작용을 기반으로 검색 결과 화면을 관리하는 view controller
    let searchController = UISearchController(searchResultsController: nil)
    var cachedText: String?
    
    var selectedBoard: Board?
    var filteredPostList: [Post] = []
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell,
           let indexPath = postListTableView.indexPath(for: cell) {
            
            if let vc = segue.destination as? DetailPostViewController {
                vc.selectedPost = filteredPostList[indexPath.row]
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postListTableView.tableHeaderView = tableViewHeaderView
        
        setupSearchBar()
        
        ///검색 전에는 tableView 표시 안함
        postListTableView.alpha = 0
    }
    
    
    /// serach controller 초기화하는 메소드
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
    
    /// search text가 변경될 때마다 호출되는 메소드
    /// - Parameters:
    ///   - searchBar: 편집되고 있는 search bar
    ///   - searchText: search textField의 현재 text
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        /// 검색 시작시 tableView 표시
        postListTableView.alpha = 1
        
        guard let posts = selectedBoard?.posts else { return }
        
        /// 검색 결과에 따라서 필터링 된 게시물을 배열에 저장
        filteredPostList = posts.filter({ post in
            return post.postTitle.lowercased().contains(searchText.lowercased()) ||
                post.postContent.lowercased().contains(searchText.lowercased())
        })
        
        /// 검색 텍스트를 저장
        cachedText = searchText
        postListTableView.reloadData()
    }
    
    
    /// search text editing이 끝났을 시에 호출되는 메소드
    /// - Parameter searchBar: 편집되는 search bar
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        /// 검색 텍스트가 있고, 검색 결과가 있다면 검색내용 유지
        if let text = cachedText, !(text.isEmpty || filteredPostList.isEmpty) {
            searchController.searchBar.text = text
        }
    }
    
    
    /// 검색버튼 혹은 return 버튼을 눌렀을 시에 호출되는 메소드
    /// - Parameter searchBar: The search bar that was tapped.
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        /// 리턴 버튼 눌렀을 시에 검색 종료
        searchController.isActive = false
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




