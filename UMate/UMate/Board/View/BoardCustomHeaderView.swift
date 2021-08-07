//
//  BoardCustomHeaderView.swift
//  BoardCustomHeaderView
//
//  Created by 남정은 on 2021/07/27.
//

import UIKit

class BoardCustomHeaderView: UITableViewHeaderFooterView {
    
    let title = UILabel()
    let image = UIImageView()
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureContents() {
        image.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(title)
        contentView.addSubview(image)
        
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            title.heightAnchor.constraint(equalToConstant: 30),
            title.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
            
            image.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
            image.widthAnchor.constraint(equalToConstant: 30),
            image.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}
