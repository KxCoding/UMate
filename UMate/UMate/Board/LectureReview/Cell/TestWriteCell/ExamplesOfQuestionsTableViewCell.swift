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
        stackView.spacing = 10
        
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
