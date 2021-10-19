//
//  ReviewWriteTableViewController.swift
//  ReviewWriteTableViewController
//
//  Created by Hyunwoo Jang on 2021/07/20.
//

import Loaf
import UIKit


extension Notification.Name {
    /// 리뷰 작성 화면에서 확인 버튼을 누르면 보낼 노티피케이션
    /// - Author: 장현우(heoun3089@gmail.com)
    static let reviewWillApplied = Notification.Name(rawValue: "reviewWillApplied")
}



/// 리뷰 작성 화면
/// - Author: 장현우(heoun3089@gmail.com)
class ReviewWriteTableViewController: UITableViewController {
    
    /// 리뷰 쓰기와 리뷰 수정을 구분해서 표시할 레이블
    ///
    /// 새로 리뷰를 작성하면 리뷰 쓰기를 레이블에 표시합니다.
    /// 이미 작성한 리뷰를 수정하면 리뷰 수정을 레이블에 표시합니다.
    @IBOutlet weak var mainTitleLabel: UILabel!
    
    /// 확인 버튼
    @IBOutlet weak var reviewSaveButton: UIButton!
    
    /// 리뷰 텍스트뷰
    @IBOutlet weak var reviewTextView: UITextView!
    
    /// 텍스트뷰 플레이스홀더 레이블
    @IBOutlet weak var reviewPlaceholderLabel: UILabel!
    
    /// 리뷰 데이터
    ///
    /// 리뷰 수정 화면에서 전달됩니다.
    var reviewData: PlaceReviewItem?
    
    /// 상점 이름
    ///
    /// 이전 화면에서 전달됩니다.
    var placeName: String?
    
    
    /// 이전 화면으로 이동합니다.
    /// - Parameter sender: X 버튼
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    /// 리뷰가 저장되고 이전 화면으로 이동합니다.
    ///
    /// 항목을 모두 작성하지 않으면 리뷰가 추가되지 않고 경고창을 띄웁니다.
    /// - Parameter sender: 확인 버튼
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBAction func reviewSaveButtonTapped(_ sender: Any) {
        guard deliciousButton.isSelected || freshButton.isSelected || cleanButton.isSelected
                || plainButton.isSelected || saltyButton.isSelected else {
            alertLoafMessage(message: "맛 관련 평가를 작성해주세요.")
            return
        }
        
        guard kindButton.isSelected || unkindButton.isSelected || touchyButton.isSelected else {
            alertLoafMessage(message: "서비스 관련 평가를 작성해주세요.")
            return
        }
        
        guard quietButton.isSelected || emotionalButton.isSelected || simpleButton.isSelected
                || cuteButton.isSelected || clearButton.isSelected else {
                    alertLoafMessage(message: "분위기 관련 평가를 작성해주세요.")
            return
        }
        
        guard cheapButton.isSelected || affordableButton.isSelected || expensiveButton.isSelected else {
            alertLoafMessage(message: "가격 관련 평가를 작성해주세요.")
            return
        }
        
        guard smallButton.isSelected || suitableButton.isSelected || plentyButton.isSelected else {
            alertLoafMessage(message: "음식양 관련 평가를 작성해주세요.")
            return
        }
        
        guard onePointButton.isSelected || twoPointButton.isSelected || threePointButton.isSelected
                || fourPointButton.isSelected || fivePointButton.isSelected else {
                    alertLoafMessage(message: "총평 관련 평가를 작성해주세요.")
            return
        }
        
        if !reviewTextView.hasText {
            alertLoafMessage(message: "리뷰를 작성해주세요.") { _ in
                self.reviewTextView.becomeFirstResponder()
            }
            return
        }
        
        // 저장할 리뷰 데이터
        var taste = PlaceReviewItem.Taste.clean
        
        if deliciousButton.isSelected {
            taste = .delicious
        } else if freshButton.isSelected {
            taste = .fresh
        } else if cleanButton.isSelected {
            taste = .clean
        } else if plainButton.isSelected {
            taste = .plain
        } else {
            taste = .salty
        }
        
        guard let placeName = placeName else { return }

        let review = PlaceReviewItem(reviewText: reviewTextView.text,
                                     date: Date(),
                                     image: UIImage(named: "search_02"),
                                     placeName: placeName,
                                     starPoint: 4.5,
                                     taste: taste,
                                     service: .touchy,
                                     mood: .cute,
                                     price: .affordable,
                                     amount: .plenty,
                                     totalPoint: .fivePoint,
                                     recommendationCount: 20)
        
        PlaceReviewItem.dummyData.insert(review, at: 0)
        
        NotificationCenter.default.post(name: .reviewWillApplied, object: nil, userInfo: nil)
        
        dismiss(animated: true)
    }
    
    
    // MARK: 맛 관련 그룹
    /// 맛있다 버튼
    @IBOutlet weak var deliciousButton: RoundedButton!
    
    /// 신선하다 버튼
    @IBOutlet weak var freshButton: RoundedButton!
    
    /// 깔끔하다 버튼
    @IBOutlet weak var cleanButton: RoundedButton!
    
    /// 고소하다 버튼
    @IBOutlet weak var plainButton: RoundedButton!
    
    /// 짜다 버튼
    @IBOutlet weak var saltyButton: RoundedButton!
    
    
    /// 태그에 따라 각 버튼이 Selected 상태로 변경됩니다.
    ///
    /// Selected 상태에 따라 버튼의 백그라운드 색상을 설정합니다.
    /// - Parameter sender: 맛 관련 그룹 버튼
    @IBAction func tasteSelectLineButtonTapped(_ sender: RoundedButton) {
        deliciousButton.isSelected = sender.tag == 100
        freshButton.isSelected = sender.tag == 101
        cleanButton.isSelected = sender.tag == 102
        plainButton.isSelected = sender.tag == 103
        saltyButton.isSelected = sender.tag == 104
        
        [deliciousButton, freshButton, cleanButton, plainButton, saltyButton].forEach { button in
            guard let button = button else { return }
            
            button.backgroundColor = button.isSelected ? .systemRed : .systemGray5
        }
    }
    
    
    // MARK: 서비스 관련 그룹
    /// 친절함 버튼
    @IBOutlet weak var kindButton: RoundedButton!
    
    /// 불친절함 버튼
    @IBOutlet weak var unkindButton: RoundedButton!
    
    /// 까칠함 버튼
    @IBOutlet weak var touchyButton: RoundedButton!
    
    
    /// 태그에 따라 각 버튼이 Selected 상태로 변경됩니다.
    ///
    /// Selected 상태에 따라 버튼의 백그라운드 색상을 설정합니다.
    /// - Parameter sender: 서비스 관련 그룹 버튼
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBAction func serviceSelectLineButtonTapped(_ sender: RoundedButton) {
        kindButton.isSelected = sender.tag == 200
        unkindButton.isSelected = sender.tag == 201
        touchyButton.isSelected = sender.tag == 202
        
        [kindButton, unkindButton, touchyButton].forEach { button in
            guard let button = button else { return }
            
            button.backgroundColor = button.isSelected ? .systemRed : .systemGray5
        }
    }
    
    
    // MARK: 분위기 관련 그룹
    /// 조용한 관련 버튼
    @IBOutlet weak var quietButton: RoundedButton!
    
    /// 감성적인 관련 버튼
    @IBOutlet weak var emotionalButton: RoundedButton!
    
    /// 심플한 관련 버튼
    @IBOutlet weak var simpleButton: RoundedButton!
    
    /// 아기자기한 관련 버튼
    @IBOutlet weak var cuteButton: RoundedButton!
    
    /// 깔끔한 관련 버튼
    @IBOutlet weak var clearButton: RoundedButton!
    
    
    /// 태그에 따라 각 버튼이 Selected 상태로 변경됩니다.
    ///
    /// Selected 상태에 따라 버튼의 백그라운드 색상을 설정합니다.
    /// - Parameter sender: 분위기 관련 그룹 버튼
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBAction func moodSelectLineButtonTapped(_ sender: RoundedButton) {
        quietButton.isSelected = sender.tag == 300
        emotionalButton.isSelected = sender.tag == 301
        simpleButton.isSelected = sender.tag == 302
        cuteButton.isSelected = sender.tag == 303
        clearButton.isSelected = sender.tag == 304
        
        [quietButton, emotionalButton, simpleButton, cuteButton, clearButton].forEach { button in
            guard let button = button else { return }
            
            button.backgroundColor = button.isSelected ? .systemRed : .systemGray5
        }
    }
    
    
    // MARK: 가격 관련 그룹
    
    /// 저렴하다 버튼
    @IBOutlet weak var cheapButton: RoundedButton!
    
    /// 적당하다 버튼
    @IBOutlet weak var affordableButton: RoundedButton!
    
    /// 푸짐하다 버튼
    @IBOutlet weak var expensiveButton: RoundedButton!
    
    
    /// 태그에 따라 각 버튼이 Selected 상태로 변경됩니다.
    ///
    /// Selected 상태에 따라 버튼의 백그라운드 색상을 설정합니다.
    /// - Parameter sender: 가격 관련 그룹 버튼
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBAction func priceSelectLineButtonTapped(_ sender: RoundedButton) {
        cheapButton.isSelected = sender.tag == 400
        affordableButton.isSelected = sender.tag == 401
        expensiveButton.isSelected = sender.tag == 402
        
        [cheapButton, affordableButton, expensiveButton].forEach { button in
            guard let button = button else { return }
            
            button.backgroundColor = button.isSelected ? .systemRed : .systemGray5
        }
    }
    
    
    // MARK: 음식양 관련 그룹
    
    /// 적다 버튼
    @IBOutlet weak var smallButton: RoundedButton!
    
    /// 적당하다 버튼
    @IBOutlet weak var suitableButton: RoundedButton!
    
    /// 푸짐하다 버튼
    @IBOutlet weak var plentyButton: RoundedButton!
    
    
    /// 태그에 따라 각 버튼이 Selected 상태로 변경됩니다.
    ///
    /// Selected 상태에 따라 버튼의 백그라운드 색상을 설정합니다.
    /// - Parameter sender: 음식양 관련 그룹 버튼
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBAction func amountSelectLineButtonTapped(_ sender: RoundedButton) {
        smallButton.isSelected = sender.tag == 500
        suitableButton.isSelected = sender.tag == 501
        plentyButton.isSelected = sender.tag == 502
        
        [smallButton, suitableButton, plentyButton].forEach { button in
            guard let button = button else { return }
            
            button.backgroundColor = button.isSelected ? .systemRed : .systemGray5
        }
    }
    
    
    // MARK: - 총평 관련 그룹
    
    /// 1점 버튼
    @IBOutlet weak var onePointButton: RoundedButton!
    
    /// 2점 버튼
    @IBOutlet weak var twoPointButton: RoundedButton!
    
    /// 3점 버튼
    @IBOutlet weak var threePointButton: RoundedButton!
    
    /// 4점 버튼
    @IBOutlet weak var fourPointButton: RoundedButton!
    
    /// 5점 버튼
    @IBOutlet weak var fivePointButton: RoundedButton!
    
    
    /// 태그에 따라 각 버튼이 Selected 상태로 변경됩니다.
    ///
    /// Selected 상태에 따라 버튼의 백그라운드 색상을 설정합니다.
    /// - Parameter sender: 총평 관련 그룹 버튼
    /// - Author: 장현우(heoun3089@gmail.com)
    @IBAction func generalReviewButtonTapped(_ sender: RoundedButton) {
        onePointButton.isSelected = sender.tag == 600
        twoPointButton.isSelected = sender.tag == 601
        threePointButton.isSelected = sender.tag == 602
        fourPointButton.isSelected = sender.tag == 603
        fivePointButton.isSelected = sender.tag == 604
        
        [onePointButton, twoPointButton, threePointButton, fourPointButton, fivePointButton].forEach { button in
            guard let button = button else { return }
            
            button.backgroundColor = button.isSelected ? .systemRed : .systemGray5
        }
    }
    
    
    /// 경고창을 표시합니다.
    /// - Parameters:
    ///   - message: 표시할 메시지
    ///   - handler: 완료 블록
    /// - Author: 장현우(heoun3089@gmail.com)
    func alertLoafMessage(message: String, handler: ((Loaf.DismissalReason) -> Void)? = nil) {
        let reviewLoaf = Loaf(message, state: .warning, location: .bottom, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self)
        
        reviewLoaf.show(.short, completionHandler: handler)
    }
    
    
    /// 리뷰 수정 화면을 띄웁니다.
    ///
    /// 리뷰 수정 텍스트를 메인 타이틀에 표시하고 데이터에 맞게 버튼을 Selected 상태로 변경합니다.
    /// - Author: 장현우(heoun3089@gmail.com)
    func editReview() {
        if let reviewData = reviewData {
            mainTitleLabel.text = "리뷰 수정"
            
            // 맛
            switch reviewData.taste {
            case .delicious:
                deliciousButton.isSelected = true
                deliciousButton.backgroundColor = .systemRed
                
            case .fresh:
                freshButton.isSelected = true
                freshButton.backgroundColor = .systemRed
                
            case .clean:
                cleanButton.isSelected = true
                cleanButton.backgroundColor = .systemRed
                
            case .plain:
                plainButton.isSelected = true
                plainButton.backgroundColor = .systemRed
                
            case .salty:
                saltyButton.isSelected = true
                saltyButton.backgroundColor = .systemRed
            }
            
            // 서비스
            switch reviewData.service {
            case .kind:
                kindButton.isSelected = true
                kindButton.backgroundColor = .systemRed
                
            case .unkind:
                unkindButton.isSelected = true
                unkindButton.backgroundColor = .systemRed
                
            case .touchy:
                touchyButton.isSelected = true
                touchyButton.backgroundColor = .systemRed
            }
            
            // 분위기
            switch reviewData.mood {
            case .quiet:
                quietButton.isSelected = true
                quietButton.backgroundColor = .systemRed
                
            case .emotional:
                emotionalButton.isSelected = true
                emotionalButton.backgroundColor = .systemRed
                
            case .simple:
                simpleButton.isSelected = true
                simpleButton.backgroundColor = .systemRed
                
            case .cute:
                cuteButton.isSelected = true
                cuteButton.backgroundColor = .systemRed
                
            case .clear:
                clearButton.isSelected = true
                clearButton.backgroundColor = .systemRed
            }
            
            // 가격
            switch reviewData.price {
            case .cheap:
                cheapButton.isSelected = true
                cheapButton.backgroundColor = .systemRed
                
            case .affordable:
                affordableButton.isSelected = true
                affordableButton.backgroundColor = .systemRed
                
            case .expensive:
                expensiveButton.isSelected = true
                expensiveButton.backgroundColor = .systemRed
            }
            
            // 음식양
            switch reviewData.amount {
            case .small:
                smallButton.isSelected = true
                smallButton.backgroundColor = .systemRed
                
            case .suitable:
                suitableButton.isSelected = true
                suitableButton.backgroundColor = .systemRed
                
            case .plenty:
                plentyButton.isSelected = true
                plentyButton.backgroundColor = .systemRed
            }
            
            // 총평
            switch reviewData.totalPoint {
            case .onePoint:
                onePointButton.isSelected = true
                onePointButton.backgroundColor = .systemRed
                
            case .twoPoint:
                twoPointButton.isSelected = true
                twoPointButton.backgroundColor = .systemRed
                
            case .threePoint:
                threePointButton.isSelected = true
                threePointButton.backgroundColor = .systemRed
                
            case .fourPoint:
                fourPointButton.isSelected = true
                fourPointButton.backgroundColor = .systemRed
                
            case .fivePoint:
                fivePointButton.isSelected = true
                fivePointButton.backgroundColor = .systemRed
            }
            
            // 리뷰 텍스트
            reviewPlaceholderLabel.isHidden = true
            reviewTextView.text = reviewData.reviewText
        }
    }
    
    
    /// 초기화 작업을 실행합니다.
    ///
    /// 이전 화면에서 리뷰 데이터를 전달 받으면 리뷰 수정 화면을 표시하고 데이터를 초기화합니다.
    /// - Author: 장현우(heoun3089@gmail.com)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reviewSaveButton.setToEnabledButtonTheme()
        reviewTextView.layer.cornerRadius = 10
        
        reviewTextView.delegate = self
        
        editReview()
    }
    
    
    /// 헤더 뷰의 높이를 리턴합니다.
    /// - Parameters:
    ///   - tableView: 리뷰 작성 테이블뷰
    ///   - section: 섹션 인덱스
    /// - Returns: 헤더 뷰의 높이
    /// - Author: 장현우(heoun3089@gmail.com)
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .zero
    }
    
    
    /// 푸터 뷰의 높이를 리턴합니다.
    /// - Parameters:
    ///   - tableView: 리뷰 작성 테이블뷰
    ///   - section: 섹션 인덱스
    /// - Returns: 푸터 뷰의 높이
    /// - Author: 장현우(heoun3089@gmail.com)
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .zero
    }
}



/// 텍스트를 작성했을 때 발생하는 이벤트 처리
extension ReviewWriteTableViewController: UITextViewDelegate {
    
    /// 텍스트를 작성하면 호출됩니다.
    ///
    /// 작성한 텍스트가 있는 경우 플레이스 홀더로 사용한 레이블을 숨깁니다.
    /// - Parameter textView: 리뷰 텍스트뷰
    /// - Author: 장현우(heoun3089@gmail.com)
    func textViewDidChange(_ textView: UITextView) {
        reviewPlaceholderLabel.isHidden = textView.hasText
    }
}
