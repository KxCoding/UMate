//
//  PasswordChangeViewController.swift
//  UMate
//
//  Created by 안상희 on 2021/08/04.
//

import UIKit


/// 사용자 계정 화면에서 비밀번호 변경을 할 수 있는 화면을 보여주는 ViewController 클래스
/// - Author: 안상희
class PasswordChangeViewController: UIViewController {
    // MARK: Outlet
    /// 새 비밀번호를 입력하는 TextField입니다.
    @IBOutlet weak var passwordField: UITextField!
    
    /// 입력된 새 비밀번호를 다시 한번 입력하는 TextField입니다.
    @IBOutlet weak var checkPasswordField: UITextField!
    
    
    /// 새 비밀번호가 형식에 맞게 설정되었는지 체크하는 메세지를 표시하는 컨테이너를 담는 UIView입니다.
    @IBOutlet weak var passwordMessageContainerView: UIView!
    
    /// 입력된 새 비밀번호가 앞서 입력된 비밀번호와 동일한지의 여부를 나타나는 메세지를 표시하는 컨테이너를 담는 UIView입니다.
    @IBOutlet weak var checkPasswordMessageContainerView: UIView!
    
    
    /// 새 비밀번호가 형식에 맞게 설정되었는지 체크하는 메세지를 표시하는 UILabel입니다.
    @IBOutlet weak var passwordMessageLabel: UILabel!
    
    /// 입력된 새 비밀번호가 앞서 입력된 비밀번호와 동일한지의 여부를 나타나는 메세지를 표시하는 UILabel입니다.
    @IBOutlet weak var checkPasswordMessageLabel: UILabel!
    
    /// 비밀번호 변경 UIButton입니다.
    @IBOutlet weak var changeButton: UIButton!
    
    
    // MARK: Action
    /// 비밀번호 변경 버튼이 눌리면 호출됩니다.
    ///
    /// 비밀번호 변경 확인 창이 뜨고, 사용자 계정 설정 화면으로 pop 됩니다.
    /// - Parameter sender: UIButton
    @IBAction func changeButtonDidTapped(_ sender: UIButton) {
        passwordMessageContainerView.isHidden = true
        checkPasswordMessageContainerView.isHidden = true
        
        alert(message: "비밀번호가 변경되었습니다.")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let controllers = self.navigationController?.viewControllers
            for vc in controllers! {
                if vc is SettingTableViewController {
                    _ = self.navigationController?
                        .popToViewController(vc as! SettingTableViewController, animated: true)
                }
            }
        }
    }
    
    
    /// ViewController가 메모리에 로드되면 호출됩니다.
    ///
    /// View의 초기화 작업을 진행합니다.
    override func viewDidLoad() {
        super.viewDidLoad()

        passwordField.becomeFirstResponder()
        
        changeButton.setButtonTheme()
    }
}



extension PasswordChangeViewController: UITextFieldDelegate {
    /// 올바른 이메일 형식인지 체크합니다.
    ///
    /// 이메일 형식이 올바르지 않을 경우, emailField 밑에 경고 메시지를 출력합니다.
    /// 이메일 형식이 올바를 경우, emailField 밑에 올바른 형식이라고 메시지를 출력합니다.
    ///
    /// - Parameters:
    ///   - textField: 텍스트를 포함하고 있는 TextField.
    ///   - range: 지정된 문자 범위입니다.
    ///   - string: 지정된 범위에 대한 대체 문자열입니다.
    /// - Returns: Bool
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        switch textField {
        case passwordField:
            if var password = textField.text {
                // 현재 사용자가 입력한 문자까지 포함하는 패스워드
                let currentPassword: String
                
                // string이 empty라면
                // 사용자가 문자를 지운 것이므로 마지막 문자를 삭제하고 currentPassword에 문자를 저장합니다.
                if string.isEmpty {
                    password.removeLast()
                    currentPassword = password
                } else {
                    // string이 empty가 아니라면, 사용자가 문자를 추가한 것이므로
                    // 마지막 문자를 추가하고 currentPassword에 password + 문자를 저장합니다.
                    currentPassword = password + string
                }
                
                
                guard let _ = currentPassword
                        .range(of: Regex.password, options: .regularExpression) else {
                    passwordMessageLabel.text = "잘못된 비밀번호 형식입니다."
                    passwordMessageLabel.textColor = .systemRed
                    passwordMessageContainerView.isHidden = false
                    changeButton.isEnabled = false
                    changeButton.disabledButton()
                    return true
                }
                
                
                passwordMessageLabel.text = "올바른 비밀번호 형식입니다."
                passwordMessageLabel.textColor = .systemBlue
            }
        case checkPasswordField:
            if var password = textField.text {
                // 현재 사용자가 입력한 문자까지 포함하는 패스워드
                let currentPassword: String
                
                // string이 empty라면
                // 사용자가 문자를 지운 것이므로 마지막 문자를 삭제하고 currentPassword에 문자를 저장합니다.
                if string.isEmpty {
                    password.removeLast()
                    currentPassword = password
                } else {
                    // string이 empty가 아니라면, 사용자가 문자를 추가한 것이므로
                    // 마지막 문자를 추가하고 currentPassword에 password + 문자를 저장합니다.
                    currentPassword = password + string
                }
                
                
                guard let _ = currentPassword
                        .range(of: Regex.password, options: .regularExpression) else {
                    checkPasswordMessageLabel.text = "비밀번호가 일치하지 않습니다."
                    checkPasswordMessageLabel.textColor = .systemRed
                    checkPasswordMessageContainerView.isHidden = false
                    changeButton.isEnabled = false
                    changeButton.disabledButton()
                    return true
                }
                
                
                if currentPassword == passwordField.text {
                    checkPasswordMessageLabel.text = "비밀번호가 일치합니다."
                    checkPasswordMessageLabel.textColor = .systemBlue
                    changeButton.isEnabled = true
                    changeButton.setButtonTheme()
                } else {
                    checkPasswordMessageLabel.text = "비밀번호가 일치하지 않습니다."
                    checkPasswordMessageLabel.textColor = .systemRed
                    checkPasswordMessageContainerView.isHidden = false
                    changeButton.isEnabled = false
                    changeButton.disabledButton()
                }
            }
        default:
            break
        }
        return true
    }
    
    
    /// Return 버튼을 눌렀을 때의 process에 대해 delegate에게 묻습니다.
    ///
    /// Return 버튼을 누르면 커서가 다음 textField로 이동합니다.
    /// - Parameter textField: Return 버튼이 눌려진 해당 TextField
    /// - Returns: TextField가 return 버튼에 대한 동작을 구현해야하는 경우 true이고, 그렇지 않으면 false입니다.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case passwordField:
            checkPasswordField.becomeFirstResponder()
        case checkPasswordField:
            checkPasswordField.resignFirstResponder()
        default:
            break
        }
        return true
    }
}
