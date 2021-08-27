//
//  BrowserSettingTableViewController.swift
//  BrowserSettingTableViewController
//
//  Created by Effie on 2021/08/23.
//

import UIKit

class BrowserSettingTableViewController: UITableViewController {
    
    // MARK: outlets
    
    @IBOutlet weak var internalImageview: UIImageView!
    @IBOutlet weak var externalImageView: UIImageView!
    
    @IBOutlet weak var openInstagramBtn: UIButton!
    @IBOutlet weak var openWebPageBtn: UIButton!
    
    
    // MARK: 기타 속성
    let testInstagramURL = URL(string: "https://instagram.com/lagrillia")
    let testWebURL = URL(string: "http://naver.me/xKQWQLcD")
    
    
    /// 브라우저를 선택하면 알맞은 작업을 처리하는 메소드
    /// - Parameter option: 선택한 브라우저 옵션
    private func selectPreferredBrowser(prefer option: Preference.PreferredBrowser) {
        /// preferrence 설정
        Preference.preferredBrowser = option
        
        /// 선택한 옵션에 따라 UI 업데이트
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
            button?.configureStyle(with: [.squircleSmall])
        }
        selectPreferredBrowser(prefer: Preference.preferredBrowser)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        selectPreferredBrowser(prefer: Preference.preferredBrowser)
    }
    
    
    // MARK: TableView Method
    
    /// 테이블의 항목을 선택하면 호출되는 메소드
    /// - Parameters:
    ///   - tableView: 항목을 포함하는 테이블 뷰
    ///   - indexPath: 선택한 항목의 index path
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        /// 첫번째 메뉴 누르면 초기화
        case 0:
            selectPreferredBrowser(prefer: .none)
            tableView.deselectRow(at: indexPath, animated: true)
            
        /// 선택한 옵션으로 설정 변경
        case 1:
            switch indexPath.row {
            case 0:
                selectPreferredBrowser(prefer: .internal)
                
            case 1:
                selectPreferredBrowser(prefer: .external)
                
            default:
                break
            }
            
        default:
            break
        }
    }
    
    
    // MARK: Actions
    
    /// - Parameter sender: 선호 브라우저 설정에 따라 open instagram 테스트
    @IBAction func testInstagramUrl(_ sender: UIButton) {
        guard let url = testInstagramURL else { return }
        openUrl(with: url)
    }
    
    
    /// - Parameter sender: 선호 브라우저 설정에 따라 open web page 테스트
    @IBAction func testWebPageUrl(_ sender: UIButton) {
        guard let url = testWebURL else { return }
        openUrl(with: url)
    }

}
