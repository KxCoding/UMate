//
//  FirstSectionTableViewCell.swift
//  UMate
//
//  Created by Effie on 2021/07/16.
//

import UIKit


/// 상점 이미지 목록 셀
/// - Author: 박혜정(mailmelater11@gmail.com)
class FirstSectionTableViewCell: UITableViewCell {
    
    // MARK: Outlets
    
    /// 가게 이미지 컬렉션 뷰
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    /// 컬렉션 뷰 페이저
    @IBOutlet weak var pager: UIPageControl!
    
    
    // MARK: Properties
    
    /// 데이터 관리 객체
    let manager = PlaceDataManager.shared
    
    /// 표시하는 가게
    var target: Place!
    
    /// 더미 이미지 배열
    ///
    /// 이미지 다운로드에 실패하면 더미 이미지를 사용합니다.
    lazy var dummyImages: [UIImage] = {
        var images = [UIImage]()
        for i in 0 ... 5 {
            if let image = UIImage(named: "search_0\(i)") {
                images.append(image)
            }
        }
        return images
    }()
    
    
    // MARK: Methods
    
    /// 각 뷰에서 표시하는 데이터를 초기화합니다.
    /// - Parameter content: 표시할 정보를 담은 Place 객체
    func configure(with content: Place) {
        target = content
        
        if target.imageUrls.count < 2 {
            pager.isHidden = true
        }
        
        pager.numberOfPages = target.imageUrls.count
    }
    
    
    // MARK: Cell Lifecycle Method
    
    /// 셀이 로드되면 델리게이트를 설정하고 UI를 초기화합니다.
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self
        
        pager.currentPage = 0
        pager.configureStyle(with: [.pillShape])
        pager.backgroundColor = .black.withAlphaComponent(0.1)
        pager.alpha = 0.5
    }
    
}



// MARK: - Collection view delegation

extension FirstSectionTableViewCell: UICollectionViewDataSource {
    
    /// 지정된 섹션에서 표시할 아이템의 개수를 제공합니다.
    /// - Parameters:
    ///   - collectionView: 컬렉션 뷰
    ///   - section: 섹션 인덱스
    /// - Returns: 섹션에 포함되는 아이템의 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return target.imageUrls.count
    }
    
    
    /// 지정된 컬렉션 뷰, 지정된 indexPath에 표시할 셀을 제공합니다.
    ///
    /// 이미지를 다운로드하고 받은 이미지로 이미지 뷰를 업데이트합니다.
    /// - Parameters:
    ///   - collectionView: 컬렉션 뷰
    ///   - indexPath: 아이템의 indexpath
    /// - Returns: 표시할 셀
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceImageCollectionViewCell", for: indexPath) as! PlaceImageCollectionViewCell
        
        manager.download(.detailImage, andUpdate: cell.imageView, with: target.imageUrls[indexPath.row])
        
        return cell
    }
    
}



extension FirstSectionTableViewCell: UICollectionViewDelegateFlowLayout {
    
    /// 지정된 indexPath에 표시할 셀의 크기를 결정합니다.
    /// - Parameters:
    ///   - collectionView: 컬렉션 뷰
    ///   - collectionViewLayout: layout 객체
    ///   - indexPath: 아이템의 indexpath
    /// - Returns: 셀 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
        
    }
}



extension FirstSectionTableViewCell: UICollectionViewDelegate {
    
    /// collection view가 스크롤되면 UI를 업데이트 합니다.
    ///
    /// 스크롤 offset을 계산해서 pager를 업데이트 합니다.
    /// - Parameter scrollView: 스크롤 이벤트가 발생하는 collection view
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let page = x / scrollView.frame.width
        pager.currentPage = Int(page)
    }
}



// MARK: - 상세 이미지 컬렉션 뷰

/// 이미지를 표시하는 컬렉션 뷰의 셀 클래스
/// - Author: 박혜정(mailmelater11@gmail.com)
class PlaceImageCollectionViewCell: UICollectionViewCell {
    
    // MARK: Outlets
    
    /// 이미지를 표시하는 이미지 뷰
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: Cell Lifecycle Method
    
    /// 셀이 로드되면 UI를 초기화합니다.
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.contentMode = .scaleAspectFill
        
    }
    
}
