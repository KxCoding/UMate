//
//  TestInfoWriteTableViewCell.swift
//  UMate
//
//  Created by 남정은 on 2021/09/08.
//

import DropDown
import UIKit


/// 시험정보 작성 화면에서 문제예시 입력란 추가와 조건 미충족 시 보내는 알림창에 대한 노티피케이션
/// - Author: 남정은(dlsl7080@gmail.com)
extension Notification.Name {
    static let testInfoInputFieldDidInsert = Notification.Name("insertTestInfoInputField")
    static let testInfoAlertDidSend = Notification.Name("testInfoAlertDidSend")
    static let wirteTestInfoCheckingAlertDidSend = Notification.Name("wirteTestInfoCheckingAlertDidSend")
}



/// 시험정보 작성을 위한 테이블 뷰 셀
/// - Author: 남정은(dlsl7080@gmail.com)
class TestInfoWriteTableViewCell: UITableViewCell {
    // MARK: 응시한 시험
    /// 수강학기 선택 뷰
    @IBOutlet weak var selectSemesterView: UIView!
    
    /// '수강학기' 레이블
    @IBOutlet weak var semesterLabel: UILabel!
    
    /// 수강학기를 선택합니다.
    /// - Parameter sender: '수강학기 선택' 버튼
    /// - Author: 남정은(dlsl7080@gmail.com)
    @IBAction func selectSemester(_ sender: Any) {
        semestersView.show()
        semestersView.selectionAction = { [weak self] index, item in
            self?.semesterLabel.text = item
        }
    }
    
    
    /// 시험종류 선택 뷰
    @IBOutlet weak var selectTestView: UIView!
    
    /// '시험종류' 레이블
    @IBOutlet weak var testLabel: UILabel!
    
    /// 시험종류를 선택합니다.
    /// - Parameter sender: '시험종류 선택' 버튼
    /// - Author: 남정은(dlsl7080@gmail.com)
    @IBAction func selectTest(_ sender: Any) {
        testTypesView.show()
        testTypesView.selectionAction = { [weak self] index, item in
            self?.testLabel.text = item
        }
    }
    
    
    // MARK: 시험 전략
    /// 시험 전략을 작성하는 텍스트 뷰
    @IBOutlet weak var testStrategyTextView: UITextView!
    
    /// 시험 전략에 대한 간단한 설명 레이블
    @IBOutlet weak var placeholderLabel: UILabel!
    
    
    // MARK: 문제 유형
    /// 객관식 버튼
    @IBOutlet weak var multipleChoiceButton: RoundedButton!
    
    /// 주관식 버튼
    @IBOutlet weak var subjectiveButton: RoundedButton!
    
    /// T/F 유형 버튼
    @IBOutlet weak var trueAndFalseButton: RoundedButton!
    
    /// 약술형 버튼
    @IBOutlet weak var AbbreviatedFormButton: RoundedButton!
    
    /// 논술형 버튼
    @IBOutlet weak var essayTypeButton: RoundedButton!
    
    /// 구술 버튼
    @IBOutlet weak var oralStatementButton: RoundedButton!
    
    /// 기타 버튼
    @IBOutlet weak var etceteraButton: RoundedButton!
    
    
    /// 문제유형을 선택합니다. 복수선택이 가능합니다.
    /// - Parameter sender: 문제유형 버튼
    /// - Author: 남정은(dlsl7080@gmail.com)
    @IBAction func selectTypesOfQuestions(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        sender.backgroundColor = sender.isSelected ? .systemRed : .systemGray5
    }
    
    
    // MARK: 문제 예시
    /// 문제 예시를 적는 첫번째 텍스트 필드
    @IBOutlet weak var firstTextField: UITextField!
    
    
    /// '더 입력하기' 버튼을 누를 시 추가되는 텍스트 필드가 담긴 스택 뷰
    @IBOutlet weak var thirdTextFieldStackView: UIStackView!
    @IBOutlet weak var fourthTextFieldStackView: UIStackView!
    @IBOutlet weak var fifthTextFieldStackView: UIStackView!
    
    
    /// '더 입력하기'버튼을 감싸는 뷰
    @IBOutlet weak var addTestInfoButtonView: UIView!
    
    /// 문제 예시를 입력하는 텍스트 필드가 담긴 스택 뷰
    @IBOutlet weak var testExampleStackView: UIStackView!
    
    
    /// 문제 예시 번호
    var exampleNumber = 3
    
    /// 문제 예시를 입력하는 텍스트 필드를 추가합니다.
    /// - Parameter sender: '더 입력하기' 버튼
    /// - Author: 남정은(dlsl7080@gmail.com)
    @IBAction func addTestInfoField(_ sender: Any) {
        let textFieldList = [thirdTextFieldStackView, fourthTextFieldStackView, fifthTextFieldStackView]
        
        if exampleNumber <= 5 {
            textFieldList[exampleNumber - 3]?.isHidden = false
            
            // 입력란을 추가할 때 보내는 노티피케이션
            NotificationCenter.default.post(name: .testInfoInputFieldDidInsert, object: nil)
        }
        exampleNumber += 1
    }
    
    
    // MARK: 시험정보 공유
    /// '공유하기' 버튼
    @IBOutlet weak var insertTestReviewButton: UIButton!
    
    /// 문제 예시들을 담는 배열
    var examplesOfQuestions = [String]()
    
    
    /// 시험정보를 지정된 강의에 등록합니다.
    /// - Parameter sender: '공유하기'버튼
    /// - Author: 남정은(dlsl7080@gmail.com)
    @IBAction func shareTestInfo(_ sender: Any) {
        
        let buttonList = [multipleChoiceButton,subjectiveButton,trueAndFalseButton,AbbreviatedFormButton,
                      essayTypeButton,oralStatementButton,etceteraButton]
        
        let selectedButton = buttonList.filter { button in
            if let button = button {
                return button.isSelected
            }
            return false
        }
        
        // 수강학기 미선택시
        if semestersView.selectedItem == nil {
            NotificationCenter.default.post(name: .testInfoAlertDidSend, object: nil, userInfo: ["alertKey":0])
        }
        // 시험죵류 미선택시
        else if testTypesView.selectedItem == nil {
            NotificationCenter.default.post(name: .testInfoAlertDidSend, object: nil, userInfo: ["alertKey":1])
        }
        // 시험전략 미작성시
        else if testStrategyTextView.text.count < 20 {
            NotificationCenter.default.post(name: .testInfoAlertDidSend, object: nil, userInfo: ["alertKey":2])
        }
        // 문제유형 미선택시
        else if selectedButton.count == 0 {
            NotificationCenter.default.post(name: .testInfoAlertDidSend, object: nil, userInfo: ["alertKey":3])
        }
        // 문제예시 미작성시
        else if firstTextField.text?.count ?? 0 < 5 {
            NotificationCenter.default.post(name: .testInfoAlertDidSend, object: nil, userInfo: ["alertKey":4])
        }
        // 다 입력했을 경우
        else {
            // 문제 유형
            let questionTypes = selectedButton.map { button -> String in
                if let button = button {
                    return button.titleLabel?.text?.trimmingCharacters(in: .whitespaces) ?? ""
                }
                return ""
            }
            
            // 문제 예시
            testExampleStackView.arrangedSubviews.forEach { view in
                let textField = view.subviews.last as? UITextField
                if let content = textField?.text?.trimmingCharacters(in: .whitespaces), !content.isEmpty {
                    examplesOfQuestions.append(content)
                }
            }
            
            let questionTypesStr = questionTypes.map{ $0.trimmingCharacters(in: .whitespaces)}.joined(separator: ",")
            
            let newTestInfo = TestInfoPostData(testInfoId: 0, lectureInfoId: lectureInfoId, semester: semestersView.selectedItem ?? "", testType: testTypesView.selectedItem ?? "", testStrategy: testStrategyTextView.text ?? "", questionTypes: questionTypesStr, examples: examplesOfQuestions, createdAt: BoardDataManager.shared.postDateFormatter.string(from: Date()))
            
            NotificationCenter.default.post(name: .wirteTestInfoCheckingAlertDidSend, object: nil, userInfo: ["testInfo": newTestInfo])
        }
    }
    
    
    /// 강의가 개설된 학기를 담는 배열
    var semesters = [String]()
    
    /// 시험 종류를 담는 배열
    let testTypes = ["중간고사","기말고사","1차","2차","3차","4차","기타"]
    
    /// 수강학기와 시험종류에 대한 뷰
    let semestersView = DropDown()
    let testTypesView = DropDown()
    
    /// 데이터를 한 번만 추가하기 위한 속성
    var isAppended = false
    
    /// 강의 정보 Id
    var lectureInfoId = 0
    
    
    /// 강의에 대한 정보를 받아오고 드롭다운 뷰에 데이터를 저장합니다.
    /// - Parameter openingSemester: 강의가 개설된 학기를 담은 배열
    /// - Author: 남정은(dlsl7080@gmail.com)
    func receiveSemestersAndAddDropDownData(lecture: LectureInfoDetailResponse.LectrueInfo) {
        // 개설학기를 담는 배열
        let semesters = lecture.semesters.components(separatedBy: "/")
        self.semesters = semesters
        self.lectureInfoId = lecture.lectureInfoId
        
        if !isAppended {
            isAppended = true
            semestersView.dataSource.append(contentsOf: semesters)
            testTypesView.dataSource.append(contentsOf: testTypes)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 수강학기 drop down view 설정
        semestersView.anchorView = selectSemesterView
        guard let height = semestersView.anchorView?.plainView.bounds.height else { return }
        semestersView.bottomOffset = CGPoint(x: 0, y: height)
        semestersView.width = 150
        semestersView.backgroundColor = UIColor.init(named: "systemGray6BackgroundColor")
        semestersView.textColor = .label
        
        
        // 시험종류 drop down view 설정
        testTypesView.anchorView = selectTestView
        guard let height = testTypesView.anchorView?.plainView.bounds.height else { return }
        testTypesView.bottomOffset = CGPoint(x: 0, y: height)
        testTypesView.width = 150
        testTypesView.backgroundColor = UIColor.init(named: "systemGray6BackgroundColor")
        testTypesView.textColor = .label
        
        
        // '더 입력하기' 버튼 초기화
        addTestInfoButtonView.layer.cornerRadius = 5
        addTestInfoButtonView.layer.borderWidth = 1
        addTestInfoButtonView.layer.borderColor = UIColor.label.cgColor
        
        
        // 뷰의 모서리 깎기
        selectSemesterView.layer.cornerRadius = 10
        selectTestView.layer.cornerRadius = 10
        
        
        // 텍스트 뷰 델리게이트 설정
        testStrategyTextView.delegate = self
        
        // 시험전략 설정
        testStrategyTextView.layer.cornerRadius = 10
        
        // '공유하기' 버튼 초기화
        insertTestReviewButton.setToEnabledButtonTheme()
    }
}



/// 텍스트 뷰 동작 처리
/// - Author: 남정은(dlsl7080@gmail.com)
extension TestInfoWriteTableViewCell: UITextViewDelegate {
    /// 텍스트 뷰가 편집 중이라면 설명 레이블을 숨깁니다.
    /// - Parameter textView: 시험 전략을 작성하는 텍스트 뷰
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = textView.hasText
    }
}






