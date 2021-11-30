//
//  ReportViewController.swift
//  UMate
//
//  Created by Hyunwoo Jang on 2021/09/17.
//

import UIKit


/// 리뷰 신고 화면
/// - Author: 장현우(heoun3089@gmail.com)
class ReportViewController: UIViewController {
    
    /// 신고 내용 텍스트뷰
    @IBOutlet weak var reportTextView: UITextView!
    
    /// 텍스트뷰 플레이스홀더 레이블
    @IBOutlet weak var reportPlaceholderLabel: UILabel!
    
    /// 보내기 버튼 컨테이너 뷰
    @IBOutlet weak var sendContainerView: UIView!
    
    
    /// 이전 화면으로 이동합니다.
    /// - Parameter sender: 보내기 버튼
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBAction func sendButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    /// 초기화 작업을 실행합니다.
    ///
    /// 네비게이션 타이틀을 리뷰 신고로 설정합니다.
    /// 신고 내용 텍스트뷰와 보내기 버튼 컨테이너 뷰의 UI를 설정합니다.
    /// - Author: 장현우(heoun3089@gmail.com)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "리뷰 신고"
        
        reportTextView.layer.cornerRadius = 10
        reportTextView.becomeFirstResponder()
        reportTextView.delegate = self
        
        sendContainerView.backgroundColor = UIColor(named: "black")
        sendContainerView.tintColor = .white
        sendContainerView.frame.size.height = 40
        sendContainerView.layer.cornerRadius = 10
        sendContainerView.layer.masksToBounds = true
    }
}



/// 텍스트를 작성했을 때 발생하는 이벤트 처리
extension ReportViewController: UITextViewDelegate {
    
    /// 텍스트를 작성하면 호출됩니다.
    ///
    /// 작성한 텍스트가 있는 경우 플레이스 홀더로 사용한 레이블을 숨깁니다.
    /// - Parameter textView: 신고 내용 텍스트뷰
    /// - Author: 장현우(heoun3089@gmail.com)
    func textViewDidChange(_ textView: UITextView) {
        reportPlaceholderLabel.isHidden = textView.hasText
    }
}
