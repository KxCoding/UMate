//
//  FIndPasswordandEmailTableViewController.swift
//  FIndPasswordandEmailTableViewController
//
//  Created by 황신택 on 2021/08/09.
//

import UIKit

/// 비밀번호 이메일 찾기 화면
/// - Author: 황신택 (sinadsl1457@gmail.com)
class FindPasswordAndEmailTableViewController: UITableViewController {
    /// 아이디 레이블 수평 가운데 제약
    /// 애니메이션 효과를 주기 위해서 사용합니다.
    @IBOutlet weak var idLabelCenterX: NSLayoutConstraint!
    
    /// 비밀번호 레이블 수평 가운데 제약
    /// 애니메이션 효과를 주기 위해서 사용합니다.
    @IBOutlet weak var passwordLabelCenterX: NSLayoutConstraint!
    
    /// 아이디 레이블
    @IBOutlet weak var idLabel: UILabel!
    
    /// 패스워드 레이블
    @IBOutlet weak var passwordLabel: UILabel!
    
    /// 이메일 필드
    @IBOutlet weak var emailTextField: UITextField!
    
    /// 아이디 찾기 버튼
    @IBOutlet weak var findIdButton: UIButton!
    
    /// 정보 텍스트 뷰
    @IBOutlet weak var infoTextView: UITextView!
    
    /// 아이디 찾기 버튼 레이블
    @IBOutlet weak var buttonLabel: UILabel!
    
    /// 좌우로 움직이는 뷰
    @IBOutlet weak var activatedBar: UIView!
    
    
    /// 이전 화면으로 이동합니다.
    /// - Parameter sender: cancelButton
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
    }
    

    /// 아이디 레이블을 탭 하면 막대의 위치를 아이디 레이블로 이동시킵니다.
    /// - Parameter sender: 아이디 버튼
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    @IBAction func didTapId(_ sender: Any) {
        makeMoveContraints(idPriority: .defaultHigh,
                                  pwPriority: .defaultLow,
                                  textField: "가입한 이메일을 입력하세요",
                                  labelText: "아이디 찾기",
                                  isHidden: false)
    }
    
    
    /// 비밀번호 레이블을 탭 하면 막대의 위치를 비밀번호 레이블로 이동시킵니다.
    /// - Parameter sender: 패스워드 버튼
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    @IBAction func didTapPassword(_ sender: Any) {
        makeMoveContraints(idPriority: .defaultLow,
                                 pwPriority: .defaultHigh,
                                 textField: "가입한 아이디를 입력해주세요.",
                                 labelText: "비밀번호 찾기",
                                 isHidden: true)
    }
    
    
    /// 누르는 탭 항목에 따라서 아웃렛 속성을 바꾸게 합니다.
    /// - Parameters:
    ///   - idPriority: id 아웃렛 NSLayoutConstraint Priority
    ///   - pwPriority: password 아웃렛 NSLayoutConstraint Priority
    ///   - textField: textField의 placeholder
    ///   - labelText: 탭 label의 text
    ///   - isHidden: InfoTextView의 isHidden
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    func makeMoveContraints(idPriority: UILayoutPriority, pwPriority: UILayoutPriority, textField: String, labelText: String, isHidden: Bool) {
        // priority의 값을 high, low로 토글하면서 좌우 애니메이션 효과를 줍니다.
        idLabelCenterX.priority = idPriority
        passwordLabelCenterX.priority = pwPriority
    
        emailTextField.placeholder = textField
        buttonLabel.text = labelText
        
        infoTextView.isHidden = isHidden
        
        // activatedBar의 다크 모드 라이트 모드를 지원합니다.
        activatedBar.backgroundColor = UIColor.dynamicColor(light: .black, dark: .lightGray)
        
        // 애니메이션을 실행합니다.
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        // label의 라이트 모드 다크 모드 컬러를 지원합니다.
        // 아이디 레이블과 비밀번호 레이블의 컬러를 다르게 하여 애니메이션 효과를 줍니다.
        UIView.transition(with: idLabel, duration: 0.3, options: [.transitionCrossDissolve]) {
            self.idLabel.textColor = UIColor.dynamicColor(light: .black, dark: .white)
        }
        UIView.transition(with: passwordLabel, duration: 0.3, options: [.transitionCrossDissolve]) {
            self.passwordLabel.textColor = UIColor.dynamicColor(light: .systemGray6, dark: .darkGray)
        }
    }
    
    
    /// 이메일을 검증하고 검증에 성공하면 아이디를 이메일로 발송합니다.
    /// - Parameter sender: 아이디 버튼
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    @IBAction func checkToEmailCondtions(_ sender: Any) {
        guard let email = emailTextField.text,
              email.count > 0,
              isEmailValid(email),
              email.trimmingCharacters(in: .whitespacesAndNewlines) != "" else {
                  alert(title: "알림", message: "올바른 형식의 이메일이 아니거나 없는 이메일입니다")
                  return
              }
    }
    
    
    /// 초기화 작업을 진행합니다.
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    override func viewDidLoad() {
        super.viewDidLoad()
        findIdButton.setToEnabledButtonTheme()
        
        activatedBar.backgroundColor = UIColor.dynamicColor(light: .black, dark: .lightGray)
        
        navigationItem.leftBarButtonItem?.tintColor = UIColor.dynamicColor(light: .black, dark: .lightGray)
    }
}


