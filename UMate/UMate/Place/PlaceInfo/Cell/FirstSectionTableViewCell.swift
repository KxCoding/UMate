//
//  FirstSectionTableViewCell.swift
//  UMate
//
//  Created by Effie on 2021/07/16.
//

import UIKit

class FirstSectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var pager: UIPageControl!
    
    /// 정보를 표시할 가게
    var target: Place!
    
    /// 이미지 데이터가 없을 때 표시할 더미 데이터
    lazy var dummyImages: [UIImage] = {
        var images = [UIImage]()
        for i in 0 ... 5 {
            if let image = UIImage(named: "search_0\(i)") {
                images.append(image)
            }
        }
        return images
    }()
    
    /// 셀 내부 각 뷰들이 표시하는 content 초기화
    /// - Parameter content: 표시할 내용을 담은 Place 객체
    func configure(with content: Place) {
        
        target = content
        
        // pager가 표시하는 페이지의 수
        if target.imageUrls.count < 2 {
            pager.isHidden = true
        }
        
        pager.numberOfPages = target.imageUrls.count
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        /// 델리게이션
        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self
        
        /// pager 초기화
        pager.currentPage = 0
        pager.configureStyle(with: [.pillShape])
        pager.backgroundColor = .black.withAlphaComponent(0.1)
        pager.alpha = 0.5
    }
    
}



// MARK: - Collection view delegation

extension FirstSectionTableViewCell: UICollectionViewDataSource {
    
    /// 지정된 섹션에서 몇 개의 item을 표시할 건지 data source에게 묻는 메소드
    /// - Parameters:
    ///   - collectionView: 이 정보를 요청하는 collection view
    ///   - section: 컬렉션 뷰의 특정 섹션을 가리키는 index number
    /// - Returns: 섹션에 포함되는 아이템의 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return target.imageUrls.count
    }
    
    
    /// data source에게 컬렉션 뷰에서 특정 indexpath의 아이템에 응하는 셀을 요청하는 메소드
    /// - Parameters:
    ///   - collectionView: 이 정보를 요청하는 collection view
    ///   - indexPath: 아이템의 위치를 가리키는 indexpath
    /// - Returns: 완성된 셀
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceImageCollectionViewCell", for: indexPath) as! PlaceImageCollectionViewCell
        
        /// placeholder 이미지 등록
        cell.imageView.image = placeholderImage
        /// 응답에 따라 이미지 뷰 업데이트
        DataManager.shared.lazyUpdate(.detail, of: cell.imageView, with: target.imageUrls[indexPath.row])
        
        return cell
    }
    
}




extension FirstSectionTableViewCell: UICollectionViewDelegateFlowLayout {
    
    /// 지정된 셀의 크기를 delegate에게 요청하는 메소드
    /// - Parameters:
    ///   - collectionView: 이 정보를 요청하는 collection view
    ///   - collectionViewLayout: 이 정보를 요청하는 layout 객체
    ///   - indexPath: 아이템의 위치를 가리키는 indexpath
    /// - Returns: 높이와 너비
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
        
    }
}




extension FirstSectionTableViewCell: UICollectionViewDelegate {
    
    /// 사용자가 collection view를 스크롤 할 때마다 호출됨. 스크롤에 따른 offset을 계산해서 pager 업데이트.
    /// - Parameter scrollView: 스크롤 이벤트가 발생하는 collection view
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let page = x / scrollView.frame.width
        pager.currentPage = Int(page)
    }
}



// MARK: - 상세 이미지 컬렉션 뷰
class PlaceImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    /// 셀 초기화
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.contentMode = .scaleAspectFill
        
    }
    
}
