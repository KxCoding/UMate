//
//  IntroViewController.swift
//  UMate
//
//  Created by Hyunwoo Jang on 2021/11/17.
//

import KeychainSwift
import RxSwift
import UIKit


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
            LoginDataManager.shared.validateToken()
                .observe(on: MainScheduler.instance)
                .subscribe { result in
                    switch result {
                    case .success(let response):
                        switch response.statusCode {
                        case ResultCode.ok.rawValue:
                            CommonViewController.transitionToHome()
                            
                        default:
                            self.transitionToLoginScreen()
                        }
                        
                    case .failure(let error):
                        self.alert(message: error.localizedDescription)
                    }
                }
                .disposed(by: rx.disposeBag)
        } else {
            transitionToLoginScreen()
        }
    }
}
