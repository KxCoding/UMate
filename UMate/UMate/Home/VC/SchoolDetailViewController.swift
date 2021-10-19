//
//  SchoolDetailViewController.swift
//  UMate
//
//  Created by 안상희 on 2021/10/07.
//

import UIKit
import WebKit


/// 학교 상세 정보 화면
/// 학교 홈페이지, 포탈, 도서관 홈페이지, 캠퍼스맵을 제공합니다.
/// Author: 안상희
class SchoolDetailViewController: UIViewController {
    /// 네비게이션 타이틀
    var navigationTitle: String?
    
    /// 웹 페이지 주소
    var url: String?
    
    /// 웹 뷰
    @IBOutlet weak var webView: WKWebView!
    
    
    /// 사파리에서 웹 페이지를 실행합니다.
    /// - Parameter sender: 사파리 버튼
    @IBAction func openInSafari(_ sender: Any) {
        if let urlStr = url {
            if let url = URL(string: urlStr) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
    }
    
    
    /// ViewController가 메모리에 로드되면 호출됩니다.
    ///
    /// 웹 페이지 URL을 받아서 웹 뷰에 로드합니다.
    override func viewDidLoad() {
        super.viewDidLoad()

        // navigationTitle을 설정합니다.
        if let title = navigationTitle {
            navigationItem.title = "\(title)"
        }
        
        // 받아온 URL을 웹 뷰에 로드합니다. URL을 받아오지 못할 경우, 알림창을 띄우고 홈 화면으로 이동합니다.
        if let urlStr = url {
            if let url = URL(string: urlStr) {
                let request = URLRequest(url: url)
                
                webView.load(request)
            } 
        }
    }
}
