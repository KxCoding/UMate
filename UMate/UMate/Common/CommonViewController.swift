//
//  CommonViewController.swift
//  CommonViewController
//
//  Created by 안상희 on 2021/08/06.
//

import UIKit

class CommonViewController {

    static let shared = CommonViewController()
    
    private init() { }

    /// 편집이 활성화 된 텍스트 필드
    /// 텍스트 필드 델리게이트로 해당 속성을 편집 시작과 끝날 때 초기화를 하고. 이 속성으로 키보드가 텍스트 필드를 가릴 때 화면을 올리는 데 사용합니다.
    var activetedTextField: UITextField? = nil
    
    /// 홈화면으로 가는 메소드입니다.
    func transitionToHome() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")

        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
    }
    
    
    func showPasswordViewController() {
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        let passwordViewController = storyboard.instantiateViewController(withIdentifier: "CommonPasswordSB")
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(passwordViewController)
    }
    
    
    
    func showFaceIdViewController() {
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        let emptyViewController = storyboard.instantiateViewController(withIdentifier: "EmptySB")
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(emptyViewController)
    }
}
