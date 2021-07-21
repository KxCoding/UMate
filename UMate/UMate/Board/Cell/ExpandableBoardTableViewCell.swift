//
//  BoardListTableViewCell.swift
//  UMate
//
//  Created by 남정은 on 2021/07/16.
//

import UIKit



class ExpandableBoardTableViewCell: UITableViewCell {

    @IBOutlet weak var boardLabel: UILabel!
    
    @IBOutlet weak var bookmarkButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
   
        bookmarkButton.tintColor = .darkGray
    }

    func configure(boardList: [BoardUI], indexPath: IndexPath) {
        boardLabel.text = boardList[indexPath.section - 1].boardNames[indexPath.row]
        bookmarkButton.tag = indexPath.row + 100 * (indexPath.section + 1)
    }

}


