//
//  TypesOfQuestionsTableViewCell.swift
//  UMate
//
//  Created by 남정은 on 2021/08/30.
//

import UIKit

class TypesOfQuestionsTableViewCell: UITableViewCell {

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
    
    
    var buttonList: [UIButton]?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        /// 복수선택 할 경우 isSelected가 true인 버튼을 분류해야함.
        buttonList = [multipleChoiceButton,subjectiveButton,trueAndFalseButton,AbbreviatedFormButton,
                      essayTypeButton,oralStatementButton,etceteraButton]
    }
}
