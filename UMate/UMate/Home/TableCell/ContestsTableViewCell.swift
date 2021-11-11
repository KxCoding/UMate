//
//  ContestsTableViewCell.swift
//  UMate
//
//  Created by 황신택 on 2021/10/13.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

/// 대외활동 / 공모전 데이터를 구성하는 셀
/// - Author: 황신택 (sinadsl1457@gmail.com)
class ContestsTableViewCell: CommonTableViewCell {
    /// 분야 레이블
    @IBOutlet weak var contestFieldLabel: PaddingLabel!
    
    /// 설명 레이블
    @IBOutlet weak var contestDescLabel: UILabel!
    
    /// 주최자 레이블
    @IBOutlet weak var institutionLabel: UILabel!
    
    /// 대외활동 포스터 이미지뷰
    @IBOutlet weak var contestImageView: UIImageView!
    
    /// 대외활동 데이터
    var contests: ContestSingleData.Contests?

    
    /// 포스터를 탭하면 대외활동 웹사이트로 이동합니다.
    /// - Parameter sender: 포스터 이미지 버튼
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    @IBAction func goToWebsite(_ sender: Any) {
        guard let urlStr = contests?.website else { return }
        if let url = URL(string: urlStr) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    
    /// 대외활동 데이터를 받아서 아웃렛을 초기화합니다.
    /// - Parameter model: 대외활동 목록 데이터
    func configure(with model: ContestSingleData.Contests) {
        contests = model
        contestFieldLabel.text = model.field
        contestDescLabel.text = model.description
        institutionLabel.text = model.institution
        
        Observable.just(model.url)
            .subscribe(on: backgroundScheduler)
            .compactMap { URL(string: $0) }
            .compactMap { try? Data(contentsOf: $0) }
            .compactMap { UIImage(data: $0) }
            .bind(to: contestImageView.rx.image)
            .disposed(by: rx.disposeBag)
    }
    
    
    /// 초기화 작업을 진행합니다.
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    override func awakeFromNib() {
        super.awakeFromNib()
        [contestFieldLabel].forEach({
            $0?.layer.cornerRadius = 10
            $0?.layer.masksToBounds = true
        })
    }
}
