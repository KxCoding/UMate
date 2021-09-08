//
//  TestInfoWriteTableViewCell.swift
//  UMate
//
//  Created by 남정은 on 2021/09/08.
//

import UIKit
import DropDown

extension Notification.Name {
    static let insertTestInfoInputField = Notification.Name("insertTestInfoInputField")
}


class TestInfoWriteTableViewCell: UITableViewCell {

    var semesters = [String]()
    let testTypes = ["중간고사","기말고사","1차","2차","3차","4차","기타"]
    
    let semestersView = DropDown()
    let testTypesView = DropDown()
    
    var isAppended = false
    
    
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
        
        selectSemesterView.layer.cornerRadius = 10
        selectTestView.layer.cornerRadius = 10
        
        
        testStrategyTextView.delegate = self
        
        testStrategyTextView.layer.cornerRadius = 10
        
       
        
        /// 입력란 추가 버튼 초기화
        addTestInfoButtonView.layer.cornerRadius = 5
        addTestInfoButtonView.layer.borderWidth = 1
        addTestInfoButtonView.layer.borderColor = UIColor.label.cgColor
        
        /// 시험정보 공유 버튼 초기화
        insertTestReviewButton.setButtonTheme()
    }
    

    // MARK: 응시한 시험
    @IBOutlet weak var selectSemesterView: UIView!
    @IBOutlet weak var selectTestView: UIView!
    
    @IBOutlet weak var semesterLabel: UILabel!
    @IBOutlet weak var testLabel: UILabel!
    
    /// 수강학기 선택
    @IBAction func selectSemester(_ sender: Any) {
        semestersView.show()
        semestersView.selectionAction = { [weak self] index, item in
            self?.semesterLabel.text = item
        }
    }
    
    /// 시험 종류 선택
    @IBAction func selectTest(_ sender: Any) {
        testTypesView.show()
        testTypesView.selectionAction = { [weak self] index, item in
            self?.testLabel.text = item
        }
    }
    
    
    func receiveSemestersAndAddDropDownData(openingSemester: [String]) {
        semesters = openingSemester
        
        if !isAppended {
            isAppended = true
            semestersView.dataSource.append(contentsOf: semesters)
            testTypesView.dataSource.append(contentsOf: testTypes)
        }
    }
    
    
    // MARK: 시험 전략
    @IBOutlet weak var testStrategyTextView: UITextView!
    @IBOutlet weak var placeholderLabel: UILabel!
    
    
    // MARK: 문제 유형
    @IBOutlet weak var multipleChoiceButton: RoundedButton!
    @IBOutlet weak var subjectiveButton: RoundedButton!
    @IBOutlet weak var trueAndFalseButton: RoundedButton!
    @IBOutlet weak var AbbreviatedFormButton: RoundedButton!
    @IBOutlet weak var essayTypeButton: RoundedButton!
    @IBOutlet weak var oralStatementButton: RoundedButton!
    @IBOutlet weak var etceteraButton: RoundedButton!
    
    /// 버튼 중복 선택
    @IBAction func selectTypesOfQuestions(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        sender.backgroundColor = sender.isSelected ? .systemRed : .systemGray5
    }
    
    
    // MARK: 문제 예시
    /// 입력란을 담는 스택뷰
    @IBOutlet weak var testInfoStackView: UIStackView!
    
    /// 입력란 추가 뷰
    @IBOutlet weak var addTestInfoButtonView: UIView!
    
    var exampleCount = 2
    /// 입력란 추가
    @IBAction func addTestInfoField(_ sender: Any) {
        if exampleCount < 5 {
            
            exampleCount += 1
            
            let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = NSLayoutConstraint.Axis.horizontal
            stackView.alignment = .center
            stackView.spacing = 9
            
            /// 번호 라벨
            let numberLabel = UILabel()
            numberLabel.translatesAutoresizingMaskIntoConstraints = false
            numberLabel.font = UIFont.preferredFont(forTextStyle: .body)
            numberLabel.adjustsFontForContentSizeCategory = true
            numberLabel.setContentHuggingPriority(.required, for: .horizontal)
            numberLabel.text = "\(exampleCount)."
            
            /// 입력란
            let textField = UITextField()
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.backgroundColor = UIColor(named: "systemGray6BackgroundColor")
            textField.heightAnchor.constraint(equalToConstant: 34).isActive = true
            textField.font = UIFont.preferredFont(forTextStyle: .body)
            textField.setLeftPaddingPoints(7)
            textField.setRightPaddingPoints(10)
            textField.layer.cornerRadius = 5
            textField.layer.borderWidth = 0.5
            textField.layer.borderColor = UIColor.systemGray4.cgColor
            
            stackView.addArrangedSubview(numberLabel)
            stackView.addArrangedSubview(textField)
            
            testInfoStackView.addArrangedSubview(stackView)
            
            NotificationCenter.default.post(name: .insertTestInfoInputField, object: nil)
        }
    }
    
    /// 문제 예시
    var examplesOfQuestions = [String]()
    
    // MARK: 시험정보 공유
    @IBOutlet weak var insertTestReviewButton: UIButton!
    @IBAction func shareTestInfo(_ sender: Any) {
        
        /// 복수선택 할 경우 isSelected가 true인 버튼을 분류해야함.
        let buttonList = [multipleChoiceButton,subjectiveButton,trueAndFalseButton,AbbreviatedFormButton,
                      essayTypeButton,oralStatementButton,etceteraButton]
        
        /// 문제 유형
        let questionTypes = buttonList.filter { button in
            if let button = button {
                return button.isSelected
            }
            return false
        }.map { button -> String in
            if let button = button {
                return button.titleLabel?.text ?? ""
            }
            return ""
        }
        
        /// 문제 예시
        testInfoStackView.arrangedSubviews.forEach { view in
            let textFiled = view.subviews.last as? UITextField
            examplesOfQuestions.append(textFiled?.text ?? "")
            print(">>>>>>>>>subviews>>>>>>>>>>>", textFiled?.text)
        }
        
        /// 시험정보 인스턴스
        let testInfo = TestInfo(semester: semestersView.selectedItem ?? "", testType: testTypesView.selectedItem ?? "", testStrategy: testStrategyTextView.text ?? "", questionTypes: questionTypes, examples: examplesOfQuestions)

        /// tableView에 시험정보 전달하는 노티피케이션
        NotificationCenter.default.post(name: .shareTestInfo, object: nil, userInfo: ["testInfo":testInfo])
    }
}




extension TestInfoWriteTableViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = textView.hasText
    }
}




extension UITextField {
    
    /// UITextField의 좌측 padding을 추가하는 메소드
    /// - Parameter amount: 추가할 padding 값
    func setLeftPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: amount))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    /// UITextField의 우측 padding을 추가하는 메소드
    /// - Parameter amount: 추가할 padding 값
    func setRightPaddingPoints(_ amount:CGFloat) {
         let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
         self.rightView = paddingView
         self.rightViewMode = .always
     }
}

