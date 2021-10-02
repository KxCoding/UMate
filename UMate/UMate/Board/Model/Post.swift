//
//  Post.swift
//  Post
//
//  Created by 남정은 on 2021/07/21.
//

import UIKit


/// 게시글 모델 클래스
/// - Author: 남정은(dlsl7080@gmail.com)
class Post {
    /// 카테고리 구조체
    ///
    /// 여기서 all은 카테고리를 선택하지 않을 경우를 나타냅니다.
    /// 카테고리 게시판은 무조건 글 작성 시에 카테고리를 선택하도록 되어있습니다.
    struct Category {
        /// 홍보게시판에 들어갈 카테고리
        enum Publicity: Int {
            case all = 2000
            case lectureAndEvent = 2001
            case partTimeJob = 2002
            case etcetera = 2003
        }
        
        /// 동아리•학회 게시판에 들어갈 카테고리
        enum Club: Int {
            case all = 2010
            case inside = 2011
            case union = 2012
        }
        
        /// 취업•진로 게시판에 들어갈 카테고리
        enum Career: Int {
            case all = 3010
            case QNA = 3011
            case review = 3012
        }
    }
    
    /// 게시글에 들어갈 이미지를 담는 배열
    let images: [UIImage?]
    
    /// 게시글 제목
    let postTitle: String
    
    /// 게시글 내용
    let postContent: String
    
    /// 게시글 작성자
    let postWriter: String
    
    /// 작성일
    let insertDate: Date
    
    /// 좋아요 수
    var likeCount: Int = 0
    
    /// 댓글 수
    let commentCount: Int
    
    /// 스크랩 수
    var scrapCount: Int = 0
    
    /// 게시글이 어느 카테고리에 속하는지 나타내는 값
    let categoryRawValue: Int?
    
    /// 스크랩여부
    var isScrapped = false
    
    /// 좋아요여부
    var isliked = false
    
    
    init(images: [UIImage?], postTitle: String, postContent: String, postWriter: String, insertDate: Date, likeCount: Int = 0, commentCount: Int, scrapCount: Int = 0, categoryRawValue: Int = -1) {
        self.images = images
        self.postTitle = postTitle
        self.postContent = postContent
        self.postWriter = postWriter
        self.insertDate = insertDate
        self.likeCount = likeCount
        self.commentCount = commentCount
        self.scrapCount = scrapCount
        self.categoryRawValue = categoryRawValue
    }
}



/// 더미데이터를 만들 때 allCases활용
/// - Author: 남정은(dlsl7080@gmail.com)
extension Post.Category.Publicity: CaseIterable { }
extension Post.Category.Club: CaseIterable { }
extension Post.Category.Career: CaseIterable { }



/// 카테고리명에 접근하기 위해 사용
/// - Author: 남정은(dlsl7080@gmail.com)
extension Post.Category.Publicity: CustomStringConvertible {
    public var description: String {
        switch self {
        case .all:
            return "전체"
        case .lectureAndEvent:
            return "강연∙행사"
        case .partTimeJob:
            return "알바∙과외"
        case .etcetera:
            return "기타"
        }
    }
}



/// 카테고리명에 접근하기 위해 사용
/// - Author: 남정은(dlsl7080@gmail.com)
extension Post.Category.Club: CustomStringConvertible {
    public var description: String {
        switch self {
        case .all:
            return "전체"
        case .inside:
            return "교내"
        case .union:
            return "연합"
        }
    }
}



/// 카테고리명에 접근하기 위해 사용
/// - Author: 남정은(dlsl7080@gmail.com)
extension Post.Category.Career: CustomStringConvertible {
    public var description: String {
        switch self {
        case .all:
            return "전체"
        case .QNA:
            return "질문"
        case .review:
            return "후기"
        }
    }
}


class SocialFeedModel {
    var id = ""
    var title = ""
}

class SocialDataModel {
    static let shareInstance = SocialDataModel()
    var arrSocialFeed = [SocialDataModel]()
}


class CommentDataModel {
    static let shareInstance = CommentDataModel()
    var arrComment = [Comment]()
}

struct Comment {
    let image: UIImage?
    let writer: String
    let content: String
    let insertDate: Date
    var heartCount: Int
    var commentId: Int
    var originalCommentId: Int
    var isReComment: Bool
    var postId: String
    var isliked = false
}


