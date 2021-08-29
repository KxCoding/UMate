//
//  TermsOfConditionsTableViewController.swift
//  TermsOfConditionsTableViewController
//
//  Created by 황신택 on 2021/07/28.
//

import UIKit
import BEMCheckBox


class TermsOfConditionsTableViewController: UITableViewController {
    @IBOutlet weak var checkbox1: BEMCheckBox!
    @IBOutlet weak var checkBox2: BEMCheckBox!
    @IBOutlet weak var checkBox3: BEMCheckBox!
    @IBOutlet weak var checkBox4: BEMCheckBox!
    @IBOutlet weak var checkBox5: BEMCheckBox!
    @IBOutlet weak var checkBox6: BEMCheckBox!
    
    @IBOutlet weak var serviceTOCTextView: UITextView!
    @IBOutlet weak var personalInformationTOCTextView: UITextView!
    @IBOutlet weak var communityTOCTextView: UITextView!
    @IBOutlet weak var advertisementTOCTextView: UITextView!
    @IBOutlet weak var minimumAge: UILabel!
    @IBOutlet weak var verifyEmailButton: UIButton!
    
    @IBOutlet weak var service: UITextView!
    @IBOutlet weak var privacy: UITextView!
    @IBOutlet weak var community: UITextView!
    @IBOutlet weak var advertisement: UITextView!
    
    
    @IBAction func nextToEamilButton(_ sender: Any) {
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
        ///checkBox  속성 초기화
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
        
        /// 텍스트뷰 속성 초기화
        [serviceTOCTextView, personalInformationTOCTextView, communityTOCTextView, advertisementTOCTextView].forEach({
            $0?.layer.cornerRadius = 10
            $0?.clipsToBounds = true
            
        })
        
        verifyEmailButton.setButtonTheme()
        
        /// initialze TermsOfConditions's Scripts
        guard let serviceAssetData = NSDataAsset(name: "Service")?.data else { return }
        guard let privacyAssetData = NSDataAsset(name: "Privacy")?.data else { return }
        guard let locationAssetData = NSDataAsset(name: "Location")?.data else { return }
        
        guard let serviceStr = String(data: serviceAssetData, encoding: .utf8) else { return }
        guard let privacyStr = String(data: privacyAssetData, encoding: .utf8) else { return }
        guard let locationStr = String(data: locationAssetData, encoding: .utf8) else { return }
        
        service.text = serviceStr
        privacy.text = privacyStr
        community.text = locationStr
        
        navigationController?.navigationBar.tintColor = UIColor.dynamicColor(light: .black, dark: .lightGray)
    }
    
}


extension TermsOfConditionsTableViewController: BEMCheckBoxDelegate {
    /// 처음 체크박스에 토글하면 모든 체크박스가 온오프 되는 메소드
    /// - Parameter checkBox: BEMCheckBox:
    func didTap(_ checkBox: BEMCheckBox) {
        if checkBox.on == true {
            [checkBox2, checkBox3, checkBox4, checkBox5, checkBox6].forEach{ $0?.on = true }
        } else {
            [checkBox2, checkBox3, checkBox4, checkBox5, checkBox6].forEach{ $0?.on = false }
        }
        
    }
    
}
