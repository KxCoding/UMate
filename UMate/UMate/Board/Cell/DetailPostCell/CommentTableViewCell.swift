//
//  CommentTableViewCell.swift
//  UMate
//
//  Created by 김정민 on 2021/08/04.
//

import UIKit


/// 댓글 및 대댓글을 표시하는 테이블뷰 셀
/// - Author: 김정민(kimjm010@icloud.com),  남정은(dlsl7080@gamil.com)
class CommentTableViewCell: UITableViewCell {
    /// 데이터 엔코더
    let encoder = JSONEncoder()
    
    /// 날짜 파싱 포매터
    let postDateFormatter: ISO8601DateFormatter = {
       let f = ISO8601DateFormatter()
        f.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
        return f
    }()
    
    /// 서버 요청 API
    lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config, delegate: self, delegateQueue: .main)
        return session
    }()
    
    /// 프로필 이미지뷰
    @IBOutlet weak var profileImageView: UIImageView!
    
    /// 사용자 아이디
    @IBOutlet weak var userIdLabel: UILabel!
    
    /// 댓글내용
    @IBOutlet weak var commentLabel: UILabel!
    
    /// 댓글의 날짜 및 시각
    @IBOutlet weak var dateTimeLabel: UILabel!
    
    /// 좋아요 수
    @IBOutlet weak var heartCountLabel: UILabel!
    
    /// 좋아요, 쪽지보내기 버튼을 포함한 컨테이버 뷰
    @IBOutlet weak var btnContainerView: UIView!
    
    /// 좋아요 이미지뷰
    @IBOutlet weak var heartImageView: UIImageView!
    
    /// 좋아요 버튼의 이미지뷰
    @IBOutlet weak var heartButtonImageView: UIImageView!
    
    /// 댓글 컨테이너 뷰
    /// 댓글, 대댓글에 따라 다른 background 색상을 표시합니다.
    @IBOutlet weak var commentContainerView: UIView!
    
    /// 댓글 separator뷰
    /// 각 댓글을 나누기 위한 뷰입니다.
    @IBOutlet weak var commentSeparationView: UIView!
    
    /// 대댓글 컨테이너뷰
    /// 대댓글을 포함한 컨테이너뷰입니다.
    @IBOutlet weak var reCommentContainerView: UIStackView!
    
    /// 선택된 댓글
    var selectedComment: CommentListResponseData.Comment?
    
    /// 댓글 좋아요 여부
    var isLiked = false
    
    
    /// 좋아요 버튼 처리 동작
    ///
    /// 좋아요 버튼을 클릭할 때 좋아요 개수와 이미지 뷰의 상태가 바뀝니다.
    /// - Parameter sender: 좋아요 Button
    /// - Author: 김정민(kimjm010@icloud.com),  남정은(dlsl7080@gamil.com)
    @IBAction func toggleLike(_ sender: Any) {
        guard let comment = selectedComment else { return }
        
        if !isLiked {
            heartImageView.image = UIImage(named: "heart2.fill")
            heartButtonImageView.image = UIImage(named: "heart2.fill")
            heartCountLabel.text = "\(comment.likeCnt + 1)"
            heartImageView.isHidden = false
            heartCountLabel.isHidden = false
            
            guard let url = URL(string: "https://localhost:51547/api/likeComment") else { return }
            
            let dateStr = postDateFormatter.string(from: Date())
            
            let likeCommentData = LikeCommentPostData(likeCommentId: 0, userId: "6c1c72d6-fa9b-4af6-8730-bb98fded0ad8", commentId: comment.commentId, createdAt: dateStr)
            
            let body = try? encoder.encode(likeCommentData)
            
            sendLikeCommentRequest(url: url, httpMethod: "POST", httpBody: body)
        }
    }
    
    
    /// 댓글 좋아요를 추가합니다.
    /// - Parameters:
    /// - Parameters:
    ///   - url: 요청할 url
    ///   - httpMethod: api 메소드
    ///   - httpBody: 댓글 좋아요 데이터
    /// - Author: 남정은(dlsl7080@gamil.com)
    private func sendLikeCommentRequest(url: URL, httpMethod: String, httpBody: Data?) {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.httpBody = httpBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        session.dataTask(with: request, completionHandler: { data, response, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let data = try decoder.decode(SaveLikeCommentResponseData.self, from: data)
                
                switch data.resultCode {
                case ResultCode.ok.rawValue:
                    #if DEBUG
                    print("추가 성공")
                    #endif
                case ResultCode.fail.rawValue:
                    #if DEBUG
                    print("이미 존재함")
                    #endif
                default:
                    break
                }
            } catch {
                print(error)
            }
        }).resume()
    }
    
    
    /// 셀이 로드되면 UI를 초기화합니다.
    /// - Author: 김정민(kimjm010@icloud.com)
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        
        btnContainerView.layer.cornerRadius = 14
        btnContainerView.layer.borderColor = UIColor.init(named: "lightGrayNonSelectedColor")?.cgColor
        btnContainerView.layer.borderWidth = 0.5
    }
    
    
    /// 게시글에 추가될 Comment셀을 초기화 합니다.
    /// - Parameters:
    ///   - comment: 댓글 정보
    ///   - isLiked: 사용자의 댓글 좋아요 여부
    ///   - Author: 김정민(kimjm010@icloud.com)
    func configure(comment: CommentListResponseData.Comment, isLiked: Bool) {
        
        heartImageView.isHidden = comment.likeCnt == 0
        heartCountLabel.isHidden = heartImageView.isHidden
        
        if !heartImageView.isHidden {
            heartImageView.image = isLiked ? UIImage(named: "heart2.fill") : UIImage(named: "heart2")
        }
        heartButtonImageView.image = isLiked ? UIImage(named: "heart2.fill") : UIImage(named: "heart2")
        
        reCommentContainerView.isHidden = !(comment.isReComment) ? true : false
        commentSeparationView.isHidden = !(comment.isReComment) ? false : true
        commentContainerView.backgroundColor = !(comment.isReComment) ? UIColor.systemBackground : UIColor.systemGray6
        commentContainerView.layer.cornerRadius = !(comment.isReComment) ? 0 : 10
        
        // 로그인 기능 추가후 프로필이미지 설정
        //profileImageView.image = comment.image
        userIdLabel.text = comment.userId
        commentLabel.text = comment.content
        dateTimeLabel.text = comment.createdAt
        heartCountLabel.text = comment.likeCnt.description
        
        selectedComment = comment
        self.isLiked = isLiked
    }
}



/// local에서 인증서 문제가 발생할 때 사용
///  - Author: 남정은(dlsl7080@gmail.com)
extension CommentTableViewCell: URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let trust = challenge.protectionSpace.serverTrust!
        
        completionHandler(.useCredential, URLCredential(trust: trust))
    }
}
