//
//  UIViewController+OpenUrl.swift
//  UIViewController+OpenUrl
//
//  Created by Effie on 2021/08/23.
//

import UIKit
import WebKit
import SafariServices

/// url 종류
enum URLType {
    case web
    case tel
}


extension UIViewController {
    
    /// url을 전달하면 설정에 따라 알맞은 방식으로 url을 열어줍니다.
    /// - Parameter urlString: 열 url
    func openUrl(with url: URL) {
        switch Preference.preferredBrowser {
        case .none:
            selectAndOpenUrl(with: url)
        case .internal:
            openURLInternal(url: url)
        case .external:
            openURLExternal(url: url)
        }
    }
    
    /// URL을 전달하면 오픈 방식을 선택하도록 하고, 선택된 방식으로 열어줍니다.
    /// - Parameter url: 오픈할 url
    private func selectAndOpenUrl(with url: URL) {
        
        let openInternal: (UIAlertAction) -> () = { [weak self] _ in
            guard let self = self else { return }
            
            self.openURLInternal(url: url)
            Preference.preferredBrowser = .internal
        }
        
        let openExternal: (UIAlertAction) -> () = { [weak self] _ in
            guard let self = self else { return }
            
            self.openURLExternal(url: url)
            Preference.preferredBrowser = .external
        }
        
        let sheet = UIAlertController(title: nil,
                                      message: nil,
                                      preferredStyle: .actionSheet)
        let openInThisApp = UIAlertAction(title: "이 앱에서 열기",
                                          style: .default,
                                          handler: openInternal)
        let openInOtherApp = UIAlertAction(title: "관련 앱에서 열기",
                                           style: .default,
                                           handler: openExternal)
        
        let cancelAction = UIAlertAction(title: "취소",
                                         style: .cancel,
                                         handler: nil)
        
        sheet.addAction(openInThisApp)
        sheet.addAction(openInOtherApp)
        sheet.addAction(cancelAction)
        
        present(sheet, animated: true, completion: nil)
        
    }
    
    
    /// 앱 내부에서 사파리 VC로 url을 엽니다.
    /// - Parameter url: 오픈할 url
    private func openURLInternal(url: URL) {
        
        /// 사파리 vc로 열기
        let safariVC = SFSafariViewController(url: url)
        self.present(safariVC, animated: true, completion: nil)
    }
    
    
    /// 앱 외부 - 관련 앱이나 브라우저로 url을 엽니다.
    /// - Parameter url: 오픈할 url
    func openURLExternal(url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
}
