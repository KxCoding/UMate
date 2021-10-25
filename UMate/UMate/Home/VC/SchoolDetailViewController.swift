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
    /// 학교 고유 id
    var schoolId: Int?
    
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
    
    
    
    /// Asset의 데이터에서 navigationTitle과 학교 고유 id에 해당하는 url 주소를 불러옵니다.
    /// - Parameters:
    ///   - title: 네비게이션 타이틀
    ///   - id: 학교 고유 id
    func getPageURL(title: String, id: Int)  {
        guard let data = NSDataAsset(name: "university_info")?.data else { return }
        
        guard let source = String(data: data, encoding: .utf8) else { return }
        
        let lines = source.components(separatedBy: "###").dropFirst()
        
        for line in lines {
            let values = line.components(separatedBy: ",")
            guard values.count == 7 else {
                continue
            }
            
            // 학교 고유 아이디
            let index = Int(values[0].trimmingCharacters(in: .whitespacesAndNewlines))
            
            // 학교 홈페이지 URL
            let homepage = "https://" + values[2].trimmingCharacters(in: .whitespaces)
            
            // 학교 포탈 URL
            let portal = values[3].trimmingCharacters(in: .whitespaces)
            
            // 학교 도서관 URL
            let library = values[4].trimmingCharacters(in: .whitespaces)
            
            // 학교 캠퍼스맵 URL
            let map = values[5].trimmingCharacters(in: .whitespaces)
            
            if index == id {
                if title == "학교 홈페이지" {
                    url = homepage
                } else if title == "포탈" {
                    url = portal
                } else if title == "도서관" {
                    url = library
                } else if title == "캠퍼스맵" {
                    url = map
                }
            }
        }
    }
    
    
    /// ViewController가 메모리에 로드되면 호출됩니다.
    ///
    /// navigationTitle, schoolId로 웹 페이지 URL을 받아서 웹 뷰에 로드합니다.
    /// 만약 URL 정보가 없을 경우, 알림창을 띄우고 홈 화면으로 돌아갑니다.
    override func viewDidLoad() {
        super.viewDidLoad()

        // navigationTitle, schoolId로 웹 페이지 URL을 받아옵니다.
        if let title = navigationTitle, let id = schoolId {
            navigationItem.title = "\(title)"
            getPageURL(title: title, id: id)
        }
        
        // 받아온 URL을 웹 뷰에 로드합니다. URL을 받아오지 못할 경우, 알림창을 띄우고 홈 화면으로 이동합니다.
        if let urlStr = url {
            if let url = URL(string: urlStr) {
                let request = URLRequest(url: url)
                
                webView.load(request)
            } else {
                alert(title: "알림",
                      message: "\(navigationItem.title!) 페이지 URL 정보가 없습니다.") { _ in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        } else {
            alert(title: "알림",
                  message: "\(navigationItem.title!) 페이지 URL 정보가 없습니다.") { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}
