//
//  EmailVerifyViewController.swift
//  UMate
//
//  Created by 황신택 on 2021/07/29.
//

import UIKit
import KeychainSwift

/// 이메일을 검증하고 보안 코드를 발송하는 클래스입니다.
/// Author:  황신택
class EmailVerifyViewController: UIViewController {
    /// 보안코드 발송 버튼
    @IBOutlet weak var sendCodeButton: UIButton!
    
    /// 다음 버튼
    @IBOutlet weak var emailVerificationButton: UIButton!
    
    /// 이메일 필드
    @IBOutlet weak var emailTextField: UITextField!
    
    /// 인증받은 코드를 입력하는 필드
    @IBOutlet weak var codeTextField: UITextField!
    
    /// 편집이 활성화 된 텍스트 필드
    /// 편집 상태에 따라 조건을 판단하기 위해서 사용합니다.
    var activeTextField: UITextField? = nil
    
    /// 이메일 저장을 위한 키체인 인스턴스 생성
    var keyChain = KeychainSwift(keyPrefix: Keys.prefixKey)
    
    /// 옵저버 제거를 위한 NSObjectProtocol  배열
    var tokens = [NSObjectProtocol]()
    
    /// 이메일 검증을 받기위해 코드를 전송합니다.
    /// - Parameter sender: sendCodeButton에 전달되고 서버에서 코드를 전송합니다.
    @IBAction func sendTheCode(_ sender: Any) {
        // 유저가 입력한 이메일을 정규식 및 빈문자열인지 체크합니다.
        guard let email = emailTextField.text,
              isEmailValid(email),
              email.trimmingCharacters(in: .whitespacesAndNewlines)  != "" else {
                  alert(title: "알림", message: "잘못된 형식의 이메일입니다.")
                  return
              }
        
        
        // 이메일을 키체인 저장하고 액세스 레벨을 accessibleAfterFirstUnlock로 설정합니다.(앱을 재시작하기 전까지 언락)
        if keyChain.set(email, forKey: Keys.userEmailKey, withAccess: .accessibleAfterFirstUnlock) {
            print("Succeed Set email")
        } else {
            print("Faild Set")
        }
    }
    
    
    /// 입력한 코드가 맞는지 체크하는 메소드입니다.
    /// - Parameter sender: emailVerificationButton에 전달되고 서버에서 보낸 코드가 맞는지 체크합니다.
    @IBAction func checkToVerifiedCode(_ sender: Any) {
        guard let codeField = codeTextField.text, codeField == "12345678" else {
            alert(title: "알림", message: "잘못된 코드입니다.")
            return
        }
        
    }
    
    ///  회원가입시 인증받은 이메일로만 가입할수있게 인증된 이메일 데이타를 전달합니다.
    ///   - Parameters:
    ///   - segue: 세그웨이의 destination속성을 DetailRegisterViewController 로 캐스팅하여 verifiedEmail 속성에 이메일 데이타를 넘겨줍니다.
    ///   - sender: Any?
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DetailRegisterViewController {
            vc.verifiedEmail = emailTextField.text
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 버튼에 공통 스타일 적용
        [sendCodeButton, emailVerificationButton].forEach({
            $0?.setButtonTheme()
        })
        
        [emailTextField, codeTextField].forEach {
            $0?.layer.cornerRadius = 16
            $0?.clipsToBounds = true
        }
        
        // 키보드 노티피케이션 호출
        addKeyboardWillHide()
        addKeyboardWillShow()
        
        // 더미데이터 및 delegate선언
        codeTextField.delegate = self
        
        // 뷰를 탭하면 키보드가 아래로 내려갑니다.
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DetailRegisterViewController.backgroundTap))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
   
    
    /// 뷰를 탭할시 키보드가 내려갑니다.
    /// - Parameter sender: 파라미터가 UITapGestureRecognizer의 생성자의 액션 파라미터로 전달됩니다.
    @objc func backgroundTap(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    
    deinit {
        for token in tokens {
            NotificationCenter.default.removeObserver(token)
        }
    }
   
}



extension EmailVerifyViewController: UITextFieldDelegate {
    /// codeTextField 텍스트필드에 숫자를 제외한 다른 텍스트는 작성 불가합니다.
    /// - Parameters:
    ///   - textField: 텍스트 필드에 포함된 텍스트
    ///   - range: 대체될 문자열 범위
    ///   - string: 정해진 범위에 대체될 문자열
    /// - Returns: 리턴 트루시 텍스트 입력이 가능,  false일시 불가.
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let codeField = codeTextField.text else { return false }
        let finalStr = NSString(string: codeField).replacingCharacters(in: range, with: string)
        let chartSet = CharacterSet(charactersIn: "0123456789").inverted
        
        guard let _ = finalStr.rangeOfCharacter(from: chartSet) else { return true }
        
        return false
    }
    
    /// 특정 텍스트필드에 값이 입력될시 키보드가 텍스트 필드를 가려질 경우를 만들기위한 메소드
    func textFieldDidBeginEditing(_ textField: UITextField) {
        CommonViewController.shared.activetedTextField = textField
    }
    
    /// 특정 텍스트필드에 입력이 끝났을시 키보드가 텍스트 필드를 가려질 경우를 만들기위한 메소드
    func textFieldDidEndEditing(_ textField: UITextField) {
        CommonViewController.shared.activetedTextField = nil
    }
    
}



extension EmailVerifyViewController {
    /// keyboardWillShowNotification을 처리하는 옵저버를 등록합니다.
    /// activeTextField를 이용하여 키보드가 화면에 표시되기 직전에 키보드 높이만큼 Bottom 여백을 추가해서 UI와 겹치는 문제를 방지합니다.
    func addKeyboardWillShow() {
        var token: NSObjectProtocol
      token = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { [weak self] noti in
            guard let strongSelf = self else { return  }
            guard let keyboardSize = (noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                return
            }
            
            var shouldMoveViewUp = false
            
            if let activeTextField = strongSelf.activeTextField {
                let bottomOfTextField = activeTextField.convert(activeTextField.bounds, to: strongSelf.view).maxY
                let topOfKeyboard = strongSelf.view.frame.height - keyboardSize.height
                
                if bottomOfTextField > topOfKeyboard {
                    shouldMoveViewUp = true
                }
            }
            
            if shouldMoveViewUp {
                UIView.animate(withDuration: 0.3) {
                    strongSelf.view.frame.origin.y = 15 - keyboardSize.height
                }
                
            }
        }
        
        tokens.append(token)
        
    }
    
    
    /// keyboardWillHideNotification을 처리하는 옵저버를 등록합니다.
    func addKeyboardWillHide() {
        var token: NSObjectProtocol
      token = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { [weak self] noti in
            guard let strongSelf = self else { return }
            strongSelf.view.frame.origin.y = 0
        }
        
        tokens.append(token)
    }
  
}
