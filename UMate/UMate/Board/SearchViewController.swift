//
//  SearchViewController.swift
//  SearchViewController
//
//  Created by 남정은 on 2021/08/09.
//

import UIKit


/// 검색화면에대한 클래스
/// - Author: 남정은
class SearchViewController: UIViewController {
    /// 검색된 게시글을 보여줄 테이블 뷰
    @IBOutlet weak var postListTableView: UITableView!
    
    /// 테이블 뷰와 네비게이션 바 사이의 여백을 조절하는 뷰
    var tableViewHeaderView: UIView = {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 5))
        return headerView
    }()
    
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
        postListTableView.tableHeaderView = tableViewHeaderView
        
        setupSearchBar()
        
        ///검색 전에는 테이블 뷰 표시 안함
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



/// 서치 바에대한 동작 처리
extension SearchViewController: UISearchBarDelegate {
    /// search text가 변경될 때마다 호출
    /// - Parameters:
    ///   - searchBar: 편집되고 있는 서치바
    ///   - searchText: search textField의 현재 텍스트
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // 검색 시작시 tableView 표시
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
    
    
    /// 검색어 입력이 끝났을 시에 호출
    /// - Parameter searchBar: 편집되는 서치바
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        /// 검색 텍스트가 있고, 검색 결과가 있다면 검색내용 유지
        if let text = cachedText, !(text.isEmpty || filteredPostList.isEmpty) {
            searchController.searchBar.text = text
        }
    }
    
    
    /// 검색버튼 혹은 리턴 버튼을 눌렀을 시에 호출
    /// - Parameter searchBar: 편집되는 서치바
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // 리턴 버튼 눌렀을 시에 검색 종료
        searchController.isActive = false
    }
}



/// 검색 리스트를 나타낼 테이블 뷰에대한 데이터소스
extension SearchViewController: UITableViewDataSource {
    // 필터링된 게시글 수 리턴
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPostList.count
    }
    
    
    // 필터링된 게시글 목록을 셀에 초기화
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FreeBoardTableViewCell", for: indexPath) as! FreeBoardTableViewCell
        
        let post = filteredPostList[indexPath.row]
        
        cell.configure(post: post)
        return cell
    }
}




