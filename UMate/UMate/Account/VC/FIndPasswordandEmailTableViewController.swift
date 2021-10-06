//
//  FIndPasswordandEmailTableViewController.swift
//  FIndPasswordandEmailTableViewController
//
//  Created by 황신택 on 2021/08/09.
//

import UIKit

/// 비밀번호 이메일 찾기 화면
/// Author: 황신택 (sinadsl1457@gmail.com)
class FindPasswordAndEmailTableViewController: UITableViewController {
    /// 아이디 레이블 수평 가운데 제약
    /// 애니메이션 효과를 주기위해서 사용 합니다.
    @IBOutlet weak var idLabelCenterX: NSLayoutConstraint!
    
    /// 비밀번호 레이블 수평 가운데 제약
    /// 애니메이션 효과를 주기위해서 사용 합니다.
    @IBOutlet weak var passwordLabelCenterX: NSLayoutConstraint!
    
    /// ID 레이블
    @IBOutlet weak var idLabel: UILabel!
    
    /// PW 레이블
    @IBOutlet weak var passwordLabel: UILabel!
    
    /// Email  필드
    @IBOutlet weak var emailTextField: UITextField!
    
    /// 아이디 찾기 버튼
    @IBOutlet weak var findIdButton: UIButton!
    
    /// Information 텍스트뷰
    @IBOutlet weak var infoTextView: UITextView!
    
    /// Button이름을 레이블
    @IBOutlet weak var buttonLabel: UILabel!
    
    /// 좌우로 움직이는 뷰
    @IBOutlet weak var activatedBar: UIView!
    
    
    /// 이전화면으로 갑니다.
    /// - Parameter sender: cancelButton
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
    }
    

    /// 아이디란을 탭할시 activatedBar 뷰의 수평가운데 제약에 우선순위 CH/ CR 값을 토글하면서 애니메이션효과를 줍니다.
    /// - Parameter sender: 아이디 버튼에 전달
    /// 황신택 (sinadsl1457@gmail.com)
    @IBAction func didTapId(_ sender: Any) {
        // Priority의 값을 high, low로 토글하면서 좌우 애니매이션 효과를 줍니다.
        idLabelCenterX.priority = .defaultHigh
        passwordLabelCenterX.priority = .defaultLow
    
        // 텍스트를 초기화합니다.
        emailTextField.placeholder = "가입한 이메일을 입력하세요."
        buttonLabel.text = "아이디 찾기"
        
        infoTextView.isHidden = false
        
        // activatedBar 다크모드 라이트모드 지원 합니다.
        activatedBar.backgroundColor = UIColor.dynamicColor(light: .black, dark: .lightGray)
        
        // view의 애니메이션 효과를 줍니다
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
        // label의 라이트 모드 다크모드 컬러를 지원합니다.
        // 아이디 레이블과 비밀번호 레이블의 컬러를 다르게하여 애니메이션 효과룰 줍니다.
        UIView.transition(with: idLabel, duration: 0.3, options: [.transitionCrossDissolve]) {
            self.idLabel.textColor = UIColor.dynamicColor(light: .black, dark: .white)
            
        }

        UIView.transition(with: passwordLabel, duration: 0.3, options: [.transitionCrossDissolve]) {
            self.passwordLabel.textColor = UIColor.dynamicColor(light: .systemGray6, dark: .darkGray)
            
        }
        
    }
    
    
    /// 비밀번호를 탭할시 activatedBar 뷰의 수평가운데 제약에 CH/ CR 우선순위 값을 토글하면서 애니메이션효과를 줍니다.
    /// - Parameter sender: 패스워드 버튼에 전달
    /// 황신택 (sinadsl1457@gmail.com)
    @IBAction func didTapPassword(_ sender: Any) {
        passwordLabelCenterX.priority = .defaultHigh
        idLabelCenterX.priority = .defaultLow
       
        emailTextField.placeholder = "가입된 아이디를 입력해주세요."
        buttonLabel.text = "비밀번호 찾기"
        
        infoTextView.isHidden = true
        
        activatedBar.backgroundColor = UIColor.dynamicColor(light: .black, dark: .lightGray)
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
       
        UIView.transition(with: idLabel, duration: 0.3, options: [.transitionCrossDissolve]) {
            self.idLabel.textColor = UIColor.dynamicColor(light: .systemGray6, dark: .darkGray)
            
        }

        UIView.transition(with: passwordLabel, duration: 0.3, options: [.transitionCrossDissolve]) {
            self.passwordLabel.textColor = UIColor.dynamicColor(light: .black, dark: .white)
            
        }
    }
    
    
    /// 이메일 조건 충족시 아이디를 이메일로 발송합니다.
    /// - Parameter sender: 아이디 버튼에 전달
    @IBAction func checkToEmailCondtions(_ sender: Any) {
        guard let email = emailTextField.text,
              email.count > 0,
              isEmailValid(email),
              email.trimmingCharacters(in: .whitespacesAndNewlines) != "" else {
                  alert(title: "알림", message: "올바른 형식의 이메일이 아니거나 없는 이메일입니다")
                  return
              }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 버튼에 공통 스타일을 적용
        findIdButton.setToEnabledButtonTheme()
        
        // activatedBar 컬러를 다크모드 라이트 모드에 따라서 초기화
        activatedBar.backgroundColor = UIColor.dynamicColor(light: .black, dark: .lightGray)
        
        // 네베이게션 왼쪽 바버튼 라이트 모드 다크모드에 따라서 색상이 다르게 초기화
        navigationItem.leftBarButtonItem?.tintColor = UIColor.dynamicColor(light: .black, dark: .lightGray)
        
        // 텍스트뷰 편집 불가하게 초기화
        infoTextView.isEditable = false
        infoTextView.isSelectable = false
    }
       
}


