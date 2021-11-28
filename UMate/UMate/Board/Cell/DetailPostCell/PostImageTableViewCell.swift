//
//  PostImageTableViewCell.swift
//  PostImageTableViewCell
//
//  Created by 남정은 on 2021/07/27.
//

import UIKit


/// 이미지 컬렉션 뷰가 포함되는 테이블 뷰 셀
/// - Author: 남정은(dlsl7080@gmail.com)
class PostImageTableViewCell: UITableViewCell {
    /// 이미지 컬렉션 뷰
    @IBOutlet weak var postImageCollectionView: UICollectionView!

    /// 이미지 컬렉션 뷰 높이
    @IBOutlet weak var postImageCollectionViewHeightAnchor: NSLayoutConstraint!
    
    /// 이미지 다운로드 딜레이를 나타냄
    @IBOutlet weak var imageDownloadActivityIndeicatorView: UIActivityIndicatorView!
    
    /// 이미지 리스트
    var postImageList = [ImageListResponseData.PostImage]()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            postImageCollectionViewHeightAnchor.constant = CGFloat(UIScreen.main.bounds.size.width / 5)
        } else {
            postImageCollectionViewHeightAnchor.constant = CGFloat(UIScreen.main.bounds.size.width / 3)
        }
     
        postImageCollectionView.dataSource = self
        postImageCollectionView.delegate = self
    }
    
  
    /// PostImage cell을 초기화합니다.
    /// - Parameters:
    ///   - postImageList: 이미지 정보
    ///   - Author: 남정은(dlsl7080@gmail.com)
    func configure(postImageList: [ImageListResponseData.PostImage]) {
        postImageCollectionView.isHidden = postImageList.isEmpty

        self.postImageList = postImageList
    }
}



/// 이미지를 나타냄
/// - Author: 남정은(dlsl7080@gmail.com)
extension PostImageTableViewCell: UICollectionViewDataSource {
    /// 게시글에 포함된 이미지 수를 리턴합니다.
    /// - Parameters:
    ///   - collectionView: 이미지 컬렉션 뷰
    ///   - section: 이미지를 그룹짓는 section
    /// - Returns: 게시글에 포함된 이미지의 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postImageList.count
    }
    
    
    /// 셀에 해당하는 이미지를 초기화합니다.
    /// - Parameters:
    ///   - collectionView: 이미지 컬렉션 뷰
    ///   - indexPath: 이미지 셀의 indexPath
    /// - Returns: 이미지 셀
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostImageCollectionViewCell", for: indexPath) as! PostImageCollectionViewCell
        imageDownloadActivityIndeicatorView.startAnimating()
        BoardDataManager.shared.downloadImage(from: self.postImageList[indexPath.row].urlString, completion: { img in
            if let img = img {
                let image = BoardDataManager.shared.resizeImage(image: img, targetSize: CGSize(width: collectionView.contentSize.width , height: collectionView.contentSize.height))
                DispatchQueue.main.async {
                    self.imageDownloadActivityIndeicatorView.stopAnimating()
                    cell.postImageView.image = image
                }
            }
        })
        
        
        // 컬렉션 뷰 셀에서 필요한 데이터 저장
        cell.index = indexPath.item
        return cell
    }
}



/// 이미지 컬렉션 뷰 셀의 레이아웃 조정
/// - Author: 남정은(dlsl7080@gmail.com)
extension PostImageTableViewCell: UICollectionViewDelegateFlowLayout {
    ///  이미지 셀의 사이즈를 리턴합니다.
    /// - Parameters:
    ///   - collectionView: 이미지 컬렉션 뷰
    ///   - collectionViewLayout: 컬렉션 뷰의 레이아웃 정보
    ///   - indexPath: 이미지 셀의 indexPath
    /// - Returns: 이미지 셀의 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat
        
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            width = UIScreen.main.bounds.size.width / 5
        } else {
            width = UIScreen.main.bounds.size.width / 3
        }

        return CGSize(width: width, height: width)
    }
}





