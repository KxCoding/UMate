//
//  DetailTableViewCell.swift
//  DetailTableViewCell
//
//  Created by Effie on 2021/07/22.
//

import UIKit


/// 상점 상세 정보 셀
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
    
    /// 정보를 표시할 상점
    var target: Place?
    
    
    // MARK: Actions
    
    /// 전화번호 부근을 탭하면 os 전화 기능 실행합니다.
    /// - Parameter sender: 전화번호 레이블 위에 위치한 버튼
    /// - Author: 박혜정(mailmelater11@gmail.com)
    @IBAction func call(_ sender: Any) {
        guard let target = target else { return }
        
        guard let tel = target.tel,
              let url = URL(string: "tel:\(tel)") else { return }
        
        NotificationCenter.default.post(name: .urlOpenHasBeenRequested,
                                        object: nil,
                                        userInfo: [urlOpenRequestNotificationUrlType: URLType.tel, urlOpenRequestNotificationUrl: url])
        
    }
    
    // MARK: Methods
    
    /// 각 뷰에서 표시하는 데이터를 초기화합니다.
    /// - Parameter content: 표시할 내용을 담은 Place 객체
    /// - Author: 박혜정(mailmelater11@gmail.com)
    func configure(with content: Place) {
        target = content
        guard let target = target else { return }
        
        addressLabel.text = target.district
        telLabel.text = target.tel
        
        districtCollectionView.reloadData()
        keywordsCollectionView.reloadData()
    }
    
    
    // MARK: Cell Lifecycle Method
    
    /// 셀이 로드되면 델리게이트를 설정하고 UI를 초기화합니다.
    /// - Author: 박혜정(mailmelater11@gmail.com)
    override func awakeFromNib() {
        super.awakeFromNib()
        
        districtCollectionView.dataSource = self
        keywordsCollectionView.dataSource = self
        
        addressView.configureStyle(with: [.smallRoundedRect])
        [addressView, telView].forEach { $0?.configureStyle(with: [.smallRoundedRect]) }
    }
    
}



// MARK: - Collection view delegation

extension DetailTableViewCell: UICollectionViewDataSource {
    
    /// 지정된 섹션에서 표시할 아이템의 개수를 리턴합니다.
    /// - Parameters:
    ///   - collectionView: 컬렉션 뷰
    ///   - section: 섹션 인덱스
    /// - Returns: 섹션에 포함되는 아이템의 개수
    /// - Author: 박혜정(mailmelater11@gmail.com)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let target = target else { return 0 }
        
        switch collectionView {
        case districtCollectionView:
            return 1
            
        case keywordsCollectionView:
            return target.keywords.count
            
        default:
            return 0
        }
    }
    
    
    /// 지정된 컬렉션 뷰, 지정된 index path에 표시할 셀을 리턴합니다.
    ///
    /// 이미지를 다운로드하고 받은 이미지로 이미지 뷰를 업데이트합니다.
    /// - Parameters:
    ///   - collectionView: 컬렉션 뷰
    ///   - indexPath: 아이템의 index path
    /// - Returns: 표시할 셀
    /// - Author: 박혜정(mailmelater11@gmail.com)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let target = target else { fatalError() }
        
        switch collectionView {
        case districtCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DistrictCollectionViewCell", for: indexPath) as! WordCollectionViewCell
            
            cell.configure(with: target.district)
            
            return cell
        case keywordsCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KeywordsCollectionViewCell", for: indexPath) as! WordCollectionViewCell
            
            cell.configure(with: target.keywords[indexPath.row])
            
            return cell
        default:
            fatalError()
            
        }
    }
    
}
