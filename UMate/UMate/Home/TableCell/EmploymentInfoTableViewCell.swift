//
//  EmploymentInfoTableViewCell.swift
//  EmploymentInfoTableViewCell
//
//  Created by 황신택 on 2021/09/14.
//
import AZSClient
import UIKit

/// 채용정보 데이터를 구성하는 셀
/// - Author: 황신택 (sinadsl1457@gmail.com)
class EmploymentInfoTableViewCell: CommonTableViewCell {
    /// 채용 분야 레이블
    @IBOutlet weak var jobFieldLabel: UILabel!
    
    /// 회사 이름 레이블
    @IBOutlet weak var companyNameLabel: UILabel!
    
    /// 모집 내용 레이블
    @IBOutlet weak var detailLabel: UILabel!
    
    /// 경력 레이블
    @IBOutlet weak var careerLabel: UILabel!
    
    /// 학위 레이블
    @IBOutlet weak var degreeLabel: UILabel!
    
    /// 지역 레이블
    @IBOutlet weak var regionLabel: UILabel!
    
    /// 회사 이미지뷰
    @IBOutlet weak var companyImageView: UIImageView!
    
    /// 북마크 이미지뷰
    @IBOutlet weak var bookmarkImageView: UIImageView!
    
    /// 회사 웹사이트 버튼
    @IBOutlet weak var CompanyWebSiteButton: UIButton!
    
    /// 채용정보 데이터
    var job: JobData.Job?
    
    
    /// 로고 이미지를 클릭하면 해당 웹사이트로 이동합니다.
    /// - Parameter sender: CompanyWebSiteButton
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    @IBAction func goToWebSite(_ sender: Any) {
        guard let urlStr = job?.website else { return }
        if let url = URL(string: urlStr) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    
    /// 채용정보 데이터로 셀을 구성합니다.
    /// - Parameter model: 채용정보 데이터
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    func configureCompany(with model: JobData.Job) {
        job = model
        jobFieldLabel.text = model.field
        companyNameLabel.text = model.title
        detailLabel.text = model.detail
        careerLabel.text = model.career
        degreeLabel.text = model.degree
        regionLabel.text = model.region
        fetchImage(with: model.url) { image in
            if let image = image {
                self.companyImageView.image = image
            } else {
                self.companyImageView.image = UIImage(named: "placeholder")
            }
        }
        bookmarkImageView.image = UIImage(systemName: "bookmark")
    }
    
    
    /// 초기화 작업을 진행합니다.
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    override func awakeFromNib() {
        super.awakeFromNib()
        [jobFieldLabel].forEach({
            $0?.layer.cornerRadius = 10
            $0?.layer.masksToBounds = true
        })
    }
}
