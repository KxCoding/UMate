//
//  BoardListTableViewCell.swift
//  UMate
//
//  Created by 남정은 on 2021/07/16.
//

import UIKit

class TitleTableViewCell: UITableViewCell {

    var link: BoardViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let starButton = UIButton(type: .system)
        starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        starButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        
        starButton.tintColor = .gray
        starButton.addTarget(self, action: #selector(handleMarkAsBookmark), for: .touchUpInside)
        
        accessoryView = starButton
    }

    
    @objc private func handleMarkAsBookmark() {
        link?.changeTitleBookmarkColor(cell: self)
    }
    
}


