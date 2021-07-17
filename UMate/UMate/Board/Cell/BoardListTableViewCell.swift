//
//  BoardListTableViewCell.swift
//  UMate
//
//  Created by 남정은 on 2021/07/16.
//

import UIKit

class BoardListTableViewCell: UITableViewCell {

    @IBOutlet weak var bookmarkImageView: UIImageView!
    @IBOutlet weak var boardName: UILabel!
    
    @IBAction func checkBookmark(_ sender: Any) {
        if bookmarkImageView.isHighlighted == false {
            bookmarkImageView.isHighlighted = true
            
        } else {
            bookmarkImageView.isHighlighted = false
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        

    }
    
}


