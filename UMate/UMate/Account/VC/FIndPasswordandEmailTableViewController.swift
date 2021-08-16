//
//  FIndPasswordandEmailTableViewController.swift
//  FIndPasswordandEmailTableViewController
//
//  Created by 황신택 on 2021/08/09.
//

import UIKit

class FindPasswordandEmailTableViewController: UITableViewController {

    // constraint outlet
    @IBOutlet weak var idLabelCenterX: NSLayoutConstraint!
    @IBOutlet weak var passwordLabelCenterX: NSLayoutConstraint!
    
    // related with text outlet
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var findIdButton: UIButton!
    @IBOutlet weak var infoTextView: UITextView!
    @IBOutlet weak var buttonLabel: UILabel!
    
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func selectedId(_ sender: Any) {
        idLabelCenterX.priority = .defaultHigh
        passwordLabelCenterX.priority = .defaultLow
        emailTextField.placeholder = "가입한 이메일을 입력하세요."
        buttonLabel.text = "아이디 찾기"
        buttonLabel.textColor = .white
        infoTextView.isHidden = false
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
        UIView.transition(with: idLabel, duration: 0.3, options: [.transitionCrossDissolve]) {
            self.idLabel.textColor = .black
            
        }

        UIView.transition(with: passwordLabel, duration: 0.3, options: [.transitionCrossDissolve]) {
            self.passwordLabel.textColor = .systemGray5
            
        }
        
    }
    
    @IBAction func selectedPassword(_ sender: Any) {
        idLabelCenterX.priority = .defaultLow
        passwordLabelCenterX.priority = .defaultHigh
        emailTextField.placeholder = "가입된 아이디를 입력해주세요."
        buttonLabel.text = "비밀번호 찾기"
        buttonLabel.textColor = .white
        infoTextView.isHidden = true
        
        
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
        UIView.transition(with: idLabel, duration: 0.3, options: [.transitionCrossDissolve]) {
            self.idLabel.textColor = .systemGray5
            
        }

        UIView.transition(with: passwordLabel, duration: 0.3, options: [.transitionCrossDissolve]) {
            self.passwordLabel.textColor = .black
            
        }
    }
    
    @IBAction func isCheckedEamilButton(_ sender: Any) {
        guard let email = emailTextField.text,
              email.count > 0,
              isEmailValid(email),
              email.trimmingCharacters(in: .whitespacesAndNewlines) != "" else {
                  alert(title: "알림", message: "올바른 형식의 이메일이 아니거나 없는 이메일입니다")
                  
                  return
              }
    
    }
    
    func isEmailValid(_ email: String) -> Bool {
        if let range = email.range(of: Regex.email, options: [.regularExpression]), (range.lowerBound, range.upperBound) == (email.startIndex, email.endIndex) {
            return true
        }
        
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        findIdButton.setButtonTheme()
        infoTextView.delegate = self
     
    }
   

    
}

extension FindPasswordandEmailTableViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return false
    }
}
