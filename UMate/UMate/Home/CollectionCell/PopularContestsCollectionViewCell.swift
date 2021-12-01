//
//  PopularContestsCollectionViewCell.swift
//  UMate
//
//  Created by 황신택 on 2021/10/08.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

/// 인기 대외활동 / 공모전을 표시할 콜렉션 뷰 셀
/// - Author: 황신택 (sinadsl1457@gmail.com)
class PopularContestsCollectionViewCell: UICollectionViewCell {
    /// 대외활동 이미지 뷰
    @IBOutlet weak var contestImageView: UIImageView!
    
    /// 대외활동 내용
    @IBOutlet weak var descLabel: UILabel!
    
    /// 백그라운드 큐
    let backgroundScheduler = ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global())

    /// 대외활동 데이터로 콜렉션 셀을 구성합니다.
    /// - Parameter model: 공모전 및 대외활동 데이터
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    func configure(with model: ContestSingleData.PopularContests) {
        Observable.just(model)
            .subscribe(on: backgroundScheduler)
            .compactMap { URL(string: $0.url) }
            .compactMap { try? Data(contentsOf: $0) }
            .compactMap { UIImage(data: $0) }
            .bind(to: contestImageView.rx.image)
            .disposed(by: rx.disposeBag)
        
        descLabel.text = model.description
    }
    
    
    /// 초기화 작업을 진행합니다.
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}



