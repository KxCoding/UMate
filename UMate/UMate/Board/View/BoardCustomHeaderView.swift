//
//  BoardCustomHeaderView.swift
//  BoardCustomHeaderView
//
//  Created by 남정은 on 2021/07/27.
//

import UIKit


/// 게시판 목록 화면에 expandable board에 들어갈 헤더
/// - Author: 남정은
class BoardCustomHeaderView: UITableViewHeaderFooterView {
    /// 섹션이름을 나타낼 레이블
    let title = UILabel()
    
    /// 섹션이 접혔을 때 게시판 이름을 나타낼 레이블
    let summary = UILabel()
    
    /// 우측에 넣을 화살표를 나타낼 이미지 뷰
    let image = UIImageView()
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureContents() {
        /// 코드로 제약을 조정하기 위한 속성
        title.translatesAutoresizingMaskIntoConstraints = false
        summary.translatesAutoresizingMaskIntoConstraints = false
        image.translatesAutoresizingMaskIntoConstraints = false
        
        /// 헤더를 만들기 위해 필요한 뷰 추가
        contentView.addSubview(title)
        contentView.addSubview(summary)
        contentView.addSubview(image)
        
        /// 제약 설정
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            title.heightAnchor.constraint(equalToConstant: 30),
            title.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
            
            summary.leadingAnchor.constraint(equalTo: title.trailingAnchor, constant: 10),
            summary.centerYAnchor.constraint(equalTo: title.centerYAnchor),
            
            image.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -38),
            image.widthAnchor.constraint(equalToConstant: 15),
            image.heightAnchor.constraint(equalToConstant: 15)
        ])
    }
}
