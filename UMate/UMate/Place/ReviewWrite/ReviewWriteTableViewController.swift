//
//  ReviewWriteTableViewController.swift
//  ReviewWriteTableViewController
//
//  Created by Hyunwoo Jang on 2021/07/20.
//

import UIKit

extension Notification.Name {
    static let reviewWillApplied = Notification.Name(rawValue: "reviewWillApplied")
}




class ReviewWriteTableViewController: UITableViewController {
    /// 확인 버튼
    @IBOutlet weak var reviewSaveButton: UIButton!
    /// 리뷰를 작성하는 텍스트뷰
    @IBOutlet weak var reviewTextView: UITextView!
    /// 텍스트뷰에서 사용할 placeholder 레이블
    @IBOutlet weak var reviewPlaceholderLabel: UILabel!
    
    
    /// 초기화 작업을 실행합니다.
    override func viewDidLoad() {
        super.viewDidLoad()
        /// reviewSaveButton의 CornerRadius 설정
        reviewSaveButton.setButtonTheme()
        reviewTextView.layer.cornerRadius = 10
        
        reviewTextView.delegate = self
    }
    
    
    /// X 버튼을 누르면 이전 화면으로 이동합니다.
    /// - Parameter sender: 버튼
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    /// 확인 버튼을 누르면 이전 화면으로 이동합니다.
    /// - Parameter sender: 버튼
    @IBAction func reviewSaveButtonTapped(_ sender: Any) {
        /// 리뷰를 모두 작성하지 않으면 리뷰가 추가되지 않고 알림창을 띄웁니다.
        guard deliciousButton.isSelected || freshButton.isSelected || cleanButton.isSelected
                || plainButton.isSelected || saltyButton.isSelected else {
            alert(title: "알림", message: "맛 관련 평가를 작성해주세요.")
            return
        }
        
        guard kindButton.isSelected || unkindButton.isSelected || touchyButton.isSelected else {
            alert(title: "알림", message: "서비스 관련 평가를 작성해주세요.")
            return
        }
        
        guard quietButton.isSelected || emotionalButton.isSelected || simpleButton.isSelected
                || cuteButton.isSelected || clearButton.isSelected else {
            alert(title: "알림", message: "분위기 관련 평가를 작성해주세요.")
            return
        }
        
        guard cheapButton.isSelected || affordableButton.isSelected || expensiveButton.isSelected else {
            alert(title: "알림", message: "가격 관련 평가를 작성해주세요.")
            return
        }
        
        guard smallButton.isSelected || suitableButton.isSelected || plentyButton.isSelected else {
            alert(title: "알림", message: "음식양 관련 평가를 작성해주세요.")
            return
        }
        
        guard onePointButton.isSelected || twoPointButton.isSelected || threePointButton.isSelected
                || fourPointButton.isSelected || fivePointButton.isSelected else {
            alert(title: "알림", message: "총평 관련 평가를 작성해주세요.")
            return
        }
        
        if !reviewTextView.hasText {
            alert(title: "알림", message: "리뷰를 작성해주세요.") { _ in
                self.reviewTextView.becomeFirstResponder()
            }
            return
        }
        
        /// 저장할 리뷰 데이터
        let reviewData = PlaceReviewItem.UserReview(reviewText: reviewTextView.text, date: Date().reviewDate, image: nil, placeName: "")
        PlaceReviewItem.dummyData.insert(reviewData, at: 0)
        
        NotificationCenter.default.post(name: .reviewWillApplied, object: nil, userInfo: nil)
        
        dismiss(animated: true)
    }
    
    
    // MARK: 맛 관련 그룹
    @IBOutlet weak var deliciousButton: RoundedButton!
    @IBOutlet weak var freshButton: RoundedButton!
    @IBOutlet weak var cleanButton: RoundedButton!
    @IBOutlet weak var plainButton: RoundedButton!
    @IBOutlet weak var saltyButton: RoundedButton!
    
    
    /// 태그에 따라 각 버튼이 Selected 상태로 변경됩니다.
    /// - Parameter sender: 맛 관련 그룹 버튼
    @IBAction func tasteSelectLineButtonTapped(_ sender: RoundedButton) {
        deliciousButton.isSelected = sender.tag == 100
        freshButton.isSelected = sender.tag == 101
        cleanButton.isSelected = sender.tag == 102
        plainButton.isSelected = sender.tag == 103
        saltyButton.isSelected = sender.tag == 104
        
        /// Selected 상태에 따라 버튼의 백그라운드 색상 설정
        [deliciousButton, freshButton, cleanButton, plainButton, saltyButton].forEach { button in
            guard let button = button else { return }
            
            button.backgroundColor = button.isSelected ? .systemRed : .systemGray5
        }
    }
    
    
    // MARK: 서비스 관련 그룹
    @IBOutlet weak var kindButton: RoundedButton!
    @IBOutlet weak var unkindButton: RoundedButton!
    @IBOutlet weak var touchyButton: RoundedButton!
    
    
    /// 태그에 따라 각 버튼이 Selected 상태로 변경됩니다.
    /// - Parameter sender: 서비스 관련 그룹 버튼
    @IBAction func serviceSelectLineButtonTapped(_ sender: RoundedButton) {
        kindButton.isSelected = sender.tag == 200
        unkindButton.isSelected = sender.tag == 201
        touchyButton.isSelected = sender.tag == 202
        
        /// Selected 상태에 따라 버튼의 백그라운드 색상 설정
        [kindButton, unkindButton, touchyButton].forEach { button in
            guard let button = button else { return }
            
            button.backgroundColor = button.isSelected ? .systemRed : .systemGray5
        }
    }
    
    
    // MARK: 분위기 관련 그룹
    @IBOutlet weak var quietButton: RoundedButton!
    @IBOutlet weak var emotionalButton: RoundedButton!
    @IBOutlet weak var simpleButton: RoundedButton!
    @IBOutlet weak var cuteButton: RoundedButton!
    @IBOutlet weak var clearButton: RoundedButton!
    
    
    /// 태그에 따라 각 버튼이 Selected 상태로 변경됩니다.
    /// - Parameter sender: 분위기 관련 그룹 버튼
    @IBAction func moodSelectLineButtonTapped(_ sender: RoundedButton) {
        quietButton.isSelected = sender.tag == 300
        emotionalButton.isSelected = sender.tag == 301
        simpleButton.isSelected = sender.tag == 302
        cuteButton.isSelected = sender.tag == 303
        clearButton.isSelected = sender.tag == 304
        
        /// Selected 상태에 따라 버튼의 백그라운드 색상 설정
        [quietButton, emotionalButton, simpleButton, cuteButton, clearButton].forEach { button in
            guard let button = button else { return }
            
            button.backgroundColor = button.isSelected ? .systemRed : .systemGray5
        }
    }
    
    
    // MARK: 가격 관련 그룹
    @IBOutlet weak var cheapButton: RoundedButton!
    @IBOutlet weak var affordableButton: RoundedButton!
    @IBOutlet weak var expensiveButton: RoundedButton!
    
    
    /// 태그에 따라 각 버튼이 Selected 상태로 변경됩니다.
    /// - Parameter sender: 가격 관련 그룹 버튼
    @IBAction func priceSelectLineButtonTapped(_ sender: RoundedButton) {
        cheapButton.isSelected = sender.tag == 400
        affordableButton.isSelected = sender.tag == 401
        expensiveButton.isSelected = sender.tag == 402
        
        /// Selected 상태에 따라 버튼의 백그라운드 색상 설정
        [cheapButton, affordableButton, expensiveButton].forEach { button in
            guard let button = button else { return }
            
            button.backgroundColor = button.isSelected ? .systemRed : .systemGray5
        }
    }
    
    
    // MARK: 음식양 관련 그룹
    @IBOutlet weak var smallButton: RoundedButton!
    @IBOutlet weak var suitableButton: RoundedButton!
    @IBOutlet weak var plentyButton: RoundedButton!
    
    
    /// 태그에 따라 각 버튼이 Selected 상태로 변경됩니다.
    /// - Parameter sender: 음식양 관련 그룹 버튼
    @IBAction func amountSelectLineButtonTapped(_ sender: RoundedButton) {
        smallButton.isSelected = sender.tag == 500
        suitableButton.isSelected = sender.tag == 501
        plentyButton.isSelected = sender.tag == 502
        
        /// Selected 상태에 따라 버튼의 백그라운드 색상 설정
        [smallButton, suitableButton, plentyButton].forEach { button in
            guard let button = button else { return }
            
            button.backgroundColor = button.isSelected ? .systemRed : .systemGray5
        }
    }
    
    
    // MARK: - 총평 관련 그룹
    @IBOutlet weak var onePointButton: RoundedButton!
    @IBOutlet weak var twoPointButton: RoundedButton!
    @IBOutlet weak var threePointButton: RoundedButton!
    @IBOutlet weak var fourPointButton: RoundedButton!
    @IBOutlet weak var fivePointButton: RoundedButton!
    
    
    /// 태그에 따라 각 버튼이 Selected 상태로 변경됩니다.
    /// - Parameter sender: 총평 관련 그룹 버튼
    @IBAction func generalReviewButtonTapped(_ sender: RoundedButton) {
        onePointButton.isSelected = sender.tag == 600
        twoPointButton.isSelected = sender.tag == 601
        threePointButton.isSelected = sender.tag == 602
        fourPointButton.isSelected = sender.tag == 603
        fivePointButton.isSelected = sender.tag == 604
        
        /// Selected 상태에 따라 버튼의 백그라운드 색상 설정
        [onePointButton, twoPointButton, threePointButton, fourPointButton, fivePointButton].forEach { button in
            guard let button = button else { return }
            
            button.backgroundColor = button.isSelected ? .systemRed : .systemGray5
        }
    }
    
    
    /// 델리게이트에게 특정 섹션의 사용할 header의 높이를 물어봅니다.
    /// - Parameters:
    ///   - tableView: 이 메소드를 호출하는 테이블뷰
    ///   - section: 테이블뷰 섹션을 식별하는 Index 번호
    /// - Returns: 섹션 header의 높이
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .zero
    }
    
    
    /// 델리게이트에게 특정 섹션의 사용할 footer의 높이를 물어봅니다.
    /// - Parameters:
    ///   - tableView: 이 메소드를 호출하는 테이블뷰
    ///   - section: 테이블뷰 섹션을 식별하는 Index 번호
    /// - Returns: 섹션 footer의 높이
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .zero
    }
}




extension ReviewWriteTableViewController: UITextViewDelegate {
    /// 사용자가 텍스트뷰에서 텍스트 또는 속성을 변경할 때 델리게이트에게 알립니다.
    /// - Parameter textView: 이 메소드를 호출하는 텍스트뷰
    func textViewDidChange(_ textView: UITextView) {
        reviewPlaceholderLabel.isHidden = textView.hasText
    }
}
