//
//  CategoryBoardViewController.swift
//  CategoryBoardViewController
//
//  Created by 남정은 on 2021/08/03.
//


import UIKit


protocol SendDataDelegate {
    func sendData(data: [String])
}

/// 카테고리를 가진 게시판에대한 클래스
/// - Author: 남정은
class CategoryBoardViewController: RemoveObserverViewController {
    /// 카테고리 목록을 나타내는 컬렉션 뷰
    /// - Author: 남정은
    @IBOutlet weak var categoryListCollectionView: UICollectionView!
    
    /// 카테고리에 해당하는 게시글을 보여주는 테이블 뷰
    /// - Author: 남정은
    @IBOutlet weak var categoryListTableView: UITableView!
    
    /// 게시글 작성 버튼
    /// - Author: 김정민
    @IBOutlet weak var composeBtn: UIButton!
    
    /// 카테고리에 의해 필터링 된 게시글 목록을 담는 배열
    /// - Author: 남정은
    var filteredPostList: [Post] = []
    
    /// 선택된 게시판
    /// - Author: 남정은
    var selectedBoard: Board?
    
    /// 처음에 카테고리를 선택하지 않은 경우 '전체'카테고리를 선택된 상태로 보이기위한 속성
    /// - Author: 남정은
    var isSelected = true
    
    /// 게시판 카테고리 데이터 전달을 위한 속성
    /// - Author: 김정민(kimjm010@icloud.com)
    var sendDataDelegate: SendDataDelegate?
    
    
    /// 검색 버튼을 눌렀을 시에 SearchViewController로 이동
    /// - Author: 남정은
    @IBAction func showSearchViewController(_ sender: Any) {
        performSegue(withIdentifier: "searchSegue", sender: self)
    }
    
    
    @IBAction func composeCategoryBoard(_ sender: Any) {
        if let selectedCategoryList = selectedBoard?.categoryNames {
            sendDataDelegate?.sendData(data: selectedCategoryList)
        }
    }
    
    
    /// 게시글을 선택하거나 검색을 할 경우에 데이터 전달
    /// - Author: 남정은
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let cell = sender as? UITableViewCell,
           let indexPath = categoryListTableView.indexPath(for: cell) {
            /// 상세 게시글 화면에 선택된 post에 대한 정보 전달
            if let vc = segue.destination as? DetailPostViewController {
                vc.selectedPost = selectedBoard?.posts[indexPath.row]
            }
        }
        /// 검색 버튼 클릭시 선택된 board에 대한 정보 전달
        else if segue.identifier == "searchSegue", let vc = segue.destination as? SearchViewController {
            vc.selectedBoard = selectedBoard
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if DEBUG
        print(selectedBoard?.posts, selectedBoard?.categoryNames, selectedBoard?.categoryNumbers, selectedBoard?.boardTitle)
        #endif
        
        /// 게시글 작성 버튼의 테마 설정
        /// - Author: 김정민(kimjm010@icloud.com)
        composeBtn.setButtonTheme()
        
        /// 네비게이션 바에 타이틀 초기화
        /// - Author: 남정은
        self.navigationItem.title = selectedBoard?.boardTitle
        
        /// 카테코리 별로 filtering되기 전 게시글배열 초기화
        filteredPostList = selectedBoard?.posts ?? []
        
        /// 상세 게시글 화면에서 스크랩 버튼 클릭시 스크랩 게시판에 게시글 추가
        /// - Author: 남정은
        var token = NotificationCenter.default.addObserver(forName: .postDidScrap, object: nil, queue: .main) { noti in
            
            if let scrappedPost = noti.userInfo?["scrappedPost"] as? Post {
                scrapBoard.posts.insert(scrappedPost, at: 0)
            }
        }
        tokens.append(token)
        
        
        /// 상세 게시글 화면에서 스크랩 버튼 취소시 스크랩 게시판에 게시글 삭제
        /// - Author: 남정은
        token = NotificationCenter.default.addObserver(forName: .postCancelScrap, object: nil, queue: .main) {
            [weak self] noti in
            guard let self = self else { return }
            
            if let unscrappedPost = noti.userInfo?["unscrappedPost"] as? Post {
                
                /// 삭제하고 리로드
                if let unscrappedPostIndex = scrapBoard.posts.firstIndex(where: { $0 === unscrappedPost }) {
                    scrapBoard.posts.remove(at: unscrappedPostIndex)
                    
                    self.categoryListTableView.reloadData()
                }
            }
        }
        tokens.append(token)
        
        
        // TODO: 카테고리에 따라 게시글 추가하는 기능
        /// - Author: 김정민(kimjm010@icloud.com)
        token = NotificationCenter.default.addObserver(forName: .newCategoryPostInsert, object: nil, queue: .main, using: { [weak self] (noti) in
            if let category = noti.userInfo?["category"] as? Int {
                if let newPost = noti.userInfo?["newPost"] as? Post {
                    switch category {
                    case 2000:
                        publicityBoard.posts.insert(newPost, at: 0)
                    case 2001:
                        publicityBoard.posts.insert(newPost, at: 0)
                    case 2002:
                        publicityBoard.posts.insert(newPost, at: 0)
                    case 2003:
                        publicityBoard.posts.insert(newPost, at: 0)
                    default:
                        break
                    }
                    self?.categoryListTableView.reloadData()
                }
            }
        })
        tokens.append(token)
    }
}



/// 카테고리 게시판의 카테고리 목록을 나타내는 컬렉션 뷰의 데이터소스
/// - Author: 남정은
extension CategoryBoardViewController: UICollectionViewDataSource {
    /// - Parameters:
    ///   - collectionView: 카테고리 목록을 나타내는 컬렉션 뷰
    ///   - section: 해당하는 섹션
    /// - Returns: 각각의 섹션안에 들어갈 아이템 수
    /// - Author: 남정은
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedBoard?.categoryNumbers.count ?? 0
    }
    
    
    /// - Parameters:
    ///   - collectionView: 카테고리 목록을 나타내는 컬렉션 뷰
    ///   - indexPath: 해당하는 인덱스
    /// - Returns: 각각의 인덱스에 들어갈 아이템의 정보를 저장한 셀
    /// - Author: 남정은
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryBoardCollectionViewCell",
                                                      for: indexPath) as! CategoryBoardCollectionViewCell
        
        guard let categoryNames = selectedBoard?.categoryNames else { return cell }
        
        if indexPath.row == 0 {
            /// 아무것도 선택되지 않았을 시에 row == 0인 셀이 선택된 것처럼 보이도록
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



/// 카테고리 목록을 나타내는 컬렉션 뷰에 대한  동작 처리
/// - Author: 남정은
extension CategoryBoardViewController: UICollectionViewDelegate {
    /// 아이템이 클릭되었을 때 실행할 작업을 수행
    /// - Parameters:
    ///   - collectionView: 카테고리 목록을 나타내는 컬렉션 뷰
    ///   - indexPath: 해당하는 인덱스
    /// - Returns: 선택이 되길 원하면 true, 아니라면 false를 리턴
    /// - Author: 남정은
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        /// 다른 카테고리 선택시에 row == 0 인 cell리로드하여 선택되지 않은 상태로 보여지게 함
        if isSelected {
            isSelected = false
            collectionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
        }
        
        return true
    }
    
    
    /// 아이템이 선택되었을 때 실행할 작업을 수행
    /// - Parameters:
    ///   - collectionView: 카테고리 목록을 나타내는 컬렉션 뷰
    ///   - indexPath: 해당하는 인덱스
    /// - Author: 남정은
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /// 선택될 때마다 해당하는 카테고리에 대한 게시물을 보여주어야 하므로 삭제하고 다시 담는다
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
    
    
    /// 게시글들을 카테고리별로 분류하여 배열에 저장
    /// - Parameters:
    ///   - selectedBoard: 선택된 게시판
    ///   - indexPath: 선택된 카테고리의 인덱스패스
    /// - Author: 남정은
    private func filterPostByCategory(in selectedBoard: Board, indexPath: IndexPath) {
        
        filteredPostList = selectedBoard.posts.filter({ post in
            return post.categoryRawValue == selectedBoard.categoryNumbers[indexPath.row]
        })
    }
}



/// 카테고리 목록을 나타내는 컬렉션 뷰의 레이아웃 조정
/// - Author: 남정은
extension CategoryBoardViewController: UICollectionViewDelegateFlowLayout {
    /// 셀의 사이즈를 델리게이트에게 알려줌
    /// 이 메소드가 cellForRowAt보다 먼저 실행됨.
    /// - Parameters:
    ///   - collectionView: 플로우 레이아웃을 나타낼 컬렉션 뷰
    ///   - collectionViewLayout: 정보를 요청하는 레이아웃 객체
    ///   - indexPath: 아이템의 인덱스 패스
    /// - Returns: 지정된 아이템의 사이즈
    /// - Author: 남정은
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return .zero
        }
        
        /// 셀의 너비
        let width:CGFloat
        
        /// 카테고리 개수
        guard let categoryCount = selectedBoard?.categoryNumbers.count else { return .zero }
        
        /// 셀의 inset을 제외한 너비
        let withoutInsetWidth = view.frame.width -
        (flowLayout.minimumInteritemSpacing * CGFloat((categoryCount - 1))
         + flowLayout.sectionInset.left
         + flowLayout.sectionInset.right)
        
        /// 셀의 개수가 3일 경우
        if categoryCount == 3 {
            width = withoutInsetWidth / 3
            return CGSize(width: width, height: 50)
        }
        /// 셀의 개수가 4일 경우
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



/// 카테고리 게시판에 대한 테이블 뷰 데이터소스
/// - Author: 남정은
extension CategoryBoardViewController: UITableViewDataSource {
    /// 하나의 섹션안에 나타낼 row수를 지정
    /// - Parameters:
    ///   - tableView: 요청한 정보를 나타낼 객체
    ///   - section: 테이블 뷰의 섹션
    /// - Returns: 섹션안에 나타낼 row수
    /// - Author: 남정은
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filteredPostList.count
    }
    
    /// 셀의 데이터소스를  테이블 뷰의 특정 위치에 추가하기위해 호출
    /// - Parameters:
    ///   - tableView: 요청한 정보를 나타낼 객체
    ///   - indexPath: 테이블 뷰의 row의 위치를 나타내는 인덱스패스
    /// - Returns: 구현을 완료한 셀
    /// - Author: 남정은
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FreeBoardTableViewCell",
                                                 for: indexPath) as! FreeBoardTableViewCell
        
        let post = filteredPostList[indexPath.row]
        
        cell.configure(post: post)
        return cell
    }
}



extension CategoryBoardViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print(#function)
    }
}
