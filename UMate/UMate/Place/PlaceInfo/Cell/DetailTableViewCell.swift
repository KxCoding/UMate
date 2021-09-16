//
//  DetailTableViewCell.swift
//  DetailTableViewCell
//
//  Created by Effie on 2021/07/22.
//

import UIKit


/// 가게 상세 정보를 표시하는 탭의 셀 클래스
/// - Author: 박혜정(mailmelater11@gmail.com)
class DetailTableViewCell: UITableViewCell {
    
    // MARK: Outlets
    
    /// 주소 레이블
    @IBOutlet weak var addressLabel: UILabel!
    
    /// 주소 레이블 컨테이너 뷰
    @IBOutlet weak var addressView: UIView!
    
    /// 인근 지역을 나열하는 컬렉션 뷰
    @IBOutlet weak var districtCollectionView: UICollectionView!
    
    /// 키워드 컬렉션 뷰
    @IBOutlet weak var keywordsCollectionView: UICollectionView!
    
    /// 전화번호 레이블
    @IBOutlet weak var telLabel: UILabel!
    
    /// 전화번호 레이블 컨테이너 뷰
    @IBOutlet weak var telView: UIView!
    
    
    // MARK: Properties
    
    /// 정보를 표시할 가게
    var target: Place!
    
    
    // MARK: Actions
    
    /// 전화번호 레이블 부근을 탭하면 os 전화 기능 실행
    /// - Parameter sender: 탭한 버튼
    @IBAction func call(_ sender: Any) {
        guard let tel = target.tel,
              let url = URL(string: "tel:\(tel)") else { return }
        
        // notification 전송
        NotificationCenter.default.post(name: .openUrl, object: nil, userInfo: ["type": URLType.tel, "url": url])
        
    }
    
    // MARK: Methods
    
    /// 셀 내부 각 뷰들이 표시하는 content 초기화
    /// - Parameter content: 표시할 내용을 담은 Place 객체
    func configure(with content: Place, indexPath: IndexPath) {
        target = content
        
        addressLabel.text = target.district
        telLabel.text = target.tel
        
        districtCollectionView.reloadData()
        keywordsCollectionView.reloadData()
    }
   
    
    // MARK: Cell Lifecycle Method
    
    /// 셀 초기화
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // data source 연결
        districtCollectionView.dataSource = self
        keywordsCollectionView.dataSource = self
        
        // UI 초기화
        addressView.configureStyle(with: [.smallRoundedRect])
        [addressView, telView].forEach { $0?.configureStyle(with: [.smallRoundedRect]) }
    }
    
}



// MARK: - Collection view delegation

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
