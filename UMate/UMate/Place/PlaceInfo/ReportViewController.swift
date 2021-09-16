//
//  ReportViewController.swift
//  UMate
//
//  Created by Hyunwoo Jang on 2021/09/17.
//

import UIKit


/// 신고 화면과 관련된 뷰컨트롤러 클래스
/// - Author: 장현우(heoun3089@gmail.com)
class ReportViewController: UIViewController {
    /// 신고 내용을 작성하는 텍스트뷰
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBOutlet weak var reportTextView: UITextView!
    
    /// 텍스트뷰에서 사용할 플레이스홀더 레이블
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBOutlet weak var reportPlaceholderLabel: UILabel!
    
    /// 보내기 버튼을 감싸고 있는 뷰
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBOutlet weak var sendContainerView: UIView!
    
    
    /// 보내기 버튼을 누르면 이전 화면으로 이동합니다.
    /// - Parameter sender: 버튼
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBAction func sendButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    /// 초기화 작업을 실행합니다.
    /// - Author: 장현우(heoun3089@gmail.com)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationItem.title = "리뷰 신고"
        
        sendContainerView.backgroundColor = UIColor(named: "black")
        sendContainerView.tintColor = .white
        sendContainerView.frame.size.height = 40
        sendContainerView.layer.cornerRadius = 10
        sendContainerView.layer.masksToBounds = true
        
        reportTextView.layer.cornerRadius = 10
        reportTextView.becomeFirstResponder()
        reportTextView.delegate = self
    }
}



extension ReportViewController: UITextViewDelegate {
    /// 사용자가 텍스트뷰에서 텍스트 또는 속성을 변경할 때 델리게이트에게 알립니다.
    /// - Parameter textView: 이 메소드를 호출하는 텍스트뷰
    /// - Author: 장현우(heoun3089@gmail.com)
    func textViewDidChange(_ textView: UITextView) {
        reportPlaceholderLabel.isHidden = textView.hasText
    }
}
