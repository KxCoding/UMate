//
//  UIViewController+Appearance.swift
//  UMate
//
//  Created by Effie on 2021/11/05.
//

import Foundation
import UIKit

extension UIViewController {
    
    /// tab bar controller의 배경색을 설정합니다.
    ///
    /// tab bar의 배경색을 시스템 기본 배경색으로 설정하고, scrollEdgeAppearance와 일치시킵니다.
    /// 일부 화면에서 tab bar가 투명해지는 현상을 해결할 수 있습니다.
    /// - Author: 박혜정(mailmelater11@gmail.com)
    func setTapBarAppearanceAsDefault() {
        if #available(iOS 15.0, *) {
            guard let tabBarController = self.tabBarController else { return }
            
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .systemBackground
            
            tabBarController.tabBar.standardAppearance = appearance
            tabBarController.tabBar.scrollEdgeAppearance = tabBarController.tabBar.standardAppearance
        }
    }
}
