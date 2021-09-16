//
//  Preference.swift
//  UMate
//
//  Created by Effie on 2021/08/27.
//

import UIKit


/// user default 에 저장한 설정 데이터에 접근하는 계산 속성이 포함된 클래스
///
/// 설정 데이터는 형식 계산 속성으로 선언합니다.
/// - Author: 박혜정(mailmelater11@gmail.com)
class Preference {
    
    /// 선호하는 브라우저를 나타내는 열거형
    enum PreferredBrowser: Int {
        // 저장되지 않은 상태
        case none
        
        // 앱 내부에서 열기 선호
        case `internal`
        
        // 관련 앱 또는 브라우저에서 열기 선호
        case external
    }
    
    /// user default에 저장된 사용자 설정 데이터에 접근하는 속성
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
