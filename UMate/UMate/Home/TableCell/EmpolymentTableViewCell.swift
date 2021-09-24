//
//  EmpolymentTableViewCell.swift
//  EmpolymentTableViewCell
//
//  Created by 황신택 on 2021/09/14.
//

import UIKit

extension Notification.Name {
    static let DidTapWillShowList = Notification.Name("DidTapWillShowList")
}

/// 테이블뷰 셀에 콜렉션뷰를 구현하는 클래스
class EmploymentTableViewCell: UITableViewCell {

    @IBOutlet weak var listCollectionView: UICollectionView!
    /// 직무 설계를 배열로 선언
    var list = [ItemType]()
    var didTapButton = UIButton()

    /// EmploymentInfoViewController에 있는 Classificationllist를 전달 받고 초기화 함.
    func configure(with models: [ItemType]) {
        self.list = models
        listCollectionView.reloadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
}

extension EmploymentTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmploymentCollectionViewCell", for: indexPath) as! EmploymentCollectionViewCell
        let itemType = list[indexPath.item]
        
        switch itemType {
        case .work(let model):
            cell.configureWork(with: model)
        case .region(let model):
            cell.configureRegion(with: model)
        case .degree(let model):
            cell.configureDegree(with: model)
        case .career(let model):
            cell.configureCareer(with: model)
        case .platForm(let model):
            cell.configurePlatForm(with: model)
        }
       

        return cell
    }
    
    
}


extension EmploymentTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return .zero }
        let width: CGFloat = (collectionView.frame.width - (flowLayout.minimumInteritemSpacing + flowLayout.sectionInset.left + flowLayout.sectionInset.right)) / 4
        
        let height = width * 0.4
        
        return CGSize(width: Int(width), height: Int(height))
    }
}
