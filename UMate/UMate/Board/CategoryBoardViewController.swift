//
//  CategoryBoardViewController.swift
//  CategoryBoardViewController
//
//  Created by 남정은 on 2021/08/03.
//


import UIKit


class CategoryBoardViewController: UIViewController {
    
    @IBOutlet weak var categoryListCollectionView: UICollectionView!
    
    @IBOutlet weak var categoryListTableView: UITableView!
    
    
    /// 검색 버튼을 눌렀을 시에 SearchViewController로 이동
    @IBAction func showSearchViewController(_ sender: Any) {
        performSegue(withIdentifier: "searchSegue", sender: self)
    }

    
    var selectedBoard: Board?
    var filteredPostList: [Post] = []
    var isSelected = true
    
    var tokens = [NSObjectProtocol]()
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let cell = sender as? UITableViewCell,
           let indexPath = categoryListTableView.indexPath(for: cell) {
            /// 상세 게시글 화면에 선택된 post에 대한 정보 전달
            if let vc = segue.destination as? DetailPostViewController {
                vc.selectedPost = filteredPostList[indexPath.row]
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
        
        /// 카테코리 별로 filtering되기 전 게시글배열 초기화
        filteredPostList = selectedBoard?.posts ?? []
        
        /// 스크랩 추가
        var token = NotificationCenter.default.addObserver(forName: .postDidScrap, object: nil, queue: .main) { noti in
            
            if let scrappedPost = noti.userInfo?["scrappedPost"] as? Post {
                scrapBoard.posts.insert(scrappedPost, at: 0)
            }
        }
        tokens.append(token)
        
        
        /// 스크랩 취소
        token = NotificationCenter.default.addObserver(forName: .postCancelScrap, object: nil, queue: .main) { noti in
            
            if let unscrappedPost = noti.userInfo?["unscrappedPost"] as? Post {
                
                /// 스크랩 게시판에서 삭제
                if let unscrappedPostIndex = scrapBoard.posts.firstIndex(where: { $0 === unscrappedPost }) {
                    scrapBoard.posts.remove(at: unscrappedPostIndex)
                }
            }
        }
        tokens.append(token)
    }
    
    
    deinit {
        for token in tokens {
            NotificationCenter.default.removeObserver(token)
            //            #if DEBUG
            //            print(#function,"categoryBoard")
            //            #endif
        }
    }
}




extension CategoryBoardViewController: UICollectionViewDataSource {
    /// 각 게시판이 가진 카테고리 수 만큼 지정해줌
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedBoard?.categoryNumbers.count ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryBoardCollectionViewCell",
                                                      for: indexPath) as! CategoryBoardCollectionViewCell
        
        guard let categoryNames = selectedBoard?.categoryNames else { return cell }
        
        if indexPath.row == 0 {
            /// 아무것도 선택되지 않았을 시에 row == 0 인 cell 선택된 것처럼 보이도록
            if isSelected {
                cell.categoryView.backgroundColor = UIColor.init(named: "blackSelectedColor")
            }
            /// 다른 카테고리 선택시
            else {
                cell.categoryView.backgroundColor = UIColor.init(named: "barColor")
            }
        }
        
        cell.configure(categoryNames: categoryNames, indexPath: indexPath)
        return cell
    }
}




extension CategoryBoardViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        /// 다른 카테고리 선택시에 row == 0 인 cell리로드
        if isSelected {
            isSelected = false
            collectionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
        }
        
        return true
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        filteredPostList.removeAll()
        
        guard let selectedBoard = selectedBoard else { return }
        
        /// 전체 카테고리 이외일 경우 true
        var isFiltering: Bool {
            return indexPath.row != 0
        }
        
        if isFiltering {
            /// 선택한 카테고리에 해당하는 게시물만 표시
            filterPostByCategory(in: selectedBoard, indexPath: indexPath)
        } else {
            /// 모든 게시물 표시
            filteredPostList = selectedBoard.posts
        }
        
        categoryListTableView.reloadData()
    }
    
    
    /// 게시글들을 카테고리별로 분류하여 배열에 저장하는 메소드
    /// - Parameters:
    ///   - selectedBoard: 선택된 게시판
    ///   - indexPath: 선택된 카테고리의 indexPath
    private func filterPostByCategory(in selectedBoard: Board, indexPath: IndexPath) {
        
        filteredPostList = selectedBoard.posts.filter({ post in
            return post.categoryRawValue == selectedBoard.categoryNumbers[indexPath.row]
        })
    }
}




extension CategoryBoardViewController: UICollectionViewDelegateFlowLayout {
    
    /// cell의 size를 delegate에게 알려줌
    /// 이 메소드가 cellForRowAt보다 먼저 실행됨.
    /// - Parameters:
    ///   - collectionView: flow layout을 나타낼 collectionView
    ///   - collectionViewLayout: 정보를 요청하는 layout 객체
    ///   - indexPath: item의 indexPath
    /// - Returns: 지정된 item의 size
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return .zero
        }
        
        let width:CGFloat
        guard let categoryCount = selectedBoard?.categoryNumbers.count else { return .zero }
        
        /// cell의 inset을 제외한 너비
        let withoutInsetWidth = view.frame.width -
                                    (flowLayout.minimumInteritemSpacing * CGFloat((categoryCount - 1))
                                        + flowLayout.sectionInset.left
                                        + flowLayout.sectionInset.right)
        
        /// cell의 개수가 3일 경우
        if categoryCount == 3 {
            width = withoutInsetWidth / 3
            return CGSize(width: width, height: 50)
        }
        /// cell의 개수가 4일 경우
        else if categoryCount == 4 {
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




extension CategoryBoardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filteredPostList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FreeBoardTableViewCell",
                                                 for: indexPath) as! FreeBoardTableViewCell
        
        let post = filteredPostList[indexPath.row]
        
        cell.configure(post: post)
        return cell
    }
}
