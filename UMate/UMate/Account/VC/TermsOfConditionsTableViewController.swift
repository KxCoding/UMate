//
//  TermsOfConditionsTableViewController.swift
//  TermsOfConditionsTableViewController
//
//  Created by 황신택 on 2021/07/28.
//

import BEMCheckBox
import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx


/// 이용약관 화면
/// - Author: 황신택 (sinadsl1457@gmail.com), Author: 장현우(heoun3089@gmail.com)
class TermsOfConditionsTableViewController: UITableViewController {
    /// CheckBox 1 ... 6
    @IBOutlet weak var checkbox1: BEMCheckBox!
    @IBOutlet weak var checkBox2: BEMCheckBox!
    @IBOutlet weak var checkBox3: BEMCheckBox!
    @IBOutlet weak var checkBox4: BEMCheckBox!
    @IBOutlet weak var checkBox5: BEMCheckBox!
    @IBOutlet weak var checkBox6: BEMCheckBox!
    
    /// 최소 연령 레이블
    @IBOutlet weak var minimumAgeLabel: UILabel!
    
    /// 다음 화면 버튼
    @IBOutlet weak var verifyEmailButton: UIButton!
    
    /// 서비스 이용 약관
    @IBOutlet weak var serviceTextView: UITextView!
    
    /// 개인정보 이용 약관
    @IBOutlet weak var privacyTextView: UITextView!
    
    /// 커뮤니티 이용 약관
    @IBOutlet weak var communityTextView: UITextView!
    
    /// 광고수신 약관
    @IBOutlet weak var advertisementTextView: UITextView!
    
    /// 체크박스 아웃렛 배열
    var list = [BEMCheckBox]()
    
    /// 입학 연도
    ///
    /// 이전 화면에서 전달됩니다.
    /// - Author: 장현우(heoun3089@gmail.com)
    var entranceYear: String?
    
    
    /// 체크박스가 모두 체크되어있는지 확인합니다.
    /// 조건을 충족하면 다음 화면으로 이동합니다.
    /// - Parameter sender: checkToAllcheckboxesButton
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    @IBAction func checkToAllcheckboxes(_ sender: Any) {
        let checkBoxList = [checkBox2, checkBox3, checkBox4, checkBox5, checkBox6]

        for elem in checkBoxList {
            guard elem?.on == true else {
                alert(title: "알림", message: "필수 이용 약관에 모두 동의 해야합니다.", handler: nil)
                return
            }
        }
    }
    
    
    /// 다음 화면으로 넘어가기 전에 호출됩니다.
    /// - Parameters:
    ///   - segue: 다음 화면 뷰컨트롤러에 대한 정보를 가지고 있는 segue 객체
    ///   - sender: segue를 연결한 객체
    /// - Author: 장현우(heoun3089@gmail.com)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? EmailVerificationViewController {
            vc.entranceYear = entranceYear
        }
    }
    
    
    /// 초기화 작업을 진행합니다.
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        [serviceTextView, communityTextView, privacyTextView, advertisementTextView].forEach({
            $0?.layer.cornerRadius = 10
            $0?.clipsToBounds = true
        })
        
        verifyEmailButton.setToEnabledButtonTheme()
        
        // Assets에 추가해놓은 이용약관 스크립트 txt 파일을 문자열 데이터로 가져옵니다.
        if let serviceAssetData = NSDataAsset(name: "Service")?.data,
           let privacyAssetData = NSDataAsset(name: "Privacy")?.data,
           let locationAssetData = NSDataAsset(name: "Location")?.data,
           let advertisementData = NSDataAsset(name: "advertisement")?.data,
           let serviceStr = String(data: serviceAssetData, encoding: .utf8),
           let privacyStr = String(data: privacyAssetData, encoding: .utf8),
           let locationStr = String(data: locationAssetData, encoding: .utf8),
           let advertisementStr = String(data: advertisementData, encoding: .utf8) {
            
            serviceTextView.text = serviceStr
            privacyTextView.text = privacyStr
            communityTextView.text = locationStr
            advertisementTextView.text = advertisementStr
        }
        
        Observable.just(UIColor.dynamicColor(light: .darkGray, dark: .lightGray))
            .bind(to: (navigationController?.navigationBar.rx.tintColor)!)
            .disposed(by: rx.disposeBag)
    }
}


extension TermsOfConditionsTableViewController: BEMCheckBoxDelegate {
    /// 첫 번째 체크박스를 탭하면 호출됩니다. 모든 체크박스를 토글합니다.
    /// - Parameter checkBox: BEMCheckBox
    /// - Author: 황신택 (sinadsl1457@gmail.com)
    func didTap(_ checkBox: BEMCheckBox) {
        list = [checkbox1, checkBox2, checkBox3, checkBox4, checkBox5, checkBox6]
        if checkBox.on == true {
            list.forEach({ $0.on = true })
        } else {
            list.forEach{ $0.on = false }
        }
    }
}
