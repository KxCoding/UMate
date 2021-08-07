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
    
    var dummyImages: [UIImage] {
        var images = [UIImage]()
        for i in 0 ... 5 {
            if let image = UIImage(named: "search_0\(i)") {
                images.append(image)
            }
        }
        return images
    }
    
    /// 셀 내부 각 뷰들이 표시하는 content 초기화
    /// - Parameter content: 표시할 내용을 담은 Place 객체
    func configure(with content: Place) {
        
        target = content
        
        // pager가 표시하는 페이지의 수
        if target.images.count > 0 {
            pager.numberOfPages = target.images.count
        } else {
            pager.numberOfPages = dummyImages.count
        }
        
        pager.currentPage = 0
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 델리게이션
        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self
        
        // pager 초기화
        pager.configureStyle(with: [.pillShape])
        pager.backgroundColor = .black.withAlphaComponent(0.1)
    }
    
}




extension FirstSectionTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if target.images.count > 0 {
            return target.images.count
        } else {
            return dummyImages.count
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceImageCollectionViewCell", for: indexPath) as! PlaceImageCollectionViewCell
        
        if target.images.count > 0 {
            cell.imageView.image = target.images[indexPath.item]
        } else {
            cell.imageView.image = dummyImages[indexPath.item]
        }
        
        return cell
    }
    
}




extension FirstSectionTableViewCell: UICollectionViewDelegateFlowLayout {
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




class PlaceImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.contentMode = .scaleAspectFill
        
    }
    
}
