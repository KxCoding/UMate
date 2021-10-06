//
//  AccountCommonThingsViewController.swift
//  UMate
//
//  Created by 황신택 on 2021/10/05.
//

import UIKit
import KeychainSwift

class AccountCommonThingsViewController: UIViewController {
    /// 노티피케이션 제거를 위해 토큰을 담는 배열
    /// - Author: 남정은
    var tokens = [NSObjectProtocol]()

    /// 키체인 계정을 가져오기 위한 인스턴스를 생성.
    let keychain = KeychainSwift(keyPrefix: Keys.prefixKey)
    
    /// 특정 텍스트필드에 조건을 줘야하기 때문에 속성을 추가.
    var activeTextField: UITextField? = nil
    
    
    /// 메인 화면인 홈으로 이동합니다.
    /// - Author: 황신택
    func transitionToHome() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController =
        storyboard.instantiateViewController(withIdentifier: "MainTabBarController")

        (UIApplication.shared.connectedScenes.first?.delegate as?
         SceneDelegate)?.changeRootViewController(mainTabBarController)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    
    /// 소멸자에서 옵저버를 제거
    /// - Author: 남정은
    deinit {
        for token in tokens {
            NotificationCenter.default.removeObserver(token)
        }
    }
    

}
