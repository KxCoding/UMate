//
//  CommonViewController.swift
//  CommonViewController
//
//  Created by 안상희 on 2021/08/06.
//

import UIKit
import KeychainSwift

/// 공통되는 기능을 포함한 뷰 컨트롤러
///  - Author: 안상희, 남정은, 황신택
class CommonViewController: UIViewController {
    /// 메인 화면인 홈으로 이동합니다.
    /// - Author: 황신택, 안상희
    static func transitionToHome() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController =
        storyboard.instantiateViewController(withIdentifier: "MainTabBarController")

        (UIApplication.shared.connectedScenes.first?.delegate as?
         SceneDelegate)?.changeRootViewController(mainTabBarController)
    }
    

    /// 암호 입력 화면을 보여줍니다.
    /// - Author: 안상희
    static func showPasswordViewController() {
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        let passwordViewController =
        storyboard.instantiateViewController(withIdentifier: "CommonPasswordSB")
        
        (UIApplication.shared.connectedScenes.first?.delegate as?
         SceneDelegate)?.changeRootViewController(passwordViewController)
    }
    
    
    /// Touch ID / Face ID 암호 화면을 보여줍니다.
    /// - Author: 안상희
    static func showFaceIdViewController() {
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        let emptyViewController =
        storyboard.instantiateViewController(withIdentifier: "EmptySB")
        
        (UIApplication.shared.connectedScenes.first?.delegate as?
         SceneDelegate)?.changeRootViewController(emptyViewController)
    }

    
    /// 텍스트필드에 편집할 대상을 지정하기 위한 속성
    var activatedTextField: UITextField? = nil
    
    /// 옵저버 제거를 위해 토큰을 담는 배열
    /// - Author: 남정은
    var tokens = [NSObjectProtocol]()
    
    /// 키체인 계정을 가져오기 위한 인스턴스 속성
    ///  Author: 황신택
    let keychainPrefix = KeychainSwift(keyPrefix: Keys.prefixKey)
    
    
    /// 소멸자에서 옵저버를 제거
    /// - Author: 남정은
    deinit {
        for token in tokens {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
}




