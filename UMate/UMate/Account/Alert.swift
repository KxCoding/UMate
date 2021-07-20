//
//  Alert.swift
//  Alert
//
//  Created by 황신택 on 2021/07/20.
//

import Foundation
import UIKit

extension UIViewController {
    func showError(title: String, message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default, handler: nil)
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}
