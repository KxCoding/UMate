//
//  InternationalActivityTableViewCell.swift
//  UMate
//
//  Created by 황신택 on 2021/10/13.
//

import UIKit

/// 대외활동 셀
/// - Author: 황신택 (sinadsl1457@gmail.com)
class InternationalActivityTableViewCell: UITableViewCell {
    /// 분야 레이블
    @IBOutlet weak var fieldLabel: PaddingLabel!
    
    /// 설명 레이블
    @IBOutlet weak var descLabel: UILabel!
    
    /// 주최자 레이블
    @IBOutlet weak var institutionLabel: UILabel!
    
    /// 대외활동 포스터 이미지뷰
    @IBOutlet weak var contestImageView: UIImageView!
    
    /// 대외활동 데이터
    var contests: ContestSingleData.Contests?
    
    /// 이미지 캐시
    let cache = NSCache<NSURL, UIImage>()

    
    
    /// 포스터를 탭하면 대외활동 웹사이트로 이동합니다.
    /// - Parameter sender: 포스터 이미지 버튼
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    @IBAction func goToWebsite(_ sender: Any) {
        guard let urlStr = contests?.website else { return }
        if let url = URL(string: urlStr) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    
    
    /// 대외활동 데이터를 받아서 아웃렛을 초기화합니다.
    /// - Parameter model: 대외활동 목록 데이터
    func configure(with model: ContestSingleData.Contests) {
        contests = model
        fieldLabel.text = model.field
        descLabel.text = model.description
        institutionLabel.text = model.institution
        fetchImage(with: model) { image in
            if let image = image {
                self.contestImageView.image = image
            } else {
                self.contestImageView.image = UIImage(named: "placeholder")
            }
        }
    }
    
    
    /// 이미지를 다운로드 합니다.
    /// 캐시에 이미지가 저장되어 있지 않다면, 이미지를 다운로드하고 캐시에 저장합니다. 이미지 url을 캐시 키로 사용합니다.
    /// - Parameter model: JobData.Job의 url을 전달
    /// - completion: 데이터가 없으면 nil을 데이터가 있으면 이미지를 전달 합니다.
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    func fetchImage(with url: ContestSingleData.Contests, completion: @escaping (UIImage?) -> ()) {
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
        [fieldLabel].forEach({
            $0?.layer.cornerRadius = 10
            $0?.layer.masksToBounds = true
        })
    }
}
