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
    
    
    /// 셀에 호출할 속성들을 초기화 하는 메소드
    /// 제이슨 데이타를 파싱해서 아울렛 속성에 저장합니다.
    func configureCompany(with model: JobData.Job) {
        fieldLabel.text = model.field
        titleLabel.text = model.title
        detailLabel.text = model.detail
        careerLabel.text = model.career
        degreeLabel.text = model.degree
        regionLabel.text = model.region
        fetchImage(with: model)
        favoriteImage.image = UIImage(systemName: "bookmark")
    }
    
    
    
    /// 파마리터로 job데이타를 받아서 관련 url를 파싱합니다
    /// 파싱된 데이타를 Image 타입으로 바인딩해서 속성에 저장.
    /// - Parameter model: JobData.Job
    func fetchImage(with model: JobData.Job) {
        guard let url = URL(string: model.url) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error)
            }
            
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.companyImage.image = image
                }
            }
        }.resume()
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        [fieldLabel].forEach({
            $0?.layer.cornerRadius = 10
            $0?.layer.masksToBounds = true
        })
        
    }
    
}


