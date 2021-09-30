//
//  PasswordRootViewController.swift
//  PasswordRootViewController
//
//  Created by 안상희 on 2021/09/02.
//

import KeychainSwift
import UIKit


/// 암호 잠금 화면에 공통적으로 사용되는 ViewController 클래스.
/// - Author: 안상희
class PasswordRootViewController: UIViewController {
    /// keyPrefix로 전달된 값을 통해 KeychainSwift 객체를 초기화하기 위한 속성.
    let keychain = KeychainSwift(keyPrefix: Keys.appLockPasswordKey)
    
    /// keyPrefix로 전달된 값을 통해 KeychainSwift 객체를 초기화하기 위한 속성.
    let bioKeychain = KeychainSwift(keyPrefix: Keys.bioLockPasswordKey)
    
    /// 비밀번호가 설정되었는지 체크하기 위한 속성.
    var didPasswordSet = false
    
    /// 사용자가 설정한 비밀번호.
    var password: String?
    
    /// 사용자가 설정한 비밀번호를 한번 더 체크하기 위한 속성.
    var passwordCheck: String?
    
    /// 숫자를 제외한 문자열.
    lazy var charSet = CharacterSet(charactersIn: "0123456789").inverted
    
    /// 암호 4자리 중 첫번째 숫자 입력 UIView.
    @IBOutlet weak var firstContainerView: UIView!
    
    /// 암호 4자리 중 두번째 숫자 입력 UIView.
    @IBOutlet weak var secondContainerView: UIView!
    
    /// 암호 4자리 중 세번째 숫자 입력 UIView.
    @IBOutlet weak var thirdContainerView: UIView!
    
    /// 암호 4자리 중 네번째 숫자 입력 UIView.
    @IBOutlet weak var fourthContainerView: UIView!
    
    
    /// 암호를 설정하기 위한 TextField. 화면에는 보이지 않습니다.
    @IBOutlet weak var passwordField: UITextField!
    
    /// 설정한 암를 체크하기 위한 TextField. 화면에는 보이지 않습니다.
    @IBOutlet weak var checkPasswordField: UITextField!
    
    
    /// 암호 4자리 중 첫번째 숫자 입력 UIImageView.
    @IBOutlet weak var firstPasswordImageView: UIImageView!
    
    /// 암호 4자리 중 두번째 숫자 입력 UIImageView.
    @IBOutlet weak var secondPasswordImageView: UIImageView!
    
    /// 암호 4자리 중 세번째 숫자 입력 UIImageView.
    @IBOutlet weak var thirdPasswordImageView: UIImageView!
    
    /// 암호 4자리 중 네번째 숫자 입력 UIImageView.
    @IBOutlet weak var fourthPasswordImageView: UIImageView!
    
    
    /// ViewController가 메모리에 로드되면 호출됩니다.
    ///
    /// View의 초기화 작업을 진행합니다.
    override func viewDidLoad() {
        super.viewDidLoad()

        // 뒤로 가기 버튼 없애기
        self.navigationItem.setHidesBackButton(true, animated:true)
    }
}
