//
//  BoardNames.swift
//  UMate
//
//  Created by 남정은 on 2021/07/18.
//

import UIKit


struct BoadNames {
    internal init(title: String? = nil , isExpanded: Bool, names: [Contact]) {
        self.title = title
        self.isExpanded = isExpanded
        self.names = names
    }
    
    let title: String?
    var isExpanded: Bool
    var names: [Contact]
}

struct Contact {
    let name: String
    var isBookmarked: Bool
}
