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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkbox1.delegate = self
        [checkBox2, checkBox3, checkBox4, checkBox5, checkBox6].forEach({ $0?.animationDuration = 0.3 })

        [serviceTOCTextView, personalInformationTOCTextView, communityTOCTextView, advertisementTOCTextView, minimumAge, verifyEmailButton].forEach({
            $0?.layer.cornerRadius = 10
            
            
        })
    }

    

}


extension TermsOfConditionsTableViewController: BEMCheckBoxDelegate {
    func didTap(_ checkBox: BEMCheckBox) {
        if checkBox.on == true {
            checkBox2.on = true
            checkBox3.on = true
            checkBox4.on = true
            checkBox5.on = true
            checkBox6.on = true
        } else {
            checkBox2.on = false
            checkBox3.on = false
            checkBox4.on = false
            checkBox5.on = false
            checkBox6.on = false
        }
        
    }
}
