//
//  ThemeSettingTableViewController.swift
//  ThemeSettingTableViewController
//
//  Created by 안상희 on 2021/08/08.
//

import UIKit

class ThemeSettingTableViewController: UITableViewController {

    @IBOutlet weak var autoContainerView: UIView!
    @IBOutlet weak var lightContainerView: UIView!
    @IBOutlet weak var darkContainerView: UIView!
    
    @IBOutlet weak var autoImageView: UIImageView!
    @IBOutlet weak var lightImageView: UIImageView!
    @IBOutlet weak var darkImageView: UIImageView!
    
    
    /// 테마 설정 메소드
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
    
    
    /// 셀을 선택하면 호출되는 메소드
    /// - Parameters:
    ///   - tableView: 이 메소드를 호출한 테이블뷰
    ///   - indexPath: 선택된 셀의 indexPath
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch indexPath.row {
        // An unspecified interface style.
        case 0:
            selectTheme(theme: .unspecified)
            
        // The light interface style.
        case 1:
            selectTheme(theme: .light)
            
        // The dark interface style.
        case 2:
            selectTheme(theme: .dark)
        default:
            break
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .none
        
        [autoContainerView, lightContainerView, darkContainerView].forEach {
            $0?.setViewTheme()
        }
        
        selectTheme(theme: .unspecified)
    }
}
