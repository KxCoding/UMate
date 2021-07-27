//
//  BoardDummy.swift
//  BoardDummy
//
//  Created by 남정은 on 2021/07/27.
//

import UIKit


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

let infoBoard = Board(boardTitle: "정보 게시판", posts: [Post(images: [UIImage(named: "info")], postTitle: "사회적 거리두기", postContent: "2단계 2020.09/14부터 9월 27일까지 2단계 시행", postWriter: "캔버스", insertDate: Date(timeIntervalSinceNow: -400), likeCount: 4, commentCount: 3)])

//나중에 cellType으로 넣는게 나으려나
var nonExpandableBoardList = [BoardUI(sectionName: nil, boardNames: ["스크랩"]),
                              BoardUI(sectionName: nil, boardNames: ["자유 게시판"]),
                              BoardUI(sectionName: nil, boardNames: ["인기글 게시판"]),
                              BoardUI(sectionName: nil, boardNames: ["졸업생 게시판"]),
                              BoardUI(sectionName: nil, boardNames: ["신입생 게시판"]),
                              BoardUI(sectionName: nil, boardNames: ["강의평가 게시판"]),]

var expandableBoardList = [BoardUI(sectionName: "홍보", isExpanded: true ,boardNames: ["홍보 게시판", "동아리, 학회"]),
                           BoardUI(sectionName: "정보", isExpanded: true ,boardNames: ["정보 게시판", "취업, 진로"]),]







let commentsInPost: [String: [Comment]] = ["abc123": [Comment(commentContent: "화이팅!!", commentWriter: "1004"),
                                                      Comment(commentContent: "바나나", commentWriter: "119"),
                                                      Comment(commentContent: "사과!!", commentWriter: "나무")]]
