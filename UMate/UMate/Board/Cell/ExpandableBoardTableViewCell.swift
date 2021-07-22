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
    
    var board: BoardViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
   
        bookmarkButton.tintColor = .darkGray
    }

    func configure(boardList: [BoardUI], indexPath: IndexPath) {
        boardLabel.text = boardList[indexPath.section - 1].boardNames[indexPath.row]
        bookmarkButton.tag = indexPath.row + 100 * (indexPath.section + 1)
        
        //cellforRowAt에서 cell을 재사용 하기 때문에 매번 버튼 색을 업데이트 해주어야 함.
        if board?.bookmarks[bookmarkButton.tag] == true {
            bookmarkButton.tintColor = .systemBlue
        } else {
            bookmarkButton.tintColor = .darkGray
        }
    }

}


