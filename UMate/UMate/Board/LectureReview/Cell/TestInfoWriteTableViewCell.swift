//
//  TestInfoWriteTableViewCell.swift
//  UMate
//
//  Created by 남정은 on 2021/09/08.
//

import DropDown
import UIKit


/// 시험정보작성 화면에서 문제예시 입력란 추가와 조건 미충족시 보내는 알림창에대한 노티피케이션
/// - Author: 남정은
extension Notification.Name {
    static let insertTestInfoInputField = Notification.Name("insertTestInfoInputField")
    static let sendAlert = Notification.Name("sendAlert")
}



/// 시험정보작성을 위한 테이블 뷰 셀
/// - Author: 남정은
class TestInfoWriteTableViewCell: UITableViewCell {
    // MARK: 응시한 시험
    /// 수강학기 선택
    @IBOutlet weak var selectSemesterView: UIView!
    @IBOutlet weak var selectTestView: UIView!
    @IBAction func selectSemester(_ sender: Any) {
        semestersView.show()
        semestersView.selectionAction = { [weak self] index, item in
            self?.semesterLabel.text = item
        }
    }
    
    
    /// 시험종류 선택
    @IBOutlet weak var semesterLabel: UILabel!
    @IBOutlet weak var testLabel: UILabel!
    @IBAction func selectTest(_ sender: Any) {
        testTypesView.show()
        testTypesView.selectionAction = { [weak self] index, item in
            self?.testLabel.text = item
        }
    }
    
    
    // MARK: 시험 전략
    @IBOutlet weak var testStrategyTextView: UITextView!
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
    
    
    /// 버튼 중복 선택
    @IBAction func selectTypesOfQuestions(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        sender.backgroundColor = sender.isSelected ? .systemRed : .systemGray5
    }
    
    
    // MARK: 문제 예시
    /// 문제 예시를 적는 첫번째 텍스트 필드
    @IBOutlet weak var firstTextField: UITextField!
    
    
    /// 추가버튼을 누를 시 추가되는 텍스트 필드가 담긴 스택 뷰
    @IBOutlet weak var thirdTextFieldStackView: UIStackView!
    @IBOutlet weak var fourthTextFieldStackView: UIStackView!
    @IBOutlet weak var fifthTextFieldStackView: UIStackView!
    
    
    /// 입력란 추가 뷰
    @IBOutlet weak var addTestInfoButtonView: UIView!
    @IBOutlet weak var testInfoStackView: UIStackView!
    
    
    /// 문제예시 번호
    var exampleNumber = 3
    
    
    /// 입력란 추가
    @IBAction func addTestInfoField(_ sender: Any) {
        let textFieldList = [thirdTextFieldStackView, fourthTextFieldStackView, fifthTextFieldStackView]
        
        if exampleNumber <= 5 {
            textFieldList[exampleNumber - 3]?.isHidden = false
            
                /// 입력란을 추가할 때 보내는 노티피케이션
            NotificationCenter.default.post(name: .insertTestInfoInputField, object: nil)
        }
        exampleNumber += 1
    }
    
    
    // MARK: 시험정보 공유
    @IBOutlet weak var insertTestReviewButton: UIButton!
    
    /// 문제 예시들을 담는 배열
    var examplesOfQuestions = [String]()
    
    
    @IBAction func shareTestInfo(_ sender: Any) {
        
        /// 복수선택 할 경우 isSelected가 true인 버튼을 분류해야함.
        let buttonList = [multipleChoiceButton,subjectiveButton,trueAndFalseButton,AbbreviatedFormButton,
                      essayTypeButton,oralStatementButton,etceteraButton]
        
        let selectedButton = buttonList.filter { button in
            if let button = button {
                return button.isSelected
            }
            return false
        }
        
        /// 수강학기 미선택시
        if semestersView.selectedItem == nil {
            NotificationCenter.default.post(name: .sendAlert, object: nil, userInfo: ["alertKey":0])
        }
        /// 시험죵류 미선택시
        else if testTypesView.selectedItem == nil {
            NotificationCenter.default.post(name: .sendAlert, object: nil, userInfo: ["alertKey":1])
        }
        /// 시험전략 미작성시
        else if testStrategyTextView.text.count < 20 {
            NotificationCenter.default.post(name: .sendAlert, object: nil, userInfo: ["alertKey":2])
        }
        /// 문제유형 미선택시
        else if selectedButton.count == 0 {
            NotificationCenter.default.post(name: .sendAlert, object: nil, userInfo: ["alertKey":3])
        }
        /// 문제예시 미작성시
        else if !firstTextField.hasText {
            NotificationCenter.default.post(name: .sendAlert, object: nil, userInfo: ["alertKey":4])
        }
        /// 다 입력했을 경우
        else {
            /// 문제 유형
            let questionTypes = selectedButton.map { button -> String in
                if let button = button {
                    return button.titleLabel?.text ?? ""
                }
                return ""
            }
            
            /// 문제 예시
            testInfoStackView.arrangedSubviews.forEach { view in
                let textField = view.subviews.last as? UITextField
                examplesOfQuestions.append(textField?.text ?? "")
            }
            
            /// 시험정보 인스턴스
            let testInfo = TestInfo(semester: semestersView.selectedItem ?? "", testType: testTypesView.selectedItem ?? "", testStrategy: testStrategyTextView.text ?? "", questionTypes: questionTypes, examples: examplesOfQuestions)

            /// 테이블 뷰에 시험정보 전달하는 노티피케이션
            NotificationCenter.default.post(name: .shareTestInfo, object: nil, userInfo: ["testInfo":testInfo])
        }
    }
    
    
    /// 강의가 개설된 학기를 담는 배열
    var semesters = [String]()
    
    /// 시험 종류를 담는 배열
    let testTypes = ["중간고사","기말고사","1차","2차","3차","4차","기타"]
    
    /// 수강학기와 시험종류에대한 뷰
    let semestersView = DropDown()
    let testTypesView = DropDown()
    
    /// 데이터를 한 번만 추가하기 위한 속성
    var isAppended = false
    
    
    /// 수강학기에 대한 정보를 받아오고 드롭다운 뷰에 데이터를 저장
    /// - Parameter openingSemester: 강의가 개설된 학기를 담은 배열
    func receiveSemestersAndAddDropDownData(openingSemester: [String]) {
        semesters = openingSemester
        
        if !isAppended {
            isAppended = true
            semestersView.dataSource.append(contentsOf: semesters)
            testTypesView.dataSource.append(contentsOf: testTypes)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        /// 수강학기 drop down view 설정
        semestersView.anchorView = selectSemesterView
        guard let height = semestersView.anchorView?.plainView.bounds.height else { return }
        semestersView.bottomOffset = CGPoint(x: 0, y: height)
        semestersView.width = 150
        semestersView.backgroundColor = UIColor.init(named: "systemGray6BackgroundColor")
        semestersView.textColor = .label
        
        
        /// 시험종류 drop down view 설정
        testTypesView.anchorView = selectTestView
        guard let height = testTypesView.anchorView?.plainView.bounds.height else { return }
        testTypesView.bottomOffset = CGPoint(x: 0, y: height)
        testTypesView.width = 150
        testTypesView.backgroundColor = UIColor.init(named: "systemGray6BackgroundColor")
        testTypesView.textColor = .label
        
        
        /// 입력란 추가 버튼 초기화
        addTestInfoButtonView.layer.cornerRadius = 5
        addTestInfoButtonView.layer.borderWidth = 1
        addTestInfoButtonView.layer.borderColor = UIColor.label.cgColor
        
        
        /// 뷰의 모서리 깎기
        selectSemesterView.layer.cornerRadius = 10
        selectTestView.layer.cornerRadius = 10
        
        
        /// 텍스트 뷰 델리게이트 설정
        testStrategyTextView.delegate = self
        
        /// 시험전략 설정
        testStrategyTextView.layer.cornerRadius = 10
        
        /// 시험정보 공유 버튼 초기화
        insertTestReviewButton.setButtonTheme()
    }
}



/// 텍스트 뷰에대한 동작 처리
/// - Author: 남정은
extension TestInfoWriteTableViewCell: UITextViewDelegate {
    /// 텍스트 뷰가 편집중이라면 설명 레이블 숨김
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = textView.hasText
    }
}






