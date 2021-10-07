//
//  Preference.swift
//  UMate
//
//  Created by Effie on 2021/08/27.
//

import UIKit


/// 앱 설정 정보
///
/// user default 값에 저장한 설정 정보에 접근하는 속성입니다. 선호 브라우저 등의 사용자의 앱 설정 데이터를 제공합니다.
/// - Author: 박혜정(mailmelater11@gmail.com)
class Preference {
    
    /// 선호하는 브라우저를 나타내는 열거형
    enum PreferredBrowser: Int {
        
        /// 저장되지 않음
        ///
        /// 사용자가 아직 선호 브라우저를 선택하지 않았거나, 설정을 초기화했을 때 저장되는 케이스입니다.
        case none
        
        /// 앱 내부에서 열기
        ///
        /// 앱 내부 사파리 컨트롤러로 웹 페이지를 열람합니다.
        case `internal`
        
        /// 앱 외부에서 열기
        ///
        /// 인스타그램, 네이버 등 url과 관련 있는 앱에서 url을 엽니다.
        case external
    }
    
    
    
    /// 선호 브라우저
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
