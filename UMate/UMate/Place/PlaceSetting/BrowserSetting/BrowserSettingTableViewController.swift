//
//  BrowserSettingTableViewController.swift
//  BrowserSettingTableViewController
//
//  Created by Effie on 2021/08/23.
//

import Loaf
import UIKit


/// 선호 브라우저 관리 화면
/// - Author: 박혜정(mailmelater11@gmail.com)
class BrowserSettingTableViewController: UITableViewController {
    
    // MARK: Outlets
    
    /// 앱 내부 선호 체크박스 이미지 뷰
    @IBOutlet weak var internalImageview: UIImageView!
    
    /// 외부 앱 선호 체크박스 이미지 뷰
    @IBOutlet weak var externalImageView: UIImageView!
    
    /// 인스타그램 테스트 버튼
    @IBOutlet weak var openInstagramBtn: UIButton!
    
    /// 웹페이지 url 테스트 버튼
    @IBOutlet weak var openWebPageBtn: UIButton!
    
    
    // MARK: Properties
    
    /// 테스트용 인스타그램 URL
    let testInstagramURL = URL(string: "https://instagram.com/lagrillia")
    
    /// 테스트용 웹페이지 URL
    let testWebURL = URL(string: "http://naver.me/xKQWQLcD")
    
    /// 선호 브라우저 선택 확인 토스트
    lazy var selectedBrowserLoaf: Loaf = Loaf("선호 브라우저가 변경되었습니다",
                                              state: .info,
                                              location: .bottom,
                                              presentingDirection: .vertical,
                                              dismissingDirection: .vertical,
                                              sender: self)
    
    /// 초기화 확인 토스트
    lazy var resetLoaf: Loaf = Loaf("설정이 초기화되었습니다",
                                              state: .info,
                                              location: .bottom,
                                              presentingDirection: .vertical,
                                              dismissingDirection: .vertical,
                                              sender: self)
    
    // MARK: Actions
    
    /// 인스타그램 열기를 테스트합니다.
    /// - Parameter sender: 선호 브라우저 설정에 따라 open instagram 테스트
    /// - Author: 박혜정(mailmelater11@gmail.com)
    @IBAction func testInstagramUrl(_ sender: UIButton) {
        guard let url = testInstagramURL else { return }
        openUrl(with: url)
    }
    
    
    /// 웹페이지 열기를 테스트합니다.
    /// - Parameter sender: 선호 브라우저 설정에 따라 open web page 테스트
    /// - Author: 박혜정(mailmelater11@gmail.com)
    @IBAction func testWebPageUrl(_ sender: UIButton) {
        guard let url = testWebURL else { return }
        openUrl(with: url)
    }
    
    
    // MARK: Methods
    
    /// 선택 사항을 저장하고 UI를 업데이트 합니다.
    /// - Parameter option: 선택한 브라우저 옵션
    /// - Author: 박혜정(mailmelater11@gmail.com)
    private func selectPreferredBrowser(prefer option: Preference.PreferredBrowser) {
        Preference.preferredBrowser = option
        
        switch option {
        case .none:
            internalImageview.isHighlighted = false
            externalImageView.isHighlighted = false
        case .internal:
            internalImageview.isHighlighted = true
            externalImageView.isHighlighted = !internalImageview.isHighlighted
        case .external:
            internalImageview.isHighlighted = false
            externalImageView.isHighlighted = !internalImageview.isHighlighted
        }
    }
    
    
    // MARK: View Lifecycle Method
    
    /// 뷰가 로드되면 화면을 초기화합니다.
    /// - Author: 박혜정(mailmelater11@gmail.com)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [openInstagramBtn, openWebPageBtn].forEach { button in
            button?.configureStyle(with: [.smallRoundedRect])
        }
    }
    
    
    /// 뷰가 화면에 표시되기 전에 설정에 맞게 UI를 업데이트 합니다.
    /// - Author: 박혜정(mailmelater11@gmail.com)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        selectPreferredBrowser(prefer: Preference.preferredBrowser)
    }
    
    
    // MARK: TableView Method
    
    /// 테이블의 항목을 선택하면 선호 브라우저를 저장하고 토스트를 표시합니다.
    ///
    /// 초기화 항목을 누르면 선택상태를 즉시 해제합니다.
    /// - Parameters:
    ///   - tableView: 항목을 포함하는 테이블 뷰
    ///   - indexPath: 선택한 항목의 index path
    /// - Author: 박혜정(mailmelater11@gmail.com)
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            selectPreferredBrowser(prefer: .none)
            tableView.deselectRow(at: indexPath, animated: true)
            resetLoaf.show(.custom(1.2))
            
        case 1:
            switch indexPath.row {
            case 0:
                selectPreferredBrowser(prefer: .internal)
                selectedBrowserLoaf.show(.custom(1.2))
            case 1:
                selectPreferredBrowser(prefer: .external)
                selectedBrowserLoaf.show(.custom(1.2))
            default:
                break
            }
            
        default:
            break
        }
    }
}
