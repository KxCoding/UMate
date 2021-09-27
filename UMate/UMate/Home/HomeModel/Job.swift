//
//  Job.swift
//  UMate
//
//  Created by 황신택 on 2021/09/26.
//

import Foundation

struct JobData: Codable {
    struct Job: Codable {
        let id: Int
        let career: String
        let degree: Int
        let region: String
        let field: String
        let title: String
        let detail: String
        let image: String
        let website: String
    }
    
    let jobs: [Job]
}

