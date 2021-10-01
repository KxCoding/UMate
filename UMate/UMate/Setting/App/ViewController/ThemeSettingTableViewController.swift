//
//  ThemeSettingTableViewController.swift
//  ThemeSettingTableViewController
//
//  Created by 안상희 on 2021/08/08.
//

import UIKit


/// 사용자 계정 설정의 테마 설정 화면 ViewController 클래스
///
/// 사용자 설정에 따라 앱의 테마를 설정할 수 있습니다.
/// - Author: 안상희
class ThemeSettingTableViewController: UITableViewController {
    /// 시스템 설정 (자동) UIView
    @IBOutlet weak var autoContainerView: UIView!
    
    /// 라이트 모드 UIView
    @IBOutlet weak var lightContainerView: UIView!
    
    /// 다크 모드 UIView
    @IBOutlet weak var darkContainerView: UIView!
    
    
    /// 시스템 설정 (자동)이 체크되었음을 나타내는 UIView
    @IBOutlet weak var autoImageView: UIImageView!
    
    /// 라이트 모드가 체크되었음을 나타내는 UIView
    @IBOutlet weak var lightImageView: UIImageView!
    
    /// 다크 모드가 체크되었음을 나타내는 UIView
    @IBOutlet weak var darkImageView: UIImageView!
    
    
    
    /// 테마를 설정합니다.
    /// - Parameter theme: 앱의 인터페이스 스타일을 나타내기 위한 상수
    func selectTheme(theme: UIUserInterfaceStyle) {
        autoContainerView.layer.borderWidth = theme == .unspecified ? 2 : 0
        lightContainerView.layer.borderWidth = theme == .light ? 2 : 0
        darkContainerView.layer.borderWidth = theme == .dark ? 2 : 0
        
        autoImageView.isHighlighted = theme == .unspecified
        lightImageView.isHighlighted = theme == .light
        darkImageView.isHighlighted = theme == .dark
        
        UIView.animate(withDuration: 0.3) {
            self.view.window?.overrideUserInterfaceStyle = theme
        }
    }
    
    
    /// 셀을 선택하면 호출됩니다.
    /// - Parameters:
    ///   - tableView: 이 메소드를 호출한 테이블뷰
    ///   - indexPath: 선택된 셀의 indexPath
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        // 자동 (시스템 설정)
        case 0:
            selectTheme(theme: .unspecified)
        // 라이트 모드
        case 1:
            selectTheme(theme: .light)
        // 다크 모드
        case 2:
            selectTheme(theme: .dark)
        default:
            break
        }
    }
    
    
    /// ViewController가 메모리에 로드되면 호출됩니다.
    ///
    /// View의 초기화 작업을 진행합니다.
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .none
        
        [autoContainerView, lightContainerView, darkContainerView].forEach {
            $0?.setViewTheme()
        }
        
        selectTheme(theme: .unspecified)
    }
}
