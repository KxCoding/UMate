//
//  EmailChangeViewController.swift
//  UMate
//
//  Created by 안상희 on 2021/08/04.
//

import UIKit


/// 사용자 계정 설정의 이메일 변경 화면 ViewController 클래스.
///
/// 이메일 변경 작업을 수행합니다.
/// - Author: 안상희
class EmailChangeViewController: UIViewController {
    /// 이메일을 입력하는 textField.
    @IBOutlet weak var emailField: UITextField!
    
    /// 이메일 형식이 잘못되면 나타나는 UIView.
    @IBOutlet weak var emailMessageContainerView: UIView!
    
    /// 이메일 형식이 올바른 형식인지 알려주는 메시지 UILabel.
    @IBOutlet weak var messageLabel: UILabel!
    
    /// 이메일을 변경하는 UIButton.
    @IBOutlet weak var changeButton: UIButton!

    
    /// 이메일 변경 버튼이 눌리면 호출됩니다.
    ///
    /// 이메일 변경 확인 창이 뜨고, 사용자 계정 설정 화면으로 pop 됩니다.
    /// - Parameter sender: UIButton.
    @IBAction func changeButtonDidTapped(_ sender: UIButton) {
        emailMessageContainerView.isHidden = true
        
        alert(message: "정상적으로 변경되었습니다.")
        
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
        
        emailField.becomeFirstResponder()
        emailMessageContainerView.isHidden = true
        
        changeButton.disabledButton()
        changeButton.isEnabled = false
    }
}



extension EmailChangeViewController: UITextFieldDelegate {
    /// 올바른 이메일 형식인지 체크합니다.
    ///
    /// 이메일 형식이 올바르지 않을 경우, emailField 밑에 경고 메시지를 출력합니다.
    /// 이메일 형식이 올바를 경우, emailField 밑에 올바른 형식이라고 메시지를 출력합니다.
    ///
    /// - Parameters:
    ///   - textField: 텍스트를 포함하고 있는 TextField.
    ///   - range: 지정된 문자 범위.
    ///   - string: 지정된 범위에 대한 대체 문자열.
    /// - Returns: Bool
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        // textField에 텍스트가 입력되었을 경우에 수행됩니다.
        if var email = textField.text {
            // 현재 사용자가 입력한 문자까지 포함하는 이메일
            let currentEmail: String
            
            // string이 empty라면, 사용자가 문자를 지운 것이므로 마지막 문자를 삭제하고 currentEmail에 문자를 저장합니다.
            if string.isEmpty {
                email.removeLast()
                currentEmail = email
            } else {
                // string이 empty가 아니라면, 사용자가 문자를 추가한 것이므로
                // 마지막 문자를 추가하고 currentEmail에 email + 문자를 저장합니다.
                currentEmail = email + string
            }
            
            guard let _ = currentEmail.range(of: Regex.email, options: .regularExpression) else {
                messageLabel.text = "잘못된 이메일 형식입니다."
                messageLabel.textColor = .systemRed
                emailMessageContainerView.isHidden = false
                changeButton.isEnabled = false
                changeButton.disabledButton()
                return true
            }
            
            messageLabel.text = "올바른 이메일 형식입니다."
            messageLabel.textColor = .systemBlue
            changeButton.isEnabled = true
            changeButton.setButtonTheme()
            return true
        }
        return true
    }
    
    
    /// Return 버튼을 눌렀을 때의 process에 대해 delegate에게 묻습니다.
    ///
    /// Return 버튼을 누르면 입력 커서가 사라집니다.
    /// - Parameter textField: Return 버튼이 눌려진 해당 TextField.
    /// - Returns: TextField가 return 버튼에 대한 동작을 구현해야하는 경우 true이고, 그렇지 않으면 false입니다.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailField.resignFirstResponder()
        return true
    }
}
