//
//  CompanyTableViewCell.swift
//  CompanyTableViewCell
//
//  Created by 황신택 on 2021/09/14.
//

import UIKit
import AZSClient

/// 채용정보 목록 화면]
/// Author: 황신택(sinadsl1457@gmail.com)
class CompanyTableViewCell: UITableViewCell {
    /// 직업 레이블
    @IBOutlet weak var fieldLabel: UILabel!
    
    /// 회사이름  레이블
    @IBOutlet weak var titleLabel: UILabel!
    
    /// 모집내용  레이블
    @IBOutlet weak var detailLabel: UILabel!
    
    /// 경력  레이블
    @IBOutlet weak var careerLabel: UILabel!
    
    /// 학위  레이블
    @IBOutlet weak var degreeLabel: UILabel!
    
    /// 지역  레이블
    @IBOutlet weak var regionLabel: UILabel!
    
    /// 회사  이미지뷰
    @IBOutlet weak var companyImage: UIImageView!
    
    /// 북마크 이미지뷰
    @IBOutlet weak var favoriteImage: UIImageView!
    
    /// 회사 웹사이트 버튼
    @IBOutlet weak var CompanyWebSite: UIButton!
    
    
    /// NSCache의 NSURL키를 이용해서 값을 가져오기위한 속성
    /// 캐시가 시스템 메모리를 너무 많이 사용하지않도록 하기위해서 사용 했습니다.
    let cache = NSCache<NSURL, UIImage>()
    
    /// 채용정보 데이타 모델을 저장
    var jobList: JobData.Job?
    
    
    /// 로고 이미지을 클릭하면 해당 웹사이트로 갑니다.
    /// - Parameter sender: CompanyWebSiteButton
    @IBAction func goToWebSite(_ sender: Any) {
        guard let urlStr = jobList?.website else { return }
        if let url = URL(string: urlStr) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    /// cellForRowAt에서 전돨된 데이타로 속성으 초기화합니다.
    /// - Parameter model:JobData.Job의 데이타 리스트 전달
    func configureCompany(with model: JobData.Job) {
        jobList = model
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
    
    
    
    /// job데이타를 받아서 관련 url를 파싱합니다.
    /// 캐시의 키를 통해서 이미지를 가져오거나 가져올 수 없다면, setObject(_:forKey:)로 지정한 키에  값을 저장합니다.
    /// - Parameter model: JobData.Job의 url을 전달
    /// - completion: 데이터가 없으면 nil을 데이터가 있으면 이미지를 전달 합니다.
    func fetchImage(with model: JobData.Job, completion: @escaping (UIImage?) -> ()) {
        guard let url = URL(string: model.url) else {
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
        
    
    override func awakeFromNib() {
        super.awakeFromNib()
        [fieldLabel].forEach({
            $0?.layer.cornerRadius = 10
            $0?.layer.masksToBounds = true
        })
        
    }
    
    
}
