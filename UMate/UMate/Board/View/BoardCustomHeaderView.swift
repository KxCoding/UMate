//
//  BoardCustomHeaderView.swift
//  BoardCustomHeaderView
//
//  Created by 남정은 on 2021/07/27.
//

import UIKit


/// 게시판 목록 화면에 expandable board에 들어갈 header
class BoardCustomHeaderView: UITableViewHeaderFooterView {
    
    let headerBar = UIView()
    let title = UILabel()
    let summary = UILabel()
    let image = UIImageView()
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureContents() {
        
        headerBar.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        summary.translatesAutoresizingMaskIntoConstraints = false
        image.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(headerBar)
        contentView.addSubview(title)
        contentView.addSubview(summary)
        contentView.addSubview(image)
        
        NSLayoutConstraint.activate([
            
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            title.heightAnchor.constraint(equalToConstant: 30),
            title.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
            
            headerBar.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            headerBar.widthAnchor.constraint(equalToConstant: 3),
            
            summary.leadingAnchor.constraint(equalTo: title.trailingAnchor, constant: 10),
            summary.centerYAnchor.constraint(equalTo: title.centerYAnchor),
            
            image.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
            image.widthAnchor.constraint(equalToConstant: 15),
            image.heightAnchor.constraint(equalToConstant: 15)
        ])
    }
}
