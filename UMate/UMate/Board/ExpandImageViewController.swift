//
//  ExpandImageViewController.swift
//  ExpandImageViewController
//
//  Created by 남정은 on 2021/08/11.
//

import UIKit

class ExpandImageViewController: UIViewController {
    
    @IBOutlet weak var imageCountLabel: UILabel!
    @IBOutlet weak var pager: UIPageControl!
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    
    /// pageControl의 curreontPage에 따라서 collectionView의 scroll이동
    @IBAction func controlPage(_ sender: UIPageControl) {
        let indexPath = IndexPath(item: sender.currentPage, section: 0)
        imageCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    
    /// ExpandedImageView를 dissmiss하는 버튼 액션
    @IBAction func closeImageVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    var selectedPost: Post?
    /// 선택된 Image의 index row
    var imageIndex: Int?
    /// 처음 나타낼 이미지에 대한 속성
    var initiatedImage = true
    
    var token: NSObjectProtocol?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// pageControl초기화
        pager.configureStyle(with: [.pillShape])
        pager.backgroundColor = .black.withAlphaComponent(0.1)
        
        
        /// 선택된 이미지에 대한 정보를 초기화
        token = NotificationCenter.default.addObserver(forName: .sendImageView,
                                                       object: nil,
                                                       queue: .main) { [weak self] noti in
            guard let self = self else { return }
            
            /// 이미지정보가 들어있는 게시글
            guard let post = noti.userInfo?["post"] as? Post else { return }
            /// 선택된 이미지의 index row
            guard let index = noti.userInfo?["index"] as? Int else { return }
            
            self.selectedPost = post
            self.imageIndex = index
            
            let images = post.images
            /// 현재 화면에 나타나는 이미지의 순번
            self.imageCountLabel.text = "\(index + 1) / \(images.count)"
            
            /// 이미지가 하나 일 경우에는 pageControl 숨김
            if images.count > 1 {
                self.pager.currentPage = index
                self.pager.numberOfPages = images.count
            } else {
                self.pager.isHidden = true
            }
            
        }
    }
    
    
    deinit {
        if let token = token {
            NotificationCenter.default.removeObserver(token)
        }
    }
}




extension ExpandImageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedPost?.images.count ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postImageCell", for: indexPath) as! ExpandPostImageCollectionViewCell
        
        guard let images = selectedPost?.images else { return cell }
        
        cell.expandImageView.image = images[indexPath.row]
        return cell
    }
}




extension ExpandImageViewController: UICollectionViewDelegate {
    
    /// 특정 cell이 collectionView에 나타나기 직전에 호출되는 메소드
    /// - Parameters:
    ///   - collectionView: cell을 추가할 collectionView
    ///   - cell: 추가될 cell
    ///   - indexPath: 나타낼 cell에 대한 indexPath
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        /// 이미지를 클릭해서 ExpandedImageView가 나타났을 때 선택한 이미지를 화면에 표시
        if initiatedImage {
            initiatedImage = false /// 계속해서 처음에 클릭한 이미지만 표시되는 것을 방지
            collectionView.scrollToItem(at: IndexPath(item: imageIndex ?? 0, section: 0), at: .centeredHorizontally, animated: false)
        }
    }
}




extension ExpandImageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        
        return CGSize(width: width, height: height)
    }
}




extension ExpandImageViewController: UIScrollViewDelegate {
    
    /// scrollView안에 content View에서 스크롤 발생시에 호출되는 메소드
    /// - Parameter scrollView: 스크롤이 발생되는 scrollView 객체
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        
        let page = Int( x / scrollView.frame.width)
        
        guard let images = selectedPost?.images else { return }
        imageCountLabel.text = "\(page + 1) / \(images.count)"
        
        pager.currentPage = page
    }
}
