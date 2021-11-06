//
//  CategoryBoardViewController.swift
//  CategoryBoardViewController
//
//  Created by 남정은 on 2021/08/03.
//


import UIKit


/// 카테고리를 가진 게시판 뷰 컨트롤러
/// - Author: 남정은(dlsl7080@gmail.com), 김정민(kimjm010@icloud.com)
class CategoryBoardViewController: FreeBoardViewController {
    /// 카테고리 목록 컬렉션 뷰
    @IBOutlet weak var categoryListCollectionView: UICollectionView!
    
    /// 카테고리에 의해 필터링 된 게시글 목록
    var filteredPostList = [PostListDtoResponseData.PostDto]()
    
    /// 처음에 카테고리를 선택하지 않은 경우 '전체'카테고리를 선택된 상태로 보이기 위한 속성
    var isSelected = true
    
    /// 카테고리를 선택한 경우 true
    var isFiltering = false
    
    
    /// 뷰 컨트롤러의 뷰 계층이 메모리에 올라간 뒤 호출됩니다.
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // 카테고리 게시판에 게시글 추가
        let token = NotificationCenter.default.addObserver(forName: .newPostInsert, object: nil, queue: .main) { [weak self] noti in
            guard let self = self else { return }
            if let post = noti.userInfo?["newPost"] as? PostListDtoResponseData.PostDto,
               let board = self.selectedBoard {
                if !board.categories.isEmpty {
                    self.filteredPostList.insert(post, at: 0)
                    self.postList.insert(post, at: 0)
                    
                    self.postListTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                }
            }
        }
        tokens.append(token)
    }
}



/// 카테고리 게시판의 카테고리 목록
/// - Author: 남정은(dlsl7080@gmail.com)
extension CategoryBoardViewController: UICollectionViewDataSource {
    /// 게시글을 분류하는 카테고리 목록의 개수를 리턴합니다.
    /// - Parameters:
    ///   - collectionView: 카테고리 목록 컬렉션 뷰
    ///   - section: 카테고리를 나누는 section index
    /// - Returns: 카테고리의 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = selectedBoard?.categories.count {
            return count + 1
        }
        return 0
    }
    
    
    /// 카테고리 목록 셀을 설정합니다.
    /// - Parameters:
    ///   - collectionView: 카테고리 목록 컬렉션 뷰
    ///   - indexPath: 카테고리 셀의 indexPath
    /// - Returns: 카테고리 셀
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryBoardCollectionViewCell",
                                                      for: indexPath) as! CategoryBoardCollectionViewCell
        
        guard let categories = selectedBoard?.categories else { return cell }
        
        if indexPath.row == 0 {
            // 아무것도 선택되지 않았을 시에 row == 0인 셀이 선택된 것처럼 보이도록
            if isSelected {
                cell.categoryView.backgroundColor = UIColor.init(named: "blackSelectedColor")
            }
            // 다른 카테고리 선택 시
            else {
                cell.categoryView.backgroundColor = UIColor.init(named: "barColor")
            }
        }
        
        cell.configure(categories: categories, indexPath: indexPath)
        return cell
    }
}



/// 카테고리 목록 컬렉션 뷰 동작 처리
/// - Author: 남정은(dlsl7080@gmail.com)
extension CategoryBoardViewController: UICollectionViewDelegate {
    /// 컬렉션 뷰 셀을 클릭 시에 호출됩니다.
    ///
    /// 다른 카테고리 선택시에 row == 0 인 cell을 리로드하여 선택되지 않은 상태로 보여지게 합니다.
    /// - Parameters:
    ///   - collectionView: 카테고리 컬렉션 뷰
    ///   - indexPath: 카테고리 셀의 indexPath
    /// - Returns: 선택 허용 여부. true일 때는 선택이 되며, false일 때는 선택이 되지 않습니다.
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if isSelected {
            isSelected = false
            collectionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
        }
        return true
    }
    
    
    /// 카테고리를 선택 했을 경우 게시글을 필터링 합니다.
    /// - Parameters:
    ///   - collectionView: 카테고리 컬렉션 뷰
    ///   - indexPath: 카테고리 셀의 indexPath
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        filteredPostList.removeAll()
        guard let selectedBoard = selectedBoard else { return }
        
        isFiltering = indexPath.row != 0
        
        if isFiltering {
            // 선택한 카테고리에 해당하는 게시물만 표시
            filterPostByCategory(in: postList, categories: selectedBoard.categories, indexPath: indexPath)
        } else {
            // 모든 게시물 표시
            filteredPostList = postList
        }
        
        postListTableView.reloadData()
    }
    
    
    /// 게시글들을 카테고리 별로 분류하여 배열에 저장합니다.
    /// - Parameters:
    ///   - selectedBoard: 선택된 게시판
    ///   - indexPath: 선택된 카테고리의 indexPath
    ///   - Author: 남정은(dlsl7080@gmail.com)
    private func filterPostByCategory(in postList: [PostListDtoResponseData.PostDto], categories: [BoardDtoResponseData.BoardDto.Category], indexPath: IndexPath) {
        
        filteredPostList = postList.filter({ post in
            return post.categoryNumber == categories[indexPath.row - 1].categoryId
        })
    }
}



/// 카테고리 목록 컬렉션 뷰의 레이아웃 조정
/// - Author: 남정은(dlsl7080@gmail.com)
extension CategoryBoardViewController: UICollectionViewDelegateFlowLayout {
    /// 카테고리 셀의 size를 설정합니다.
    ///
    /// cellForRowAt보다 먼저 실행됩니다.
    /// - Parameters:
    ///   - collectionView: 카테고리 컬렉션 뷰
    ///   - collectionViewLayout: 컬렉션 뷰의 레이아웃 정보
    ///   - indexPath: 카테고리 셀의 indexPath
    /// - Returns: 카테고리 셀의 사이즈
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return .zero
        }
        
        // 셀의 너비
        let width:CGFloat
        
        // 카테고리 개수
        guard let categoryCount = selectedBoard?.categories.count else { return .zero }
        
        // 셀의 inset을 제외한 너비
        let withoutInsetWidth = view.frame.width -
        (flowLayout.minimumInteritemSpacing * CGFloat((categoryCount - 1))
         + flowLayout.sectionInset.left
         + flowLayout.sectionInset.right)
        
        // 셀의 개수가 3일 경우
        if categoryCount + 1 == 3 {
            width = withoutInsetWidth / 3
            return CGSize(width: width, height: 50)
        }
        // 셀의 개수가 4일 경우
        else if categoryCount + 1 == 4 {
            if indexPath.row == 0 || indexPath.row == 3 {
                width = withoutInsetWidth / 2 * 0.4
                return CGSize(width: width, height: 50)
                
            } else {
                width = withoutInsetWidth / 2 * 0.6
                return CGSize(width: width, height: 50)
            }
        }
        return .zero
    }
}



/// 카테고리 게시판 게시글 목록
/// - Author: 남정은(dlsl7080@gmail.com)
extension CategoryBoardViewController {
    ///  게시글 수를 리턴합니다.
    /// - Parameters:
    ///   - tableView: 게시글 목록  테이블 뷰
    ///   - section: 게시글을 나누는 section index
    /// - Returns: 게시글 개수
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredPostList.count
        }
        return postList.count
    }
    
    
    /// 게시글 목록 셀을 설정합니다.
    /// - Parameters:
    ///   - tableView: 게시글 목록  테이블 뷰
    ///   - indexPath: 게시글 목록 셀의 indexPath
    /// - Returns: 게시글 목록 셀
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FreeBoardTableViewCell",
                                                 for: indexPath) as! FreeBoardTableViewCell
        
        if isFiltering {
            var post = filteredPostList[indexPath.row]
            if let date = BoardDataManager.shared.decodingFormatter.date(from: post.createdAt) {
                let dateStr = date.relativeDate
                post.createdAt = dateStr
                cell.configure(post: post)
            }
            
        } else {
            var post = postList[indexPath.row]
            if let date = BoardDataManager.shared.decodingFormatter.date(from: post.createdAt) {
                let dateStr = date.relativeDate
                post.createdAt = dateStr
                cell.configure(post: post)
            }
        }
        
        return cell
    }
}
