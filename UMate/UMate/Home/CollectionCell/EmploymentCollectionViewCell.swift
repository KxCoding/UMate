//
//  EmploymentCollectionViewCell.swift
//  EmploymentCollectionViewCell
//
//  Created by 황신택 on 2021/09/14.
//

import UIKit
import Loaf

class EmploymentCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var major: UILabel!
    @IBOutlet weak var classification: UILabel!
    @IBOutlet weak var configureButton: UIButton!
    
    var tokens = [NSObjectProtocol]()
    
    /// 직업 조건 콜렉션뷰 둥글게 초기화
    override func awakeFromNib() {
        super.awakeFromNib()
        clipsToBounds = false
        layer.cornerRadius = 20
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 3, height: 3)
        layer.shadowOpacity = 0.5
        
    }
    
    func configureWork(with model: ClassificationWork) {
        classification.text = model.title
        classification.textColor = .lightGray
       let token = NotificationCenter.default.addObserver(forName: .selectedJob, object: nil, queue: .main) { [weak self] noti in
            guard let strongSelf = self else { return }
            guard let workData = noti.userInfo?[UserInfoIdentifires.workData] as? String else { return }
            
            strongSelf.classification.text = workData
            strongSelf.classification.textColor = .black
        }
        
        tokens.append(token)
    }
    
    func configureRegion(with model: ClassificationRegion) {
        classification.text = model.title
        classification.textColor = .lightGray
       let token =  NotificationCenter.default.addObserver(forName: .selectedRegion, object: nil, queue: .main) {[weak self] noti in
            guard let strongSelf = self else { return }
            guard let regionData = noti.userInfo?[UserInfoIdentifires.regionData] as? String else { return }
            
            strongSelf.classification.text = regionData
            strongSelf.classification.textColor = .black
        }
        
        tokens.append(token)
    }
    
    func configureDegree(with model: ClassificationDegree) {
        classification.text = model.title
        classification.textColor = .lightGray
      let token = NotificationCenter.default.addObserver(forName: .selectedDegree, object: nil, queue: .main) { [weak self] noti in
            guard let strongSelf = self else { return }
            guard let degreeData = noti.userInfo?[UserInfoIdentifires.degreeData] as? String else { return }
            strongSelf.classification.text = degreeData
            strongSelf.classification.textColor = .black
        }
        
        tokens.append(token)
    }
    
    func configureCareer(with model: ClassificationCareer) {
        classification.text = model.title
        classification.textColor = .lightGray
       let token =  NotificationCenter.default.addObserver(forName: .selectedCareer, object: nil, queue: .main) { [weak self] noti in
            guard let strongSelf = self else { return }
            guard let careerData = noti.userInfo?[UserInfoIdentifires.careerData] as? String else { return }
            
            strongSelf.classification.text = careerData
            strongSelf.classification.textColor = .black
        }
        tokens.append(token)
        
    }
    
    func configurePlatForm(with model: ClassificationPlatForm) {
        classification.text = model.title
        classification.textColor = .lightGray
       let token = NotificationCenter.default.addObserver(forName: .selectedPlatForm, object: nil, queue: .main) { [weak self] noti in
            guard let storngSelf = self else { return }
            guard let platFormData = noti.userInfo?[UserInfoIdentifires.platFormData] as? String else { return }
            
            storngSelf.classification.text = platFormData
            storngSelf.classification.textColor = .black
        }
        
        tokens.append(token)
    }
    
    deinit {
        for token in tokens {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
}



