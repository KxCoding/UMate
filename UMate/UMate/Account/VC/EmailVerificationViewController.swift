//
//  EmailVerifyViewController.swift
//  UMate
//
//  Created by 황신택 on 2021/07/29.
//

import UIKit
import KeychainSwift
import RxSwift
import RxCocoa
import NSObject_Rx

/// 이메일 인증 화면
/// Author: 황신택 (sinadsl1457@gmail.com), 장현우(heoun3089@gmail.com)
class EmailVerificationViewController: CommonViewController {
    /// 보안코드 발송 버튼
    @IBOutlet weak var sendCodeButton: UIButton!
    
    /// 다음 화면 버튼
    @IBOutlet weak var emailVerificationButton: UIButton!
    
    /// 이메일 필드
    @IBOutlet weak var emailTextField: UITextField!
    
    /// 보안코드 입력 필드
    @IBOutlet weak var codeTextField: UITextField!
    
    /// 이메일 화면 탭 제스쳐
    //    @IBOutlet var tapGesture: UITapGestureRecognizer!
    
    /// 대학교 이름
    ///
    /// 이전 화면에서 전달됩니다.
    /// - Author: 장현우(heoun3089@gmail.com)
    var universityName: String?
    
    /// 입학 연도
    ///
    /// 이전 화면에서 전달됩니다.
    /// - Author: 장현우(heoun3089@gmail.com)
    var entranceYear: String?
    
    
    /// 이메일 검증을 위한 보안코드를 요청합니다.
    /// - Parameter sender: sendCodeButton
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    @IBAction func sendTheCode(_ sender: Any) {
        guard let email = emailTextField.text,
              isEmailValid(email),
              email.trimmingCharacters(in: .whitespacesAndNewlines)  != "" else {
                  alert(title: "알림", message: "잘못된 형식의 이메일입니다.")
                  return
              }
        
        // 이메일을 키체인 저장하고 액세스 레벨을 accessibleAfterFirstUnlock로 설정합니다.
        // 앱을 재시작하기 전까지 언락 합니다.
        if keychainPrefix.set(email, forKey: Keys.userEmailKey, withAccess: .accessibleAfterFirstUnlock) {
            print("Succeed Set email")
        } else {
            print("Faild Set")
        }
    }
    
    
    /// 입력한 코드를 확인합니다.
    /// - Parameter sender: emailVerificationButton
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    @IBAction func checkToVerifiedCode(_ sender: Any) {
        guard let codeField = codeTextField.text, codeField == "12345678" else {
            alert(title: "알림", message: "잘못된 코드입니다.")
            return
        }
    }
    
    
    /// 다음 화면으로 전환되기 전에 호출되어  초기화 작업을 수행합니다.
    /// - Parameters:
    ///   - segue: 실행된 segue
    ///   - sender: segue를 실행한 객체
    /// - Author: 황신택 (sinadsl1457@gmail.com), 장현우(heoun3089@gmail.com)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DetailRegisterViewController {
            vc.verifiedEmail = emailTextField.text
            vc.universityName = universityName
            vc.entranceYear = entranceYear
        }
    }
    
    
    /// 초기화 작업을 진행합니다.
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if DEBUG
        codeTextField.text = "12345678"
        #endif
        
        [sendCodeButton, emailVerificationButton].forEach({
            $0?.setToEnabledButtonTheme()
        })
        
        [emailTextField, codeTextField].forEach {
            $0?.layer.cornerRadius = 16
            $0?.clipsToBounds = true
        }
        
        
        // keyboardNotification을 처리하는 옵저버를 등록합니다.
        // 키보드가 화면에 표시되기 직전에 키보드 높이만큼 아래 여백을 추가해서 UI와 겹치는 문제를 방지합니다.
        let willShow = NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .map { ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0 }
        
        let willHide =
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }
        
        Observable.merge(willShow, willHide)
            .subscribe(onNext: { [unowned self] height in
                var shouldMoveViewUp = false
                
                if let activeTextField = self.activatedTextField {
                    let bottomOfTextField = activeTextField.convert(activeTextField.bounds, to: self.view).maxY
                    let topOfKeyboard = self.view.frame.height - height
                    
                    if bottomOfTextField > topOfKeyboard {
                        shouldMoveViewUp = true
                    }
                }
                
                if shouldMoveViewUp {
                    UIView.animate(withDuration: 0.3) {
                        self.view.frame.origin.y = 0 - height
                    }
                }
            })
            .disposed(by: rx.disposeBag)
        
        didTapMakeLowerKeyboard()
        
        makeChangeNavigationItemColor()
       
        codeTextField.rx.text.orEmpty
            .map(digitsOnly(_:))
            .subscribe(onNext: setPreservingCursor(on: codeTextField))
            .disposed(by: rx.disposeBag)
    }
    
    
    /// 숫자를 제외한 모든 문자들을 공백없이 하나의 문자로 만들어서 리턴합니다.
    /// - Parameter text: 텍스트 필드에 입력된 문자
    /// - Returns: 숫제를 제외한 문자들을 문자로 리턴합니다.
    func digitsOnly(_ text: String) -> String {
        return text.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
    }
    
    
    /// 숫자를 제외한 다른 문자가 온다면 텍스트필드의 커서를 다른위치로 이동시켜 입력을 방지합니다.
    /// - Parameter textField: 전달된 텍스트 필드
    /// - Returns: 클로저로 텍스필드의 selectedTextRange의 위치를 커스텀화하여 리턴합니다.
    func setPreservingCursor(on textField: UITextField) -> (_ newText: String) -> Void {
        return { newText in
            let cursorPosition = textField.offset(from: textField.beginningOfDocument, to: textField.selectedTextRange!.start) + newText.count - (textField.text?.count ?? 0)
            textField.text = newText
            print(cursorPosition)
            if let newPosition = textField.position(from: textField.beginningOfDocument, offset: cursorPosition) {
                textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
            }
        }
    }
   
}
