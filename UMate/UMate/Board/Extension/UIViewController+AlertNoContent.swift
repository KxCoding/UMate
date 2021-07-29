//
//  UIViewController+AlertNoContent.swift
//  UMate
//
//  Created by Chris Kim on 2021/07/29.
//

import UIKit

extension UIViewController {
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
}
