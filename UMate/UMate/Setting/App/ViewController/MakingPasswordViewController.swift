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

    @IBOutlet weak var firstContainerView: UIView!
    @IBOutlet weak var secondContainerView: UIView!
    @IBOutlet weak var thirdContainerView: UIView!
    @IBOutlet weak var fourthContainerView: UIView!
    
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var checkPasswordField: UITextField!
    
    @objc func process(notifcation: Notification) {
        DispatchQueue.main.async {
            self.checkPasswordField.text = ""
            
            [self.firstContainerView, self.secondContainerView,
             self.thirdContainerView, self.fourthContainerView].forEach {
                $0?.backgroundColor = UIColor.white
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // 뒤로 가기 버튼 없애기
        self.navigationItem.setHidesBackButton(true, animated:true)
        
        passwordField.becomeFirstResponder()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(process(notifcation:)),
                                               name: Notification.Name.PasswordNotCorrect,
                                               object: nil)
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}




extension MakingPasswordViewController: UITextFieldDelegate {
    
    /// 지정된 텍스트를 변경할 것인지 delegate에게 묻는 메소드입니다.
    ///
    /// 비밀번호는 4자리로 제한합니다.
    ///
    /// - Parameters:
    ///   - textField: 텍스트를 포함하고 있는 TextField.
    ///   - range: 지정된 문자 범위입니다.
    ///   - string: 지정된 범위에 대한 대체 문자열입니다.
    /// - Returns: Bool
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        let currentText = NSString(string: textField.text ?? "")
        let finalText = currentText.replacingCharacters(in: range, with: string)
        
        switch textField {
        case passwordField:
            // 숫자만 입력 가능하고, 숫자는 4자리로 제한합니다.
            if let _ = string.rangeOfCharacter(from: charSet) { return false }
            
            if finalText.count == 1 {
                firstContainerView.backgroundColor = UIColor.black
            } else if finalText.count == 2 {
                secondContainerView.backgroundColor = UIColor.black
            } else if finalText.count == 3 {
                thirdContainerView.backgroundColor = UIColor.black
            } else {
                password = finalText
                
                fourthContainerView.backgroundColor = UIColor.black
                
                navigationItem.title = "비밀번호 확인"
                [firstContainerView, secondContainerView,
                 thirdContainerView, fourthContainerView].forEach {
                    $0?.backgroundColor = UIColor.white
                }
                
                checkPasswordField.becomeFirstResponder()
            }
            
        case checkPasswordField:
            // 숫자만 입력 가능하고, 숫자는 4자리로 제한합니다.
            if let _ = string.rangeOfCharacter(from: charSet) { return false }
            
            if finalText.count == 1 {
                firstContainerView.backgroundColor = UIColor.black
            } else if finalText.count == 2 {
                secondContainerView.backgroundColor = UIColor.black
            } else if finalText.count == 3 {
                thirdContainerView.backgroundColor = UIColor.black
            } else {
                passwordCheck = finalText
                
                guard password == passwordCheck else {
                          
                    alert(message: "비밀번호가 일치하지 않습니다. 다시 시도하십시오.")
                          
                    /// 비밀번호가 일치하지 않을 때 사용하는 Notifcation.
                    /// MakingPasswordViewController에 옵저버 존재.
                    NotificationCenter.default.post(name: Notification.Name.PasswordNotCorrect,
                                                    object: nil)
                    return false
                }
                
                dummyPassword = password
                fourthContainerView.backgroundColor = UIColor.black
                alert(message: "비밀번호가 설정되었습니다.")
                
                /// 비밀번호 설정이 최종적으로 완료되면 보내는 Notification. SetPasswordViewController에 옵저버 존재.
                NotificationCenter.default.post(name: Notification.Name.PasswordDidSet,
                                                object: nil,
                                                userInfo: ["password": passwordCheck])
                
                
                /// navigationController를 자동으로 pop합니다.
                let completion = {
                    _ = self.navigationController?.popViewController(animated: true)
                }
                
                
                guard let coordinator = transitionCoordinator else {
                    completion()
                    return false
                }
                
                
                coordinator.animate(alongsideTransition: nil) { _ in
                    completion()
                }
            }
    
        default:
            return true
        }
        return true
    }

}




extension NSNotification.Name {
    /// 비밀번호가 설정되다가 사용자에 의해 또는 크래시로 인해 중간에 중단되었을 때 사용하는 타입
    static let PasswordNotSet = NSNotification.Name("PasswordNotSetNotification")
    
    /// 비밀번호가 처음으로 모두 입력되었을 때 설정하는 타입
    static let PasswordDidEntered = NSNotification.Name("PasswordDidEnteredNotification")
    
    /// 비밀번호가 제대로 설정되었을 때 사용하는 타입
    static let PasswordDidSet = NSNotification.Name("PasswordDidSetNotification")
    
    /// 비밀번호 확인 입력 시, 이전 비밀번호와 일치하지 않을 때 사용하는 타입
    static let PasswordNotCorrect = NSNotification.Name("PasswordNotCorrectNotification")
    
    /// 비밀번호 변경 시, 이전 비밀번호와 동일한 비밀번호로 설정할 때 사용하는 타입
    static let PasswordIsSame = NSNotification.Name("PasswordIsSameNotification")
}
