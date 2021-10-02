//
//  SearchViewController.swift
//  SearchViewController
//
//  Created by 남정은 on 2021/08/09.
//

import UIKit


/// 검색화면에 대한 클래스
/// - Author: 남정은(dlsl7080@gmail.com)
class SearchViewController: UIViewController {
    /// 검색된 게시글을 보여줄 테이블 뷰
    @IBOutlet weak var postListTableView: UITableView!
    
    /// 서치 바와의 상호작용을 기반으로 검색 결과 화면을 관리하는 뷰 컨트롤러
    let searchController = UISearchController(searchResultsController: nil)
    
    /// 검색 문자열을 일시적으로 저장할 속성
    var cachedText: String?
    
    /// 선택된 게시판
    var selectedBoard: Board?
    
    /// 검색어에 따라서 필터링한 게시글을 담을 배열
    var filteredPostList: [Post] = []
    
    
    /// 검색된 게시물을 클릭했을 때 데이터 전달
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
        
        // 서치바 초기화
        setupSearchBar()
        
        //검색 전에는 테이블 뷰 표시 안함
        postListTableView.alpha = 0
    }
    
    
    /// serach controller 초기화
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



/// 서치 바에 대한 동작 처리
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // 검색 시작 시 tableView 표시
        postListTableView.alpha = 1
        
        guard let posts = selectedBoard?.posts else { return }
        
        // 검색 결과에 따라서 필터링 된 게시물을 배열에 저장
        filteredPostList = posts.filter({ post in
            return post.postTitle.lowercased().contains(searchText.lowercased()) ||
                post.postContent.lowercased().contains(searchText.lowercased())
        })
        
        // 검색 텍스트를 저장
        cachedText = searchText
        postListTableView.reloadData()
    }
    
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        // 검색 텍스트가 있고, 검색 결과가 있다면 검색내용 유지
        if let text = cachedText, !(text.isEmpty || filteredPostList.isEmpty) {
            searchController.searchBar.text = text
        }
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // 리턴 버튼 눌렀을 시에 검색 종료
        searchController.isActive = false
    }
}



/// 검색 리스트를 나타냄
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 필터링된 게시글 수 리턴
        return filteredPostList.count
    }
    
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FreeBoardTableViewCell", for: indexPath) as! FreeBoardTableViewCell
        
        let post = filteredPostList[indexPath.row]
        
        cell.configure(post: post)
        return cell
    }
}




