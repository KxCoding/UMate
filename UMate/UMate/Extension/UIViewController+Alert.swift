//
//  UIViewController+Alert.swift
//  UMate
//
//  Created by 안상희 on 2021/07/21.
//

import UIKit

extension UIViewController {
    
    /// <#Description#>
    /// - Parameters:
    ///   - title: <#title description#>
    ///   - message: <#message description#>
    func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default) { action in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - title: <#title description#>
    ///   - message: <#message description#>
    func alertWithNoAction(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - title: <#title description#>
    ///   - message: <#message description#>
    func alertNoContent(title: String = "알림", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default, handler: { [weak self] (noti) in
            self?.dismiss(animated: true, completion: nil)
        })
        alert.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    /// <#Description#>
    /// - Parameters:
    ///   - title: <#title description#>
    ///   - message: <#message description#>
    func alertComment(title: String, message: String) {
        let alertCommnet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertCommnet.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertCommnet.addAction(cancelAction)
        
        present(alertCommnet, animated: true, completion: nil)
    }
}
