//
//  TestStrategyTableViewCell.swift
//  UMate
//
//  Created by 남정은 on 2021/08/30.
//

import UIKit

class TestStrategyTableViewCell: UITableViewCell {

    @IBOutlet weak var testStrategyTextView: UITextView!
    @IBOutlet weak var placeholderLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        testStrategyTextView.delegate = self
        
        testStrategyTextView.layer.cornerRadius = 5
    }
}




extension TestStrategyTableViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = textView.hasText
    }
}
