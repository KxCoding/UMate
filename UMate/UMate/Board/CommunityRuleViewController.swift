//
//  CommunityRuleViewController.swift
//  UMate
//
//  Created by Chris Kim on 2021/07/28.
//

import UIKit


/// 커뮤니티 이용규칙 클래스
class CommunityRuleViewController: UIViewController {

    /// 이용규칙 뷰 컨트롤러를 닫습니다.
    /// - Parameter sender: 닫기 버튼
    @IBAction func closVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
