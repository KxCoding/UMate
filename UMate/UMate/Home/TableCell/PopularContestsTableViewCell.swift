//
//  PopularContestsTableViewCell.swift
//  UMate
//
//  Created by 황신택 on 2021/10/08.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

/// 인기 대외활동 / 공모전 데이터를 구성하는 셀
/// - Author: 황신택 (sinadsl1457@gmail.com)
class PopularContestsTableViewCell: UITableViewCell {
    /// 인기 대외활동 데이터 모델
    var list = [ContestSingleData.PopularContests]()

    /// 인기 대외활동 콜렉션 뷰
    @IBOutlet weak var listCollectionView: UICollectionView!
    
    
    /// 대외활동 VC에 있는 데이터를 파라미터로 전달 받습니다.
    /// - Parameter models: 인기 대외활동 데이터 리스트
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    func configure(with models: [ContestSingleData.PopularContests] ) {
        DispatchQueue.global().async {
            self.list = models
            DispatchQueue.main.async {
                self.listCollectionView.reloadData()
            }
        }
    }
    
    
    /// 인기 대외활동을 탭하면 관련 사이트로 이동합니다.
    /// 컬렉션 뷰 안에 있는 뷰의 좌표를 초기화합니다. 초기화 함으로써 사용자가 탭 하면 올바른 위치를 인식합니다.
    /// - Parameter sender: UIButton
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    @IBAction func goToWebsite(_ sender: UIButton) {
        let position = sender.convert(CGPoint.zero, to: listCollectionView)
        Observable.just(position)
            .compactMap { self.listCollectionView.indexPathForItem(at: $0) }
            .compactMap { self.list[$0.item].website }
            .compactMap { URL(string: $0) }
            .subscribe(onNext: {
                UIApplication.shared.open($0, options: [:], completionHandler: nil)
            })
            .disposed(by: rx.disposeBag)
    }
    
    
    /// 초기화 작업은 진행합니다.
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }
}


extension PopularContestsTableViewCell: UICollectionViewDataSource {
    ///  섹션에 로우의 개수를 지정합니다.
    /// - Parameters:
    ///   - tableView: 해당 정보를 요청한 테이블뷰
    ///   - section: 섹션의 위치
    /// - Returns: 콜렉션 뷰에 표시할 섹션 수를 리턴합니다.
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }


    /// 셀에 데이터를 지정합니다.
    /// 테이블 뷰 셀 안의 콜렉션 뷰 셀로 데이터를 전달합니다.
    /// - Parameters:
    ///   - collectionView: 관련 요청을 보낸 콜렉션 뷰
    ///   - indexPath: 셀의 indexPath
    /// - Returns: 인기 대외활동 데이터가 표시된 셀이 리턴됩니다.
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularContestsCollectionViewCell", for: indexPath) as! PopularContestsCollectionViewCell
        let model = list[indexPath.row]

        cell.configure(with: model)

        return cell
    }
}



extension PopularContestsTableViewCell: UICollectionViewDelegateFlowLayout {
    /// 델리게이트에게 지정된 아이템의 셀의 사이즈를 물어봅니다.
    /// - Parameters:
    ///   - collectionView: 레이아웃을 표시하는 콜렉션 뷰
    ///   - collectionViewLayout: 정보를 요청한 레이아웃 객체
    ///   - indexPath: 아이템의 위치를 나타내는 indexPath
    /// - Returns: 셀 사이즈
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return .zero}
        
        let width = (collectionView.frame.width - (flowLayout.minimumInteritemSpacing + flowLayout.sectionInset.left + flowLayout.sectionInset.right)) / 2
        
        let height = width * 1.4
        
        return CGSize(width: Int(width), height: Int(height))
    }
}
