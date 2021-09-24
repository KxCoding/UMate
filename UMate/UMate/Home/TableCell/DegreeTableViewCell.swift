//
//  RangeTableViewCell.swift
//  UMate
//
//  Created by 황신택 on 2021/09/23.
//

import UIKit

class DegreeTableViewCell: UITableViewCell {

    @IBOutlet weak var degreeSegment: UISegmentedControl!
    var segmentTitle: String?
    
    @IBAction func toggleSegmentItem(_ sender: Any) {
        segmentTitle = degreeSegment.titleForSegment(at: degreeSegment.selectedSegmentIndex)
        
        NotificationCenter.default.post(name: .selectedDegree, object: nil, userInfo: [UserInfoIdentifires.degreeData: segmentTitle ?? "무관"])
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}
