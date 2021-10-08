//
//  CompanyTableViewCell.swift
//  CompanyTableViewCell
//
//  Created by 황신택 on 2021/09/14.
//

import UIKit
import AZSClient

/// 채용정보 셀
/// Author: 황신택(sinadsl1457@gmail.com)
class CompanyTableViewCell: UITableViewCell {
    /// 직업 레이블
    @IBOutlet weak var fieldLabel: UILabel!
    
    /// 회사 이름 레이블
    @IBOutlet weak var titleLabel: UILabel!
    
    /// 모집 내용 레이블
    @IBOutlet weak var detailLabel: UILabel!
    
    /// 경력 레이블
    @IBOutlet weak var careerLabel: UILabel!
    
    /// 학위 레이블
    @IBOutlet weak var degreeLabel: UILabel!
    
    /// 지역 레이블
    @IBOutlet weak var regionLabel: UILabel!
    
    /// 회사 이미지뷰
    @IBOutlet weak var companyImage: UIImageView!
    
    /// 북마크 이미지뷰
    @IBOutlet weak var favoriteImage: UIImageView!
    
    /// 회사 웹사이트 버튼
    @IBOutlet weak var CompanyWebSite: UIButton!
    
    /// 이미지 캐시
    let cache = NSCache<NSURL, UIImage>()
    
    /// 채용정보 데이터
    var job: JobData.Job?
    
    
    /// 로고 이미지을 클릭하면 해당 웹사이트로 이동합니다.
    /// - Parameter sender: CompanyWebSiteButton
    /// Author: 황신택 (sinadsl1457@gmail.com)
    @IBAction func goToWebSite(_ sender: Any) {
        guard let urlStr = job?.website else { return }
        if let url = URL(string: urlStr) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    
    /// 채용정보 데이터로 셀을 구성합니다.
    /// - Parameter model:JobData.Job의 데이타를 전달
    /// Author: 황신택 (sinadsl1457@gmail.com)
    func configureCompany(with model: JobData.Job) {
        job = model
        fieldLabel.text = model.field
        titleLabel.text = model.title
        detailLabel.text = model.detail
        careerLabel.text = model.career
        degreeLabel.text = model.degree
        regionLabel.text = model.region
        fetchImage(with: model) { image in
            if let image = image {
                self.companyImage.image = image
            } else {
                self.companyImage.image = UIImage(named: "placeholder")
            }
        }
        favoriteImage.image = UIImage(systemName: "bookmark")
    }
    
    
    /// 이미지를 다운로드 합니다.
    /// 캐시에 이미지가 저장되어 있지 않다면, 이미지를 다운로드하고 캐시에 저장합니다. 이미지 url을 캐시 키로 사용합니다.
    /// - Parameter model: JobData.Job의 url을 전달
    /// - completion: 데이터가 없으면 nil을 데이터가 있으면 이미지를 전달 합니다.
    /// Author: 황신택 (sinadsl1457@gmail.com)
    func fetchImage(with url: JobData.Job, completion: @escaping (UIImage?) -> ()) {
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
    /// Author: 황신택 (sinadsl1457@gmail.com)
    override func awakeFromNib() {
        super.awakeFromNib()
        [fieldLabel].forEach({
            $0?.layer.cornerRadius = 10
            $0?.layer.masksToBounds = true
        })
    }
}
