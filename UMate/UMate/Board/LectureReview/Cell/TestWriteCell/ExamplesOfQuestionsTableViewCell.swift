//
//  ExamplesOfQuestionsTableViewCell.swift
//  UMate
//
//  Created by 남정은 on 2021/08/30.
//

import UIKit


extension Notification.Name {
    static let insertTestInfoInputField = Notification.Name("insertTestInfoInputField")
}




class ExamplesOfQuestionsTableViewCell: UITableViewCell {

    @IBOutlet weak var testInfoStackView: UIStackView!
    @IBOutlet weak var insertTestReviewButton: UIButton!
    
    @IBOutlet weak var addTestInfoButtonView: UIView!
    
    var exampleCount = 2
    /// 입력란 추가
    @IBAction func addTestInfoField(_ sender: Any) {
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
        textField.heightAnchor.constraint(equalToConstant: 35).isActive = true
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        /// 추가 버튼 초기화
        addTestInfoButtonView.layer.cornerRadius = 5
        addTestInfoButtonView.layer.borderWidth = 1
        addTestInfoButtonView.layer.borderColor = UIColor.label.cgColor
        
        /// 작성 버튼 초기화
        insertTestReviewButton.setButtonTheme()
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
