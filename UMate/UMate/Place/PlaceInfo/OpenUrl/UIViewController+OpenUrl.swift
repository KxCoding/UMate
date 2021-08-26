//
//  UIViewController+OpenUrl.swift
//  UIViewController+OpenUrl
//
//  Created by Effie on 2021/08/23.
//

import UIKit
import WebKit
import SafariServices

// MARK: Open URL

class Preference {
    
    /// 선호하는 브라우저
    enum PreferredBrowser: Int {
        case none /// 저장되지 않은 상태
        case `internal` /// 앱 내부에서 열기 선호
        case external /// 관련 앱 또는 브라우저에서 열기 선호
    }
    
    static var preferredBrowser: PreferredBrowser {
        get {
            let rawValue = UserDefaults.standard.integer(forKey: "preferToOpenInThisApp")
            return PreferredBrowser(rawValue: rawValue) ?? .none
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "preferToOpenInThisApp")
        }
    }
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
        /// 자체 브라우저 vc로 열기
//        guard let openUrlVC = UIStoryboard(name: "OpenURLViewController", bundle: nil).instantiateViewController(identifier: "OpenURLViewController") as? OpenURLViewController else { return }
//
//        openUrlVC.url = url
//
//        self.present(UINavigationController(rootViewController: openUrlVC), animated: true, completion: nil)
        
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
