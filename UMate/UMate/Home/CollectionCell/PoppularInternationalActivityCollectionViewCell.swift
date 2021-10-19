//
//  InternationalActivityCollectionViewCell.swift
//  UMate
//
//  Created by 황신택 on 2021/10/08.
//

import UIKit

/// 인기 대외활동
/// Horizontal Scroll 기능을 위해 테이블 뷰 셀 안에 구현했습니다.
/// - Author: 황신택 (sinadsl1457@gmail.com)
class PoppularInternationalActivityCollectionViewCell: UICollectionViewCell {
    /// 대외활동 이미지 뷰
    @IBOutlet weak var contestImageView: UIImageView!
    
    /// 대외활동 내용
    @IBOutlet weak var descLabel: UILabel!
    
    /// 이미지 캐시
    let cache = NSCache<NSURL, UIImage>()
    

    
    /// 대외활동 데이터로 콜렉션 셀을 구성합니다.
    /// - Parameter model: ContestSingleData.FavoriteContests
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    func configure(with model: ContestSingleData.FavoriteContests) {
        fetchImage(with: model) { image in
            if let image = image {
                self.contestImageView.image = image
            } else {
                self.contestImageView.image = UIImage(named: "placeholder")
            }
        }
        descLabel.text = model.description
    }
    
    
    /// 이미지를 다운로드합니다.
    /// 캐시에 이미지가 저장되어 있지 않다면, 이미지를 다운로드하고 캐시에 저장합니다. 이미지 url을 캐시 키로 사용합니다.
    /// - Parameter model: JobData.Job의 url을 전달
    /// - completion: 데이터가 없으면 nil을 데이터가 있으면 이미지를 전달합니다.
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    func fetchImage(with url: ContestSingleData.FavoriteContests, completion: @escaping (UIImage?) -> ()) {
        guard let url = URL(string: url.url) else {
            DispatchQueue.main.async {
                completion(nil)
            }
            return
        }
        
        if let image = cache.object(forKey: url as NSURL) {
            DispatchQueue.main.async {
                completion(image)
            }
        } else {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        self.cache.setObject(image, forKey: url as NSURL)
                        DispatchQueue.main.async {
                            completion(image)
                        }
                    }
                }
            }
        }
    }
    
    
    /// 초기화 작업을 진행합니다.
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}



