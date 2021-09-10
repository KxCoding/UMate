//
//  PasswordRootViewController.swift
//  PasswordRootViewController
//
//  Created by 안상희 on 2021/09/02.
//

import UIKit
import KeychainSwift

class PasswordRootViewController: UIViewController {

    let keychain = KeychainSwift(keyPrefix: Keys.appLockPasswordKey)
    let bioKeychain = KeychainSwift(keyPrefix: Keys.bioLockPasswordKey)
    
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 뒤로 가기 버튼 없애기
        self.navigationItem.setHidesBackButton(true, animated:true)
    }
}
