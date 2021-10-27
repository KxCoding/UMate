//
//  Dummy.swift
//  Dummy
//
//  Created by 안상희 on 2021/08/06.
//

import Elliotable
import Foundation
import UIKit


// MARK: Board Dummy
var scrapBoard = Board(boardTitle: "스크랩", posts: [])

let freeBoard = Board(boardTitle: "자유 게시판",
                      posts: [Post(images: [UIImage(named:"image1"), UIImage(named:"image2")],
                                   postTitle: "아자아자",
                                   postContent: "5개월동안 열심히하자!",
                                   postWriter: "정은",
                                   insertDate: Date(timeIntervalSinceNow: -3000),
                                   likeCount: 3,
                                   commentCount: 12),
                              Post(images: [UIImage(named:"image2")],
                                   postTitle: "to catch this in the",
                                   postContent: "5UIConstraintBasedLayoutDebugging!",
                                   postWriter: "category",
                                   insertDate: Date(timeIntervalSinceNow: -200),
                                   likeCount: 3,
                                   commentCount: 13),
                              Post(images: [],
                                   postTitle: "Lorem ipsum dolor sit ame",
                                   postContent: " consectetur adipiscing elit,labore et dolore magna aliqua. Ut enim ad minim anim id est laborum.",
                                   postWriter: "category",
                                   insertDate: Date(timeIntervalSinceNow: -388),
                                   likeCount: 3,
                                   commentCount: 32)
                      ])
let popularPostBoard = Board(boardTitle: "인기글 게시판",
                             posts: [Post(images: [UIImage(named:"image3")],
                                          postTitle: "아자아자",
                                          postContent: "5개월동안 열심히하자!",
                                          postWriter: "정은",
                                          insertDate: Date(),
                                          likeCount: 3,
                                          commentCount: 12),
                                     Post(images: [],
                                          postTitle: "Lorem ipsum dolor sit ame",
                                          postContent: " consectetur adipiscing elit,labore et dolore magna aliqua. Ut enim ad minim anim id est laborum.",
                                          postWriter: "category",
                                          insertDate: Date(timeIntervalSinceNow: -388),
                                          likeCount: 3,
                                          commentCount: 32),
                                     Post(images: [UIImage(named:"image4")],
                                          postTitle: "to catch this in the",
                                          postContent: "5UIConstraintBasedLayoutDebugging!",
                                          postWriter: "category",
                                          insertDate: Date(),
                                          likeCount: 3,
                                          commentCount: 13),
                             ])
let graduateBoard = Board(boardTitle: "졸업생 게시판",
                          posts: [Post(images: [UIImage(named:"image5")],
                                       postTitle: "아자아자",
                                       postContent: "5개월동안 열심히하자!",
                                       postWriter: "정은",
                                       insertDate: Date(),
                                       likeCount: 3,
                                       commentCount: 12),
                                  Post(images: [UIImage(named:"image6")],
                                       postTitle: "Lorem ipsum dolor sit ame",
                                       postContent: " consectetur adipiscing elit,labore et dolore magna aliqua. Ut enim ad minim anim id est laborum.",
                                       postWriter: "category",
                                       insertDate: Date(),
                                       likeCount: 3,
                                       commentCount: 32),
                          ])
let freshmanBoard =  Board(boardTitle: "신입생 게시판",
                           posts: [Post(images: [UIImage(named:"image7")],
                                        postTitle: "Lorem ipsum dolor sit ame",
                                        postContent: " consectetur adipiscing elit,labore et dolore magna aliqua. Ut enim ad minim anim id est laborum.",
                                        postWriter: "category",
                                        insertDate: Date(),
                                        likeCount: 3,
                                        commentCount: 32),
                                   Post(images: [UIImage(named:"image8")],
                                        postTitle: "H. Rackham",
                                        postContent: "s mistaken idea of denouncing pleasure and praising pain was born and I will giv!",
                                        postWriter: "category",
                                        insertDate: Date(),
                                        likeCount: 3,
                                        commentCount: 18),
                           ])

let infoBoard = Board(boardTitle: "정보 게시판", posts: [Post(images: [], postTitle: "사회적 거리두기", postContent: "2단계 2020.09/14부터 9월 27일까지 2단계 시행", postWriter: "캔버스", insertDate: Date(), likeCount: 4, commentCount: 3)])


let publicityBoard = Board(boardTitle: "홍보게시판",
                           posts: [Post(images: [], postTitle: "알바", postContent: "과외", postWriter: "학생", insertDate: Date(), likeCount: 1, commentCount: 1, scrapCount: 1, categoryRawValue: 2002),
                                   Post(images: [], postTitle: "기타", postContent: "과외", postWriter: "학생", insertDate: Date(), likeCount: 1, commentCount: 1, scrapCount: 1, categoryRawValue: 2003),
                                   Post(images: [], postTitle: "강연", postContent: "과외", postWriter: "학생", insertDate: Date(), likeCount: 1, commentCount: 1, scrapCount: 1, categoryRawValue: 2001)],
                           categoryNumbers:  Post.Category.Publicity.allCases.map{ $0.rawValue }, categoryNames: Post.Category.Publicity.allCases.map{ $0.description })

let clubBoard = Board(boardTitle: "동아리, 학회",
                      posts: [Post(images: [], postTitle: "교내", postContent: "교내", postWriter: "학생", insertDate: Date(), likeCount: 1, commentCount: 1, scrapCount: 1, categoryRawValue: 2011),
                              Post(images: [], postTitle: "연합", postContent: "연합", postWriter: "학생", insertDate: Date(), likeCount: 1, commentCount: 1, scrapCount: 1, categoryRawValue: 2012),
                              Post(images: [], postTitle: "학회", postContent: "전체", postWriter: "학생", insertDate: Date(), likeCount: 1, commentCount: 1, scrapCount: 1, categoryRawValue: 2011)],
                      categoryNumbers: Post.Category.Club.allCases.map{ $0.rawValue }, categoryNames: Post.Category.Club.allCases.map{ $0.description })

let careerBoard = Board(boardTitle: "취업, 진로",
                        posts: [Post(images: [], postTitle: "진로", postContent: "전체", postWriter: "학생", insertDate: Date(), likeCount: 1, commentCount: 1, scrapCount: 1, categoryRawValue: 3011),
                                Post(images: [], postTitle: "질문", postContent: "질문", postWriter: "학생", insertDate: Date(), likeCount: 1, commentCount: 1, scrapCount: 1, categoryRawValue: 3011),
                                Post(images: [], postTitle: "후기", postContent: "후기", postWriter: "학생", insertDate: Date(), likeCount: 1, commentCount: 1, scrapCount: 1, categoryRawValue: 3012)],
                        categoryNumbers: Post.Category.Career.allCases.map{ $0.rawValue }, categoryNames: Post.Category.Career.allCases.map{ $0.description })


var boardDict: [Int: Board] = [200: scrapBoard, 201: freeBoard, 202: popularPostBoard, 203: graduateBoard, 204: freshmanBoard, 300: publicityBoard, 301: clubBoard, 400: infoBoard, 401: careerBoard]


//나중에 cellType으로 넣는게 나으려나
var nonExpandableBoardList = [BoardUI(sectionName: nil, boardNames: ["스크랩"]),
                              BoardUI(sectionName: nil, boardNames: ["자유 게시판"]),
                              BoardUI(sectionName: nil, boardNames: ["인기글 게시판"]),
                              BoardUI(sectionName: nil, boardNames: ["졸업생 게시판"]),
                              BoardUI(sectionName: nil, boardNames: ["신입생 게시판"]),
                              BoardUI(sectionName: nil, boardNames: ["강의평가 게시판"]),]

var expandableBoardList = [BoardUI(sectionName: "홍보", isExpanded: true ,boardNames: ["홍보 게시판", "동아리∙학회"]),
                           BoardUI(sectionName: "정보", isExpanded: true ,boardNames: ["정보 게시판", "취업∙진로"]),]

/// 댓글, 대댓글 더미 데이터
var dummyCommentList: [Comment] = [
    Comment(image: UIImage(named: "3"), writer: "익명1", content: "댓글1", insertDate: Date(timeIntervalSinceNow: -2000), heartCount: 0, commentId: 1, originalCommentId: 1, isReComment: false, postId: "", isliked: false),
    Comment(image: UIImage(named: "3"), writer: "익명2", content: "댓글2", insertDate: Date(timeIntervalSinceNow: -1700), heartCount: 1, commentId: 2, originalCommentId: 2, isReComment: false, postId: "", isliked: false),
    Comment(image: UIImage(named: "3"), writer: "익명3", content: "댓글3", insertDate: Date(timeIntervalSinceNow: -1500), heartCount: 2, commentId: 3, originalCommentId: 3, isReComment: false, postId: "", isliked: false),
    Comment(image: UIImage(named: "3"), writer: "익명4", content: "댓글4", insertDate: Date(timeIntervalSinceNow: -1200), heartCount: 3, commentId: 4, originalCommentId: 4, isReComment: false, postId: "", isliked: false),
    Comment(image: UIImage(named: "3"), writer: "익명5", content: "댓글5", insertDate: Date(timeIntervalSinceNow: -1000), heartCount: 4, commentId: 5, originalCommentId: 5, isReComment: false, postId: "", isliked: false),
    Comment(image: UIImage(named: "3"), writer: "익명6", content: "대댓글1", insertDate: Date(timeIntervalSinceNow: -800), heartCount: 5, commentId: 6, originalCommentId: 1, isReComment: true, postId: "", isliked: false)
]





// MARK: - Place Dummy

/// placeholder 이미지
let placeholderImage = UIImage(named: "dummy-image-landscape")

/// dummy URL
let tempUrl = URL(string: "https://kxcoding.com")!



// MARK: - TimeTable Dummy
/// 강의 정보를 담은 Dummy Data 리스트
/// - Author: 안상희
let friendCourseList: [ElliottEvent] =
[ElliottEvent(courseId: "F1234",
              courseName: "자료구조",
              roomName: "팔308",
              professor: "교수님",
              courseDay: .monday,
              startTime: "09:00",
              endTime: "10:15",
              textColor: UIColor.white,
              backgroundColor: .purple),
 ElliottEvent(courseId: "F1234",
              courseName: "자료구조",
              roomName: "팔308",
              professor: "교수님",
              courseDay: .wednesday,
              startTime: "09:00",
              endTime: "10:15",
              textColor: UIColor.white,
              backgroundColor: .purple),
 ElliottEvent(courseId: "F5678",
              courseName: "컴퓨터그래픽스",
              roomName: "팔1025",
              professor: "교수님",
              courseDay: .monday,
              startTime: "10:30",
              endTime: "11:45",
              textColor: UIColor.white,
              backgroundColor: .cyan),
 ElliottEvent(courseId: "F5678",
              courseName: "컴퓨터그래픽스",
              roomName: "팔1025",
              professor: "교수님",
              courseDay: .thursday,
              startTime: "10:30",
              endTime: "11:45",
              textColor: UIColor.white,
              backgroundColor: .cyan)]
