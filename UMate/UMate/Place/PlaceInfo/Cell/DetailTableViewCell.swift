//
//  DetailTableViewCell.swift
//  DetailTableViewCell
//
//  Created by Effie on 2021/07/22.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var districtCollectionView: UICollectionView!
    @IBOutlet weak var keywordsCollectionView: UICollectionView!
    @IBOutlet weak var telLabel: UILabel!
    @IBOutlet weak var telView: UIView!
    
    
    /// 정보를 표시할 가게
    var target: Place!
    
    /// 셀 내부 각 뷰들이 표시하는 content 초기화
    /// - Parameter content: 표시할 내용을 담은 Place 객체
    func configure(with content: Place, indexPath: IndexPath) {
        target = content
        
        addressLabel.text = target.district
        telLabel.text = target.tel
        
        districtCollectionView.reloadData()
        keywordsCollectionView.reloadData()
        
    }
   
    
    /// 셀 초기화
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // data source 연결
        districtCollectionView.dataSource = self
        keywordsCollectionView.dataSource = self
        
        // UI 초기화
        addressView.configureStyle(with: [.squircleSmall])
        [addressView, telView].forEach { $0?.configureStyle(with: [.squircleSmall]) }
    }
    
    
    /// 전화번호 레이블 부근을 탭하면 os 전화 기능 실행
    /// - Parameter sender: 탭한 버튼
    @IBAction func call(_ sender: Any) {
        guard let tel = target.tel,
              let url = URL(string: "tel:\(tel)") else { return }
        
        NotificationCenter.default.post(name: .openUrl, object: nil, userInfo: ["type": URLType.tel, "url": url])
        
    }
    
}




extension DetailTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
            
        case districtCollectionView:
            return 1
            
        case keywordsCollectionView:
            return target.keywords.count
            
        default:
            return 0
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
            
        case districtCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DistrictCollectionViewCell", for: indexPath) as! DistrictCollectionViewCell
            
            cell.configure(with: target, indexPath: indexPath)
            
            return cell
            
        case keywordsCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KeywordsCollectionViewCell", for: indexPath) as! KeywordsCollectionViewCell
            
            cell.configure(with: target, indexPath: indexPath)
            
            return cell
            
        default:
            fatalError()
            
        }
    }
    
}
