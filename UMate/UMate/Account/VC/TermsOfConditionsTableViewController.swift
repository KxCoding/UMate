//
//  TermsOfConditionsTableViewController.swift
//  TermsOfConditionsTableViewController
//
//  Created by 황신택 on 2021/07/28.
//

import UIKit
import BEMCheckBox

/// 이용약관 스크립트를 구현하고 해당 스크립트에 관한 체크박스를 구현하는 클래스.
/// Author: 황신택
class TermsOfConditionsTableViewController: UITableViewController {
    ///CheckBox 1 ... 6
    @IBOutlet weak var checkbox1: BEMCheckBox!
    @IBOutlet weak var checkBox2: BEMCheckBox!
    @IBOutlet weak var checkBox3: BEMCheckBox!
    @IBOutlet weak var checkBox4: BEMCheckBox!
    @IBOutlet weak var checkBox5: BEMCheckBox!
    @IBOutlet weak var checkBox6: BEMCheckBox!
    
    /// 연령 레이블
    @IBOutlet weak var minimumAge: UILabel!
    
    /// 다음 화면으로 가는 버튼
    @IBOutlet weak var checkedEmailButton: UIButton!
    
    /// 서비스 약관 텍스트 뷰
    @IBOutlet weak var service: UITextView!
    
    /// 개인정보 약관 텍스트 뷰
    @IBOutlet weak var privacy: UITextView!
    
    /// 커뮤니티 약관 텍스트 뷰
    @IBOutlet weak var community: UITextView!
    
    /// 광고수신 약관 텍스트 뷰
    @IBOutlet weak var advertisement: UITextView!
    
    /// 체크박스 아울렛을 저장하기위한 배열 속성
    var list = [BEMCheckBox]()
    
    
    /// 체크박스가 모두 체크 되어있는지 확인합니다.
    /// - Parameter sender: checkedEmailButton 에 전달되고 조건 충족시 다음화면으로 갑니다.
    @IBAction func checkToAllcheckboxes(_ sender: Any) {
        let checkBoxList = [checkBox2, checkBox3, checkBox4, checkBox5, checkBox6]
        
        for elem in checkBoxList {
            guard elem?.on == true else {
                alert(title: "알림", message: "필수 이용 약관에 모두 동의 해야합니다.", handler: nil)
                return
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //체크박스의 각종 속성들을 클로저로 초기화
        checkbox1.delegate = self
        [checkbox1, checkBox2, checkBox3, checkBox4, checkBox5, checkBox6].forEach({
            $0?.animationDuration = 0.3
            $0?.onAnimationType = .bounce
            $0?.tintColor = .lightGray
            $0?.onFillColor = .black
            $0?.onCheckColor = .white
            $0?.onTintColor = .white
            $0?.offAnimationType = .bounce
            
        })
        

        [service, community, privacy, advertisement].forEach({
            $0?.layer.cornerRadius = 10
            $0?.clipsToBounds = true
            
        })
        
        // 버튼에 공통 스타일 적용
        checkedEmailButton.setButtonTheme()
        
        // Assets에 추가해놓은 이용약관 스크립txt파일을 문자열로 가져옵니다.
        if let serviceAssetData = NSDataAsset(name: "Service")?.data,
           let privacyAssetData = NSDataAsset(name: "Privacy")?.data,
           let locationAssetData = NSDataAsset(name: "Location")?.data,
           let serviceStr = String(data: serviceAssetData, encoding: .utf8),
           let privacyStr = String(data: privacyAssetData, encoding: .utf8),
           let locationStr = String(data: locationAssetData, encoding: .utf8)   {
            
            service.text = serviceStr
            privacy.text = privacyStr
            community.text = locationStr
        }
        
        // 네이게이션 back button 라이트 다크모드 지원합니다.
        navigationController?.navigationBar.tintColor = UIColor.dynamicColor(light: .black, dark: .lightGray)
        
    }
    
}


extension TermsOfConditionsTableViewController: BEMCheckBoxDelegate {
    /// 체크박스를 탭할시 발생하는 이벤트를 처리하는 메소드입니다.
    /// - Parameter checkBox: BEMCheckBox에 전달되고 delegate가 선언된 속성에만 적용이 됩니다.
    func didTap(_ checkBox: BEMCheckBox) {
        list = [checkbox1, checkBox2, checkBox3, checkBox4, checkBox5, checkBox6]
        if checkBox.on == true {
            list.forEach({ $0.on = true })
        } else {
            list.forEach{ $0.on = false }
        }
        
    }
    
}
