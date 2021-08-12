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
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = false
        //searchController.searchBar.endEditing(true)
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




