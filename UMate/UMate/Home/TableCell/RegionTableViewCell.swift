//
//  RegionTableViewCell.swift
//  UMate
//
//  Created by 황신택 on 2021/09/22.
//

import UIKit

class RegionTableViewCell: UITableViewCell {

    @IBOutlet weak var region1: UILabel!
    @IBOutlet weak var region2: UILabel!
    @IBOutlet weak var region3: UILabel!
    @IBOutlet weak var region4: UILabel!
    @IBOutlet weak var region5: UILabel!
    
    var regionData1: String?
    var regionData2: String?
    var regionData3: String?
    var regionData4: String?
    var regionData5: String?
    
    @IBAction func toggleRegionItem(_ sender: Any) {
        region1.isHighlighted.toggle()
        regionData1 = region1.text
        NotificationCenter.default.post(name: .selectedRegion, object: nil, userInfo: [UserInfoIdentifires.regionData: regionData1 ?? "전체"])
    }
    
    @IBAction func toggleRegionItem2(_ sender: Any) {
        region2.isHighlighted.toggle()
        regionData2 = region2.text
        NotificationCenter.default.post(name: .selectedRegion, object: nil, userInfo: [UserInfoIdentifires.regionData: regionData2 ?? "전체"])
    }
    
    @IBAction func toggleRegionItem3(_ sender: Any) {
        region3.isHighlighted.toggle()
        regionData3 = region3.text
        NotificationCenter.default.post(name: .selectedRegion, object: nil, userInfo: [UserInfoIdentifires.regionData: regionData3 ?? "전체"])
    }
    
    @IBAction func toggleRegionItem4(_ sender: Any) {
        region4.isHighlighted.toggle()
        regionData4 = region4.text
        NotificationCenter.default.post(name: .selectedRegion, object: nil, userInfo: [UserInfoIdentifires.regionData: regionData4 ?? "전체"])
    }
    
    @IBAction func toggleRegionItem5(_ sender: Any) {
        region5.isHighlighted.toggle()
        regionData5 = region5.text
        NotificationCenter.default.post(name: .selectedRegion, object: nil, userInfo: [UserInfoIdentifires.regionData: regionData5 ?? "전체"])
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        [region1, region2, region3, region4, region5].forEach({
            $0?.highlightedTextColor = .systemBlue
            $0?.textColor = .lightGray
            
        })
    }


}
