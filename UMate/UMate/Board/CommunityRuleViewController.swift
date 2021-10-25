//
//  CommunityRuleViewController.swift
//  UMate
//
//  Created by Chris Kim on 2021/07/28.
//

import UIKit


/// 커뮤니티 이용규칙 화면
/// - Author: 김정민(kimjm010@icloud.com)
class CommunityRuleViewController: UIViewController {

    /// 커뮤니티 이용규칙
    @IBOutlet weak var communityRuleTextView: UITextView!
    

    /// 이용규칙 화면을 닫습니다.
    /// - Parameter sender: 닫기 버튼
    @IBAction func closeVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    /// 뷰 컨트롤러의 뷰 계층이 메모리에 올라간 뒤 호출됩니다.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let communityRuleAssetData = NSDataAsset(name: "communityRule")?.data,
           let communityRuleStr = String(data: communityRuleAssetData, encoding: .utf8) {
            communityRuleTextView.text = communityRuleStr
        }
    }
}
