//
//  AppInformationTextViewController.swift
//  AppInformationTextViewController
//
//  Created by 안상희 on 2021/09/02.
//

import UIKit

class AppInformationTextViewController: UIViewController {
    
    var menu: String?
    
    @IBOutlet weak var textView: UITextView!
    
    
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
            
            guard let openSourceStr = String(data: openSourceAssetData, encoding: .utf8) else { return }
            textView.text = openSourceStr
        } else if menu! == "커뮤니티 이용 규칙" {
            guard let communityRulesAssetData = NSDataAsset(name: "CommunityRules")?.data else { return }
            
            guard let communityRulesStr = String(data: communityRulesAssetData, encoding: .utf8) else { return }
            textView.text = communityRulesStr
        }
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getTextFile()
        textView.isEditable = false
        self.navigationItem.title = menu
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
