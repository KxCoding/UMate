//
//  PasswordCheckViewController.swift
//  PasswordCheckViewController
//
//  Created by 안상희 on 2021/08/05.
//

import UIKit


/// 사용자 계정 설정의 이메일/비밀번호 변경을 클릭하면 보여주는 화면 TableViewController 클래스
///
/// 비밀번호를 입력하면 다음 ViewController로 넘어갑니다.
/// - Author: 안상희
class PasswordCheckViewController: UIViewController {
    /// 현재 비밀번호를 입력하는 TextField
    @IBOutlet weak var passwordField: UITextField!
    
    /// 다음 ViewController로 이동하는 UIButton
    @IBOutlet weak var nextButton: UIButton!
    
    
    /// 특정 identifier를 갖는 segue가 수행되어야하는지의 여부를 결정합니다.
    ///
    /// 비밀번호가 올바르게 입력되면 다음 화면으로 넘어가고, 그렇지 않으면 경고창을 띄웁니다.
    /// - Parameters:
    ///   - identifier: 트리거된 segue를 식별하는 문자열
    ///   - sender: segue를 시작한 객체
    /// - Returns: segue를 수행해야하는 경우는 true, 무시되어야하는 경우는 false입니다.
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        guard let password = passwordField.text, password.count > 0 else {
            alert(title: "경고", message: "비밀번호가 올바르지 않습니다.")
            return false
        }
        return true
    }
    
    
    /// ViewController가 메모리에 로드되면 호출됩니다.
    ///
    /// View의 초기화 작업을 진행합니다.
    override func viewDidLoad() {
        super.viewDidLoad()

        passwordField.becomeFirstResponder()
        
        nextButton.setToEnabledButtonTheme()
    }
}



extension PasswordCheckViewController: UITextFieldDelegate {
    /// Return 버튼을 눌렀을 때의 process에 대해 delegate에게 묻습니다.
    ///
    /// Return 버튼을 누르면 다음 textField로 이동합니다.
    /// - Parameter textField: Return 버튼이 눌려진 해당 TextField
    /// - Returns: TextField가 return 버튼에 대한 동작을 구현해야하는 경우 true이고, 그렇지 않으면 false입니다.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        passwordField.resignFirstResponder()
        return true
    }
}
