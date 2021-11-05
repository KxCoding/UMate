//
//  UIViewController+OpenUrl.swift
//  UIViewController+OpenUrl
//
//  Created by Effie on 2021/08/23.
//

import UIKit
import WebKit
import SafariServices


/// URL 타입
///
/// notification으로 전송되는 URL 오픈 방식을 식별하기 위한 케이스입니다.
/// - Author: 박혜정(mailmelater11@gmail.com)
enum URLType {
    case web
    case tel
}



extension UIViewController {
    
    /// url을 엽니다.
    ///
    /// user default에 저장된 선호 방식으로 url을 엽니다.
    /// - Parameter urlString: 열 url
    /// - Author: 박혜정(mailmelater11@gmail.com)
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
    
    /// 사용자가 선택한 방식으로 url을 엽니다.
    ///
    /// 선택한 방식은 user defaults에 저장됩니다.
    /// - Parameter url: 오픈할 url
    /// - Author: 박혜정(mailmelater11@gmail.com)
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
    /// - Author: 박혜정(mailmelater11@gmail.com)
    private func openURLInternal(url: URL) {
        let safariVC = SFSafariViewController(url: url)
        self.present(safariVC, animated: true, completion: nil)
    }
    
    
    /// 관련 앱이나 브라우저 등 앱 외부에서 url을 엽니다.
    /// - Parameter url: 오픈할 url
    /// - Author: 박혜정(mailmelater11@gmail.com)
    func openURLExternal(url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
}
