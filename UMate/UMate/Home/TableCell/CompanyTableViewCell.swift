//
//  CompanyTableViewCell.swift
//  CompanyTableViewCell
//
//  Created by 황신택 on 2021/09/14.
//

import UIKit

class CompanyTableViewCell: UITableViewCell {

    @IBOutlet weak var fieldLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var careerLabel: UILabel!
    
    @IBOutlet weak var degreeLabel: UILabel!
    
    @IBOutlet weak var regionLabel: UILabel!
    
    
    @IBOutlet weak var companyImage: UIImageView!
    @IBOutlet weak var favoriteImage: UIImageView!
    
    
    /// 셀에 호출할 속성들을 초기화 하는 메소드
    func configureCompany(with model: JobData.Job) {
        fieldLabel.text = model.field
        titleLabel.text = model.title
        detailLabel.text = model.detail
        careerLabel.text = model.career
//        degreeLabel.text = model.degree
        regionLabel.text = model.region
      
        DispatchQueue.global().async {
            guard let url = URL(string: model.image) else { return }
            let image = DataManager.shared.getImage(from: url)
            
            DispatchQueue.main.async {
                self.companyImage.image = image
            }
        }
    
        favoriteImage.image = UIImage(systemName: "bookmark")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        [fieldLabel].forEach({
            $0?.layer.cornerRadius = 10
            $0?.layer.masksToBounds = true
            
        })
        
    }

}


