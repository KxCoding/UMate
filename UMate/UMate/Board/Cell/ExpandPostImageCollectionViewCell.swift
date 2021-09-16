//
//  ExpandPostImageCollectionViewCell.swift
//  ExpandPostImageCollectionViewCell
//
//  Created by 남정은 on 2021/08/11.
//

import UIKit


/// 이미지 확대화면에대한 컬렉션 셀
/// - Author: 남정은
class ExpandPostImageCollectionViewCell: UICollectionViewCell {
    /// 상세 게시글 화면에서 이미지 클릭시에 보여줄 이미지
    /// 핀치 제스처 등록할 뷰
    @IBOutlet weak var expandImageView: UIImageView!
    /// 탭 제스처를 등록할 뷰
    @IBOutlet weak var imageContentView: UIView!
    

    override func awakeFromNib() {
        
        super.awakeFromNib()
        /// 이미지 확대 제스처
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        expandImageView.addGestureRecognizer(pinchGesture)
        
        /// 이미지 크기를 원래대로 되돌리는 제스처
        let tpaGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        imageContentView.addGestureRecognizer(tpaGesture)
    }
    
    
    /// 등록된 옵저버가 감지 될 때마다 실행 될 메소드
    /// 이미지 크기를 원래대로 돌린다.
    @objc func doubleTapped() {
        UIView.animate(withDuration: 0.3) {
            self.expandImageView.transform = CGAffineTransform.identity
        }
    }
    
    /// 이미지 뷰에 제스처가 인지될 때 호출
    /// - Parameter gestureRecognizer: 제스처를 인식하는 객체
    @objc func handlePinch(_ gestureRecognizer: UIPinchGestureRecognizer) {
        guard gestureRecognizer.view != nil else { return }
        
        /// 제스처가 인지되고 있을 때 제스처가 등록된 view에서 scale만큼 변형이 생김
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            guard let view = gestureRecognizer.view else { return }
            
            gestureRecognizer.view?.transform = view.transform.scaledBy(x: gestureRecognizer.scale,
                                                                        y: gestureRecognizer.scale)
            
            gestureRecognizer.scale = 1
        }
    }
}
