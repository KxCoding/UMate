//
//  CompanyTableViewCell.swift
//  CompanyTableViewCell
//
//  Created by 황신택 on 2021/09/14.
//

import UIKit

class CompanyTableViewCell: UITableViewCell {

    @IBOutlet weak var poppularLabel: UILabel!
    @IBOutlet weak var fieldLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var limitedDaysLabel: UILabel!
    @IBOutlet weak var companyImage: UIImageView!
    @IBOutlet weak var favoriteImage: UIImageView!
    
    /// 셀에 호출할 속성들을 초기화 하는 메소드
    func configureCompany(with model: Company) {
        poppularLabel.text = model.popular
        fieldLabel.text = model.field
        titleLabel.text = model.title
        detailLabel.text = model.detail
        limitedDaysLabel.text = model.day
        companyImage.image = UIImage(systemName: model.image)
        favoriteImage.image = UIImage(systemName: model.favoriteImage)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}


