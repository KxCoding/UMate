//
//  Preference.swift
//  UMate
//
//  Created by Effie on 2021/08/27.
//

import UIKit

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
