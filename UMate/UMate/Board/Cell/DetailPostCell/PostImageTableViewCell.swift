//
//  PostImageTableViewCell.swift
//  PostImageTableViewCell
//
//  Created by 남정은 on 2021/07/27.
//

import UIKit


/// 이미지 컬렉션 뷰가 포함될 테이블 뷰 셀
/// - Author: 남정은
class PostImageTableViewCell: UITableViewCell {
    /// 이미지를 나타낼 컬렉션 뷰
    @IBOutlet weak var postImageCollectionView: UICollectionView!

    /// 선택된 게시글
    var selectedPost: Post?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
        postImageCollectionView.dataSource = self
        postImageCollectionView.delegate = self
    }
    
    
    
    /// 셀을 초기화
    /// - Parameter post: 선택된 게시글
    func configure(post: Post) {
        selectedPost = post
        
        /// 사진이 없을 때 이미지를 표시하는 collectionView 숨김
        postImageCollectionView.isHidden = post.images.isEmpty
    }
}



/// 이미지 컬렉션뷰에대한 데이터소스
/// - Author: 남정은
extension PostImageTableViewCell: UICollectionViewDataSource {
    /// 게시글에 포함된 이미지 수를 리턴
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedPost?.images.count ?? 0
    }
    
    
    /// 셀에 해당하는 이미지를 초기화
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostImageCollectionViewCell", for: indexPath) as! PostImageCollectionViewCell
        
        if let image = selectedPost?.images[indexPath.item] {
            cell.postImageView.image = image
        }
        
        /// 컬렉션 뷰 셀에서 필요한 데이터 저장
        cell.selectedPost = selectedPost
        cell.index = indexPath.row
        return cell
    }
}



/// 이미지 컬렉션 뷰 셀의 레이아웃 조정
/// - Author: 남정은
extension PostImageTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return .zero }

        let width = (UIScreen.main.bounds.size.width - (flowLayout.minimumInteritemSpacing * 2 + 10)) * 0.4

        return CGSize(width: width, height: width)
    }
}





