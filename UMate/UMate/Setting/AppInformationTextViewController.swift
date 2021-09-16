//
//  AppInformationTextViewController.swift
//  AppInformationTextViewController
//
//  Created by 안상희 on 2021/09/02.
//

import UIKit

/// 사용자 계정 화면에서 서비스 이용약관, 개인정보 처리방침, 오픈소스 라이선스, 커뮤니티 이용 규칙을 보여주는 ViewController
/// - Author: 안상희
class AppInformationTextViewController: UIViewController {
    
    /// 선택한 메뉴에 맞는 메뉴 타이틀이 저장된 변수
    var menu: String?
    
    /// 데이터가 나타나는 textView
    @IBOutlet weak var textView: UITextView!
    
    
    /// 메뉴에 해당하는 데이터를 불러옵니다.
    func getTextFile() {
        if menu! == "서비스 이용약관" {
            guard let serviceAssetData = NSDataAsset(name: "Service")?.data else { return }
            
            guard let serviceStr = String(data: serviceAssetData, encoding: .utf8) else { return }
            
            textView.text = serviceStr
        } else if menu! == "개인정보 처리방침" {
            guard let privacyAssetData = NSDataAsset(name: "Privacy")?.data else { return }
            
            guard let privacyStr = String(data: privacyAssetData, encoding: .utf8) else { return }
            
            textView.text = privacyStr
        } else if menu! == "오픈소스 라이선스" {
            guard let openSourceAssetData = NSDataAsset(name: "OpenSource")?.data else { return }
            
            guard let openSourceStr =
                    String(data: openSourceAssetData, encoding: .utf8) else { return }
            
            textView.text = openSourceStr
        } else if menu! == "커뮤니티 이용 규칙" {
            guard let communityRulesAssetData =
                    NSDataAsset(name: "CommunityRules")?.data else { return }
            
            guard let communityRulesStr =
                    String(data: communityRulesAssetData, encoding: .utf8) else { return }
            
            textView.text = communityRulesStr
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getTextFile()
        
        textView.isEditable = false
        
        self.navigationItem.title = menu
    }
}
