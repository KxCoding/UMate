//
//  CompanyTableViewCell.swift
//  CompanyTableViewCell
//
//  Created by 황신택 on 2021/09/14.
//

import UIKit

/// 회사목록을 담당하는 클래스입니다
/// Author: 황신택.
class CompanyTableViewCell: UITableViewCell {
    /// 직업 분야  레이블
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
    
    
    /// NSCache의 NSURL키를 이용해서 값을 가져오기 위한 속성
    /// 캐시가 시스템 메모리를 너무 많이 사용하지 않도록 하기 위해서 사용
    let cache = NSCache<NSURL, UIImage>()
    
    /// 채용정보 데이타 모델을 저장
    /// 각셀의 웹사이트로 이동 하기 위한 속성입니다.
    var jobList: JobData.Job?
    
    
    /// 로고 이미지을 클릭하면 해당 웹사이트로 갑니다.
    /// - Parameter sender: UIButton에 전달되면 job데이타의 url의 사이트로 이동합니다.
    @IBAction func goToWebSite(_ sender: Any) {
        guard let urlStr = jobList?.website else { return }
        if let url = URL(string: urlStr) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    
    /// 셀에 호출할 속성들을 초기화 하는 메소드
    /// 제이슨 데이타를 파싱해서 아울렛 속성에 저장합니다.
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
    
    
    
    /// 파마리터로 job데이타를 받아서 관련 url를 파싱합니다.
    /// 캐시의 키를 통해서 이미지를 가져오거나 가져올 수 없다면, setObject(_:forKey:)로 지정한 키에  값을 저장합니다.
    /// - Parameter model: JobData.Job의 url을 NSCache로 이미지 데이타를 가져옵니다.
    /// completion을 이용해서 데이터가 없으면 nil을 데이터가 있으면 이미지를 전달합니다.
    func fetchImage(with model: JobData.Job, completion: @escaping (UIImage?) -> ()) {
        guard let url = URL(string: model.url) else {
            DispatchQueue.main.async {
                print(model.title, model.url)
                completion(nil)
            }
            return
        }
        
        if let image = cache.object(forKey: url as NSURL) {
            DispatchQueue.main.async {
                print(model.title, model.url, image)
                completion(image)
            }
        } else {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        self.cache.setObject(image, forKey: url as NSURL)
                        DispatchQueue.main.async {
                            print(model.title, model.url, image)
                            completion(image)
                        }
                    }
                }
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // 필드 레이블 바운드를 둥글게 바꿉니다.
        [fieldLabel].forEach({
            $0?.layer.cornerRadius = 10
            $0?.layer.masksToBounds = true
        })
        
    }
    
}

