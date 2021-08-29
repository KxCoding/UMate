//
//  AppDelegate.swift
//  UMate
//
//  Created by 안상희 on 2021/07/12.
//

import UIKit
import DropDown

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        DropDown.startListeningToKeyboard()
//        if 맵을 처음실행 {
//            키 체인 초기화
//        } 그다음부터는 초기화가 되면 안되게..
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

//  0 id
//  1 가에이름 > 가게이름
//  2 전화번호 > tel
//  3 홈페이지 > homepage
//  4 좌표 > lat
//  5 좌표 > long
//.
//.
//.
//.
//.
// 00 만든 날짜
// 00 수정 날짜


// 공지사항
// 0 id  > notice ID = Int
// 1 title >  title = String
// 2 content > content = String
// 3 공개 필드 (boolean)
// 4 만든 날짜 > insertDate
// 5 수정 날짜 > updateDate


// FAQ
// 0 id  > notice ID = Int
// 1 title >  title = String
// 2 content > content = String
// 3 공개 필드 > ispublic = bool
// 4 만든 날짜 > insertDate = date
// 5 수정 날짜 > updateDate = date


// 회원(User, Member)

// id > userid
// date > joindate
// update > update
// lastLoginDate
// name
// nickname
// email
// password (사용자가 입력한 비밀번호를 그대로 입력하면 안됨..) 모든 비밀번호는 관리자도 모르게 암호화해서 저장해야함.
// enterenceYear
// universityName
// 학교인증 플래그 > universityConfirmed
// verifyCodeNumber
// image > selectedProfileImage
// 인증 플래그 > emailconfiemed
// termsofconditionTextView 만약에 선택 약관이있다면 필요함
