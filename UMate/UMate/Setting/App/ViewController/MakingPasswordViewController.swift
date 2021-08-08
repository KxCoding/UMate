//
//  MakingPasswordViewController.swift
//  MakingPasswordViewController
//
//  Created by 안상희 on 2021/08/08.
//

import UIKit

class MakingPasswordViewController: UIViewController {
    
    var didPasswordSet = false
    var password: String?
    var passwordCheck: String?
    lazy var charSet = CharacterSet(charactersIn: "0123456789").inverted
    
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var thirdTextField: UITextField!
    @IBOutlet weak var fourthTextField: UITextField!
    @IBOutlet weak var firstContainerView: UIView!
    @IBOutlet weak var secondContainerView: UIView!
    @IBOutlet weak var thirdContainerView: UIView!
    @IBOutlet weak var fourthContainerView: UIView!
    
    
    @objc func process(notification: Notification, textField: UITextField) {
        
        guard let number = notification.userInfo?["number"] as? String else { return }
        
        guard let textField = notification.userInfo?["textField"] as? UITextField else { return }
        
        
        switch textField {
            
        case firstTextField:
            firstContainerView.backgroundColor = UIColor.black
            secondTextField.becomeFirstResponder()
            
        case secondTextField:
            secondContainerView.backgroundColor = UIColor.black
            thirdTextField.becomeFirstResponder()
            
        case thirdTextField:
            thirdContainerView.backgroundColor = UIColor.black
            fourthTextField.becomeFirstResponder()
            
        case fourthTextField:
            fourthContainerView.backgroundColor = UIColor.black
            fourthTextField.resignFirstResponder()
            
        default:
            break
        }
        
        
        if !didPasswordSet { /// 처음에 비밀번호를 설정할 때 실행되는 블록
            
            if password == nil {
                password = number
            } else {
                password?.append(number)
            }
            
            
            guard let password = password, password.count == 4 else { return }
            
            
            didPasswordSet = true
            firstTextField.becomeFirstResponder()
            
        } else { /// 비밀번호 재확인 시 실행되는 블록
            
            if passwordCheck == nil {
                passwordCheck = number
            } else {
                passwordCheck?.append(number)
            }
            
            
            guard let pw = passwordCheck, pw.count == 4 else {
                return
            }
            
            
            guard let passwordCheck = passwordCheck,
                  passwordCheck.count == 4,
                  password == passwordCheck else {
                      
                      alert(message: "비밀번호가 일치하지 않습니다. 다시 시도하십시오.")
                      /// 비밀번호 설정이 완료되지 않았을 때 Notification. SetPasswordViewController에 옵저버 존재.
                      NotificationCenter.default.post(name: Notification.Name.PasswordNotSet,
                                                      object: nil)
                      
                      [firstContainerView, secondContainerView, thirdContainerView, fourthContainerView].forEach {
                          $0?.backgroundColor = UIColor.white
                      }
                      
                      
                      firstTextField.becomeFirstResponder()
                      passwordCheck = nil
                      
                      
                      return
                  }
            
            alert(message: "비밀번호가 설정되었습니다.")
            
            
            /// 비밀번호 설정이 최종적으로 완료되면 보내는 Notification. SetPasswordViewController에 옵저버 존재.
            NotificationCenter.default.post(name: Notification.Name.PasswordDidSet,
                                            object: nil,
                                            userInfo: ["password": passwordCheck])
            
            
            let completion = {
                self.navigationController?.popViewController(animated: true)
            }
            
            
            guard let coordinator = transitionCoordinator else {
                completion()
                return
            }
            
            
            coordinator.animate(alongsideTransition: nil) { _ in
                completion()
            }
        }
        
        navigationItem.title = "비밀번호 확인"
        [firstContainerView, secondContainerView, thirdContainerView, fourthContainerView].forEach {
            $0?.backgroundColor = UIColor.white
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // 뒤로 가기 버튼 없애기
        self.navigationItem.setHidesBackButton(true, animated:true)
        
        firstTextField.becomeFirstResponder()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(process(notification:textField:)),
                                               name: Notification.Name.NumberDidEntered, object: nil)
        
        [firstTextField, secondTextField, thirdTextField, fourthTextField].forEach {
            $0?.tintColor = .clear
        }
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}




extension MakingPasswordViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        let currentText = NSString(string: textField.text ?? "")
        let finalText = currentText.replacingCharacters(in: range, with: string)
        
        
        switch textField {
        case firstTextField:
            if finalText.count == 1 {
                NotificationCenter.default.post(name: NSNotification.Name.NumberDidEntered,
                                                object: nil,
                                                userInfo: ["number": finalText, "textField": textField])
            }
            
        case secondTextField:
            if finalText.count == 1 {
                NotificationCenter.default.post(name: NSNotification.Name.NumberDidEntered,
                                                object: nil,
                                                userInfo: ["number": finalText, "textField": textField])
            }
            
        case thirdTextField:
            if finalText.count == 1 {
                NotificationCenter.default.post(name: NSNotification.Name.NumberDidEntered,
                                                object: nil,
                                                userInfo: ["number": finalText, "textField": textField])
            }
            
        case fourthTextField:
            if finalText.count == 1 {
                NotificationCenter.default.post(name: NSNotification.Name.NumberDidEntered,
                                                object: nil,
                                                userInfo: ["number": finalText, "textField": textField])
            }
        default:
            return true
        }
        
        return true
    }
}




extension NSNotification.Name {
    /// 비밀번호 하나 하나 입력할 때마다 설정하는 타입
    static let NumberDidEntered = NSNotification.Name("NumberDidEnteredNotification")
    
    /// 모든 비밀번호가 설정되었을 때 사용하는 타입
    static let PasswordDidSet = NSNotification.Name("PasswordDidSetNotification")
    
    /// 비밀번호가 설정되다가 중간에 중단되었을 때 사용하는 타입
    static let PasswordNotSet = NSNotification.Name("PasswordNotSetNotification")
}
