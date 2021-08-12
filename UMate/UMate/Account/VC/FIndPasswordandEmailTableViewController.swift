//
//  FIndPasswordandEmailTableViewController.swift
//  FIndPasswordandEmailTableViewController
//
//  Created by 황신택 on 2021/08/09.
//

import UIKit

class FindPasswordandEmailTableViewController: UITableViewController {

    @IBOutlet weak var idLabelCenterX: NSLayoutConstraint!
    @IBOutlet weak var passwordLabelCenterX: NSLayoutConstraint!
    
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
        emailTextField.placeholder = "가입된 이메일"
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
        emailTextField.placeholder = "가입된 아이디"
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
     
    }
   

    
}
