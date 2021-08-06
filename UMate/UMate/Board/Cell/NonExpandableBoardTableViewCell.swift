//
//  NonTitleTableViewCell.swift
//  UMate
//
//  Created by 남정은 on 2021/07/18.
//

import UIKit


class NonExpandableBoardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var boardLabel: UILabel!
    
    @IBOutlet weak var bookmarkButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bookmarkButton.tintColor = .lightGray
    }
    
    
    func configure(boardList: [BoardUI], indexPath: IndexPath) {
        boardLabel.text = boardList[indexPath.row].boardNames.first
        bookmarkButton.tag = indexPath.row + 100 * (indexPath.section + 1)
    }
}

