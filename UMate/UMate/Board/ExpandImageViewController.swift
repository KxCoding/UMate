//
//  ExpandImageViewController.swift
//  ExpandImageViewController
//
//  Created by 남정은 on 2021/08/11.
//

import UIKit


/// 게시글 상세화면에서 이미지 클릭 시 확대된 이미지를 보여주는 뷰 컨트롤러
/// - Author: 남정은(dlsl7080@gmail.com)
class ExpandImageViewController: CommonViewController {
    /// 이미지의 순번을 알려주는 레이블
    @IBOutlet weak var imageCountLabel: UILabel!
    
    /// 이미지의 페이지를 나타내는 페이지 컨트롤러
    @IBOutlet weak var imagePageControl: UIPageControl!
    
    /// 이미지를 보여주는 컬렉션 뷰
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    /// 선택된 게시글에 대한 정보
    var selectedPost: Post?
    
    /// 선택된 이미지의 index row
    var imageIndex: Int?
    
    /// 처음 나타낼 이미지에 대한 속성
    var initiatedImage = true
    
    
    /// pageControl의 currentPage에 따라서 컬렉션 뷰의 스크롤을 이동합니다.
    /// - Parameter sender: UIPageControl. 이미지의 페이지를 나타냅니다.
    @IBAction func currentPageChanged(_ sender: UIPageControl) {
        let indexPath = IndexPath(item: sender.currentPage, section: 0)
        imageCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    
    /// ExpandImageVC를 dismiss합니다.
    /// - Parameter sender: 엑스 버튼
    @IBAction func closeImageVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    /// 뷰 컨트롤러의 뷰 계층이 메모리에 올라간 뒤 호출됩니다.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // pageControl초기화
        imagePageControl.configureStyle(with: [.pillShape])
        imagePageControl.backgroundColor = .black.withAlphaComponent(0.1)
        
        
        // 선택된 이미지에 대한 정보를 초기화
        let token = NotificationCenter.default.addObserver(forName: .sendImageView,
                                                       object: nil,
                                                       queue: .main) { [weak self] noti in
            guard let self = self else { return }
            
            // 이미지정보가 들어있는 게시글
            guard let post = noti.userInfo?["post"] as? Post else { return }
            
            // 선택된 이미지의 index row
            guard let index = noti.userInfo?["index"] as? Int else { return }
            
            self.selectedPost = post
            self.imageIndex = index
            
            let images = post.images
            
            // 현재 화면에 나타나는 이미지의 순번
            self.imageCountLabel.text = "\(index + 1) / \(images.count)"
            
            // 이미지가 하나일 경우에는 pageControl 숨김
            if images.count > 1 {
                self.imagePageControl.currentPage = index
                self.imagePageControl.numberOfPages = images.count
            } else {
                self.imagePageControl.isHidden = true
            }
        }
        tokens.append(token)
    }
}



/// 이미지를 나타냄
/// - Author: 남정은(dlsl7080@gmail.com)
extension ExpandImageViewController: UICollectionViewDataSource {
    /// 이미지의 개수를 리턴합니다.
    /// - Parameters:
    ///   - collectionView: 이미지 컬렉션 뷰
    ///   - section: 이미지를 그룹짓는 section
    /// - Returns: 게시글에 포함되는 이미지 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedPost?.images.count ?? 0
    }
    
    
    /// 이미지를 컬렉션 뷰에 표시합니다.
    /// - Parameters:
    ///   - collectionView: 이미지 컬렉션 뷰
    ///   - indexPath: 이미지 셀의 indexPath
    /// - Returns: 이미지 셀
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postImageCell", for: indexPath) as! ExpandPostImageCollectionViewCell
        
        guard let images = selectedPost?.images else { return cell }
        
        cell.expandImageView.image = images[indexPath.row]
        return cell
    }
}



/// 이미지 컬렉션 뷰 동작 처리
/// - Author: 남정은(dlsl7080@gmail.com)
extension ExpandImageViewController: UICollectionViewDelegate {
    /// 이미지를 클릭해서 ExpandImageVC가 보여질 때 선택한 이미지를 화면에 표시합니다.
    /// - Parameters:
    ///   - collectionView: 이미지 컬렉션 뷰
    ///   - cell: 이미지 셀
    ///   - indexPath: 이미지 셀의 indexPath
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if initiatedImage {
            initiatedImage = false // 계속해서 처음에 클릭한 이미지만 표시되는 것을 방지
            collectionView.scrollToItem(at: IndexPath(item: imageIndex ?? 0, section: 0), at: .centeredHorizontally, animated: false)
        }
    }
}



/// 이미지 컬렉션 뷰 레이아웃
/// - Author: 남정은(dlsl7080@gmail.com)
extension ExpandImageViewController: UICollectionViewDelegateFlowLayout {
    /// 이미지의 사이즈를 리턴합니다.
    /// - Parameters:
    ///   - collectionView: 이미지 컬렉션 뷰
    ///   - collectionViewLayout: 컬렉션 뷰의 레이아웃 정보
    ///   - indexPath: 이미지 셀의 indexPath
    /// - Returns: 이미지 셀의 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height
       
        return CGSize(width: width, height: height)
    }
}



/// 컬렉션 뷰의 스크롤 뷰에 대한 동작 처리
/// - Author: 남정은(dlsl7080@gmail.com)
extension ExpandImageViewController: UIScrollViewDelegate {
    /// 스크롤 뷰안에 컨텐트 뷰에서 스크롤 발생 시에 호출됩니다.
    /// - Parameter scrollView: 스크롤이 발생되는 스크롤 뷰 객체
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 스크롤 뷰의 x좌표
        let x = scrollView.contentOffset.x
        
        // 이미지의 순서에 알맞게 페이지 저장
        let page = Int( x / scrollView.frame.width)
        
        guard let images = selectedPost?.images else { return }
        
        // 페이지에 따라서 이미지 번호를 바꿔줌
        imageCountLabel.text = "\(page + 1) / \(images.count)"
        
        // 페이지에 따라서 페이저의 현재 페이지를 바꿔줌
        imagePageControl.currentPage = page
    }
}
