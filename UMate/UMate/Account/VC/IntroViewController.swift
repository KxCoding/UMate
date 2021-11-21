//
//  IntroViewController.swift
//  UMate
//
//  Created by Hyunwoo Jang on 2021/11/17.
//

import UIKit
import KeychainSwift


/// 인트로 화면
/// - Author: 장현우(heoun3089@gmail.com)
class IntroViewController: CommonViewController {
    
    /// 로그인 화면으로 이동합니다.
    /// - Author: 장현우(heoun3089@gmail.com)
    func transitionToLoginScreen() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }
    }
    
    
    /// 초기화 작업을 실행합니다.
    ///
    /// 저장된 토큰이 있을 경우, 토큰을 검증하는 메소드를 실행합니다.
    /// 저장된 토큰이 없을 경우, 로그인 화면으로 이동합니다.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let _ = loginKeychain.get(AccountKeys.userId.rawValue),
           let _ = loginKeychain.get(AccountKeys.apiToken.rawValue) {
            LoginDataManager.shared.validateToken(transitionToLoginScreen: transitionToLoginScreen, transitionToHome: CommonViewController.transitionToHome, vc: self)
        } else {
            transitionToLoginScreen()
        }
    }
}
