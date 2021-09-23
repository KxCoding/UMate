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
    
    @IBAction func toggleRegionItem(_ sender: Any) {
        region1.isHighlighted.toggle()
    }
    
    @IBAction func toggleRegionItem2(_ sender: Any) {
        region2.isHighlighted.toggle()
    }
    
    @IBAction func toggleRegionItem3(_ sender: Any) {
        region3.isHighlighted.toggle()
    }
    
    @IBAction func toggleRegionItem4(_ sender: Any) {
        region4.isHighlighted.toggle()
    }
    
    @IBAction func toggleRegionItem5(_ sender: Any) {
        region5.isHighlighted.toggle()
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        [region1, region2, region3, region4, region5].forEach({
            $0?.highlightedTextColor = .systemBlue
            $0?.textColor = .lightGray
            
        })
    }


}
