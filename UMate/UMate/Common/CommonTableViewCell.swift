//
//  CommonTableViewCell.swift
//  UMate
//
//  Created by 황신택 on 2021/10/26.
//

import UIKit

/// 공통되는 기능을 포함한 테이블 뷰 셀
/// - Author: 황신택(sinadsl1457@gamil.com)
class CommonTableViewCell: UITableViewCell {

    /// 이미지 캐시
    let cache = NSCache<NSURL, UIImage>()
    
    /// 이미지를 다운로드합니다.
    /// 캐시에 이미지가 저장되어 있지 않다면, 이미지를 다운로드하고 캐시에 저장합니다. 이미지 url을 캐시 키로 사용합니다.
    /// - Parameter model: JobData.Job의 url
    /// - completion: 데이터가 없으면 nil을 데이터가 있으면 이미지를 전달합니다.
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    func fetchImage(with url: String, completion: @escaping (UIImage?) -> ()) {
        guard let url = URL(string: url) else {
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
}
