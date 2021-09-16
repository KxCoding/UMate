//
//  BrowserSettingTableViewController.swift
//  BrowserSettingTableViewController
//
//  Created by Effie on 2021/08/23.
//

import Loaf
import UIKit


/// 브라우저 오픈 방식 관리 메뉴 VC 클래스
/// - Author: 박혜정(mailmelater11@gmail.com)
class BrowserSettingTableViewController: UITableViewController {
    
    // MARK: Outlets
    
    /// 앱 내 브라우저로 열기 옵션의 체크박스 이미지 뷰
    @IBOutlet weak var internalImageview: UIImageView!
    
    /// 외부 앱으로 열기 옵션의 체크박스 이미지 뷰
    @IBOutlet weak var externalImageView: UIImageView!
    
    /// 인스타그램 테스트 버튼
    @IBOutlet weak var openInstagramBtn: UIButton!
    
    /// web url 테스트 버튼
    @IBOutlet weak var openWebPageBtn: UIButton!
    
    
    // MARK: Properties
    
    /// 테스트용 인스타그램 URL
    let testInstagramURL = URL(string: "https://instagram.com/lagrillia")
    
    /// 테스트용 웹 URL
    let testWebURL = URL(string: "http://naver.me/xKQWQLcD")
    
    /// 특정 방식이 선택되었을 때 표시할 토스트
    lazy var selectedBrowserLoaf: Loaf = Loaf("선호 브라우저가 변경되었습니다",
                                              state: .info,
                                              location: .bottom,
                                              presentingDirection: .vertical,
                                              dismissingDirection: .vertical,
                                              sender: self)
    
    // MARK: Actions
    
    /// 선호 브라우저 설정에 따라 인스타그램 열기 테스트를 수행하는 메소드
    /// - Parameter sender: 선호 브라우저 설정에 따라 open instagram 테스트
    @IBAction func testInstagramUrl(_ sender: UIButton) {
        guard let url = testInstagramURL else { return }
        openUrl(with: url)
    }
    
    
    /// 선호 브라우저 설정에 따라 웹 URL 열기 테스트를 수행하는 메소드
    /// - Parameter sender: 선호 브라우저 설정에 따라 open web page 테스트
    @IBAction func testWebPageUrl(_ sender: UIButton) {
        guard let url = testWebURL else { return }
        openUrl(with: url)
    }
    
    
    // MARK: Methods
    
    /// 브라우저를 선택하면 알맞은 작업을 처리하는 메소드
    /// - Parameter option: 선택한 브라우저 옵션
    private func selectPreferredBrowser(prefer option: Preference.PreferredBrowser) {
        // preferrence 설정
        Preference.preferredBrowser = option
        
        // 선택한 옵션에 따라 UI 업데이트
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [openInstagramBtn, openWebPageBtn].forEach { button in
            button?.configureStyle(with: [.smallRoundedRect])
        }
        selectPreferredBrowser(prefer: Preference.preferredBrowser)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        selectPreferredBrowser(prefer: Preference.preferredBrowser)
    }
    
    
    // MARK: TableView Method
    
    /// 테이블의 항목을 선택하면 호출되는 메소드
    /// - Parameters:
    ///   - tableView: 항목을 포함하는 테이블 뷰
    ///   - indexPath: 선택한 항목의 index path
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        
        // 첫번째 메뉴 누르면 초기화
        case 0:
            selectPreferredBrowser(prefer: .none)
            tableView.deselectRow(at: indexPath, animated: true)
            
        // 선택한 옵션으로 설정 변경
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
