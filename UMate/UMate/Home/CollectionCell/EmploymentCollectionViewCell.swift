//
//  EmploymentCollectionViewCell.swift
//  EmploymentCollectionViewCell
//
//  Created by 황신택 on 2021/09/14.
//

import UIKit

class EmploymentCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var major: UILabel!
    @IBOutlet weak var classification: UILabel!
    @IBOutlet weak var configureButton: UIButton!
    
    
    /// 직업 조건 콜렉션뷰 둥글게 초기화
    override func awakeFromNib() {
        super.awakeFromNib()
        clipsToBounds = false
        layer.cornerRadius = 20
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 3, height: 3)
        layer.shadowOpacity = 0.5
    
    }
    
    func configure(with model: Classification) {
        NotificationCenter.default.addObserver(forName: .selectedJob, object: nil, queue: .main) { [weak self] noti in
            guard let storngSelf = self else { return }
            guard let jobdata = noti.userInfo?[UserInfoIdentifires.fistJobData] as? String else { return }
            
            storngSelf.major.text = model.title
            storngSelf.classification.text = jobdata
        }
        
    }
}



