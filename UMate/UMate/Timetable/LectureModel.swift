//
//  LectureModel.swift
//  LectureModel
//
//  Created by 안상희 on 2021/07/28.
//

import Foundation
import Elliotable

class Lecture {
    static let shared = Lecture()

    private init() {
        
    }
    
    var courseList = [ElliottEvent]()
}
