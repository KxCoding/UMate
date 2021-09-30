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
    /// 직업 분야 관련 레이블
    @IBOutlet weak var fieldLabel: UILabel!
    
    /// 회사이름 관련 레이블
    @IBOutlet weak var titleLabel: UILabel!
    
    /// 모집내용 관련 레이블
    @IBOutlet weak var detailLabel: UILabel!
    
    /// 경력 관련 레이블
    @IBOutlet weak var careerLabel: UILabel!
    
    /// 학위 관련 레이블
    @IBOutlet weak var degreeLabel: UILabel!
    
    /// 지역 관련 레이블
    @IBOutlet weak var regionLabel: UILabel!
    
    /// 회사 이미지 관련 이미지뷰
    @IBOutlet weak var companyImage: UIImageView!
    
    /// 북마크 이미지뷰
    @IBOutlet weak var favoriteImage: UIImageView!
    
    /// NSCache의 NSURL키를 이용해서 값을 가져오기위한 속성
    /// 캐시가 시스템 메모리를 너무 많이 사용하지않도록 하기위해서 사용
    let cache = NSCache<NSURL, UIImage>()
    
    /// 셀에 호출할 속성들을 초기화 하는 메소드
    /// 제이슨 데이타를 파싱해서 아울렛 속성에 저장합니다.
    func configureCompany(with model: JobData.Job) {
        fieldLabel.text = model.field
        titleLabel.text = model.title
        detailLabel.text = model.detail
        careerLabel.text = model.career
        degreeLabel.text = model.degree
        regionLabel.text = model.region
//        fetchImage(with: model) { image in
//            if let image = image {
//                self.companyImage.image = image
//            } else {
//                self.companyImage.image = UIImage(named: "placeholder")
//            }
//        }
        fetch(with: model)
        favoriteImage.image = UIImage(systemName: "bookmark")
    }
    
    
    
    /// 파마리터로 job데이타를 받아서 관련 url를 파싱합니다.
    /// 캐시를 이용해서 키를 통해서 이미지를 가져오거나 가져올수 없다면, setObject(_:forKey:)로 지정한 키에  값을 저장합니다.
    /// - Parameter model: JobData.Job
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
    
    func fetch(with model: JobData.Job) {
        if let url = URL(string: model.url) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print(error)
                }
                DispatchQueue.global().async {
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.companyImage.image = image
                        }

                    }
                }
               
            }.resume()
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

