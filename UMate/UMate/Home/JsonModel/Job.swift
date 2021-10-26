//
//  Job.swift
//  UMate
//
//  Created by 황신택 on 2021/10/05.
//

import Foundation

/// 제이슨 형식 companies 데이터를 파싱하기위해 Codable을 채용했습니다.
/// EmploymentController에서 모델로 사용합니다.
/// - Author: 황신택 (sinadsl1457@gmail.com)
struct JobData: Codable {
    struct Job: Codable {
        /// 데이터 아이디
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
    /// 제이슨 배열 형식
    let jobs: [Job]
}

