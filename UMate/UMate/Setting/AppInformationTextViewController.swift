//
//  AppInformationTextViewController.swift
//  AppInformationTextViewController
//
//  Created by 안상희 on 2021/09/02.
//

import UIKit

class AppInformationTextViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    
    func getTextFile() {
        /// initialze TermsOfConditions's Scripts
        guard let openSourceAssetData = NSDataAsset(name: "OpenSource")?.data else { return }
        guard let communityRulesAssetData = NSDataAsset(name: "CommunityRules")?.data else { return }
        
        guard let openSourceStr = String(data: openSourceAssetData, encoding: .utf8) else { return }
        guard let communityRulesStr = String(data: communityRulesAssetData, encoding: .utf8) else { return }

        textView.text = openSourceStr
        print(openSourceStr)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getTextFile()
        
        self.navigationItem.title = "오픈소스 라이선스"
        
    }
    
}
