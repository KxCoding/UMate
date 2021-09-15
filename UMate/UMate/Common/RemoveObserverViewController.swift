//
//  RemoveObserverViewController.swift
//  UMate
//
//  Created by 남정은 on 2021/09/16.
//

import UIKit


class RemoveObserverViewController: UIViewController {
    
    /// 노티피케이션 제거를 위해 토큰을 담는 배열
    /// - Author: 남정은
    var tokens = [NSObjectProtocol]()
    
    /// 소멸자에서 옵저버를 제거
    /// - Author: 남정은
    deinit {
        for token in tokens {
            NotificationCenter.default.removeObserver(token)
        }
    }
}
