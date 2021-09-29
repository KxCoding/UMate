//
//  CommunityRuleViewController.swift
//  UMate
//
//  Created by Chris Kim on 2021/07/28.
//

import UIKit


/// 커뮤니티 이용규칙을 표시하는 뷰컨트롤러
/// - Author: 김정민(kimjm010@icloud.com)
class CommunityRuleViewController: UIViewController {

    /// 이용규칙 뷰컨트롤러를 닫습니다.
    /// - Parameter sender: 닫기 버튼
    /// - Author: 김정민(kimjm010@icloud.com)
    @IBAction func closVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
