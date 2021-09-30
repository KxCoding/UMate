//
//  Job.swift
//  UMate
//
//  Created by 황신택 on 2021/09/26.
//

import Foundation
import UIKit

/// Json형식 companies 데이타를 파싱하기위해 Codable을 채용함
/// EmploymentController에 데이타 모델로서 사용됩니다.
/// Author: 황신택
struct JobData: Codable {
    struct Job: Codable {
        /// 데이타 아이디
        let id: Int
        
        /// 경력
        let career: String
        
        /// 학위
        let degree: String
        
        /// 지역
        let region: String
        
        /// 분야
        let field: String
        
        /// 회사이름
        let title: String
        
        /// 모집내용
        let detail: String
        
        /// 이미지 Url
        let url: String
        
        /// 관련 사이트
        let website: String
    }
    
    /// 제이슨 형식이 배열이라 배열로 선언
    let jobs: [Job]
}

