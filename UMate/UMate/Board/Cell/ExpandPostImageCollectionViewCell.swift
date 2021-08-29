//
//  ExpandPostImageCollectionViewCell.swift
//  ExpandPostImageCollectionViewCell
//
//  Created by 남정은 on 2021/08/11.
//

import UIKit

class ExpandPostImageCollectionViewCell: UICollectionViewCell {
    /// 상세 게시글 화면에서 이미지 클릭시에 보여줄 이미지
    /// 핀치 제스처 등록할 뷰
    @IBOutlet weak var expandImageView: UIImageView!
    /// 탭 제스처를 등록할 뷰
    @IBOutlet weak var imageContentView: UIView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        /// view controller에서 두 번 탭된 것이 감지 됐을 때 옵저버가 등록됨.
        NotificationCenter.default.addObserver(self, selector: #selector(doubleTapped), name: .twiceTapped, object: nil)
    }
    
    
    /// 등록된 옵저버가 감지 될 때마다 실행 될 메소드
    /// 이미지 크기를 원래대로 돌린다.
    @objc func doubleTapped() {
        UIView.animate(withDuration: 0.3) {
            self.expandImageView.transform = CGAffineTransform.identity
        }
    }
}
