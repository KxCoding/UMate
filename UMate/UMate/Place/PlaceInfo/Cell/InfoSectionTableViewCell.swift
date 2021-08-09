//
//  InfoSectionTableViewCell.swift
//  UMate
//
//  Created by Effie on 2021/07/16.
//

import UIKit
import WebKit

class InfoSectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var placeTypeImage: UIImageView!
    @IBOutlet weak var placeNameLabel: UILabel!
    
    @IBOutlet weak var universityLabel: UILabel!
    @IBOutlet weak var districtLabel: UILabel!
    @IBOutlet weak var keywordLabel: UILabel!
    @IBOutlet weak var placeTypeLabel: UILabel!
    
    @IBOutlet weak var openInstagramButton: UIButton!
    @IBOutlet weak var openSafariButton: UIButton!
    @IBOutlet weak var bookmarkButton: UIButton!
    
    
    /// 정보를 표시할 가게
    var target: Place!
    
    /// 셀의 부모 뷰 컨트롤러
    weak var viewController: UIViewController?
    
    
    /// 셀 내부 각 뷰들이 표시하는 content 초기화
    /// - Parameter content: 표시할 내용을 담은 Place 객체
    func configure(with content: Place, viewController: UIViewController) {
        
        target = content
        self.viewController = viewController
        
        placeTypeImage.image = target.typeIconImage
        placeNameLabel.text = target.name
        
        universityLabel.text = target.university
        districtLabel.text = target.district
        
        keywordLabel.text = target.keywords.first
        placeTypeLabel.text = target.type.rawValue
        
        if target.instagramID == nil {
            openInstagramButton.isHidden = true
        }
        
        if target.url == nil {
            openSafariButton.isHidden = true
        }
        
        
    }
    
    
    /// 셀 초기화
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    /// 버튼을 누르면 해당 가게 인스타그램 open
    /// - Parameter sender: 버튼
    @IBAction func openInInstagram(_ sender: UIButton) {
        guard let id = target.instagramID,
              let url = URL(string: "https://instagram.com/\(id)") else { return }
        viewController?.openUrl(with: url)
    }
    
    
    /// 버튼을 누르면 해당 가게 관련 URL open
    /// - Parameter sender: 버튼
    @IBAction func openInSafari(_ sender: Any) {
        guard let urlString = target.url, let url = URL(string: urlString) else { return }
        
        viewController?.openUrl(with: url)
    }
    
}





/// 웹 링크를 열 수 있는 화면
class OpenURLViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    var urlString: String? {
        get {
            return nil
        }
        set {
            guard let urlStr = newValue else { return }
            url = URL(string: urlStr)
        }
    }
    
    var url: URL?
     
    
    /// 현재 웹 뷰 화면을 dismiss합니다.
    /// - Parameter sender: Done 버튼
    @IBAction func done(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    /// 현재 웹 뷰에서 표시하는 웹 컨텐츠에 대한 공유 작업을 수행할 수 있도록 선택 가능한 메뉴를 표시합니다.
    /// - Parameter sender: 공유 버튼
    @IBAction func doContexualAction(_ sender: Any) {
        
    }
    
    
    /// 현재 웹 뷰에서 표시하는 웹 컨텐츠를 사파리에서 엽니다.
    @IBAction func openInSafari(_ sender: Any) {
        
        // 현재!!! 링크!!! 여야해요
        if let currentContent = webView.url, UIApplication.shared.canOpenURL(currentContent) {
            UIApplication.shared.open(currentContent, options: [:], completionHandler: nil)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(#function, self)
        
        if let str = urlString, let url = URL(string: str) {
            let request = URLRequest(url: url)
            webView.load(request)

        }
        
        
    }
    
}
