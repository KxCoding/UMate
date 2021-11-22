//
//  CommentTableViewCell.swift
//  UMate
//
//  Created by 김정민 on 2021/08/04.
//

import UIKit
import NSObject_Rx


/// 댓글 및 대댓글을 표시하는 테이블뷰 셀
/// - Author: 김정민(kimjm010@icloud.com),  남정은(dlsl7080@gmail.com)
class CommentTableViewCell: UITableViewCell {
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
    
    /// 좋아요 버튼
    @IBOutlet weak var heartButton: UIButton!
    
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
    
    /// 네트워크 요청 관리 객체
    let provider = CommentDataService.shared.provider
    
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
            
            
            let dateStr = BoardDataManager.shared.postDateFormatter.string(from: Date())
            let likeCommentData = LikeCommentPostData(likeCommentId: 0, userId: LoginDataManager.shared.loginKeychain.get(AccountKeys.userId.rawValue) ?? "", commentId: comment.commentId, createdAt: dateStr)
            
            sendCommentLikeDataToServer(likeCommentPostData: likeCommentData)
        } else {
            heartImageView.image = UIImage(named: "heart2")
            heartButtonImageView.image = UIImage(named: "heart2")
            
            if comment.likeCnt == 1 {
                heartCountLabel.isHidden = true
                heartImageView.isHidden = true
            }
            
            BoardDataManager.shared.deleteLikeComment(likeCommentId: heartButton.tag) { [weak self] success in
                guard let self = self else { return }
                if success {
                    self.isLiked = false
                    
                    DispatchQueue.main.async {
                        self.heartCountLabel.text = "\(comment.likeCnt - 1)"
                        self.selectedComment?.likeCnt -= 1
                    }
                } else {
                    #if DEBUG
                    print("댓글 좋아요 삭제 실패")
                    #endif
                }
            }
        }
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
    func configure(comment: CommentListResponseData.Comment, isLiked: Bool, likedComment: LikeCommentListResponse.LikeComment?) {
        heartButton.tag = likedComment?.likeCommentId ?? 0
        
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
        
        if let urlStr = comment.profileUrl {
            BoardDataManager.shared.downloadImage(from: urlStr) { [weak self] image in
                guard let self = self else { return }
                if let image = image {
                    self.profileImageView.image = BoardDataManager.shared.resizeImage(image: image, targetSize: CGSize(width: 30, height: 30))
                }
            }
        } else {
            self.profileImageView.image = UIImage(named: "user")
        }
      
        userIdLabel.text = comment.userName
        commentLabel.text = comment.content
        dateTimeLabel.text = comment.createdAt
        heartCountLabel.text = comment.likeCnt.description
        
        selectedComment = comment
        self.isLiked = isLiked
    }
    
    
    /// 댓글 좋아요를 추가합니다.
    /// - Parameter likeCommentPostData: 댓글 좋아요 정보 객체
    /// - Author: 남정은(dlsl7080@gmail.com), 김정민(kimjm010@icloud.com)
    func sendCommentLikeDataToServer(likeCommentPostData: LikeCommentPostData) {
        provider.rx.request(.saveCommentLikeData(likeCommentPostData))
            .filterSuccessfulStatusCodes()
            .map(SaveLikeCommentResponseData.self)
            .subscribe { (result) in
                switch result {
                case .success(let response):
                    switch response.resultCode {
                    case ResultCode.ok.rawValue:
                        #if DEBUG
                        print("추가 성공")
                        #endif
                        self.isLiked = true
                        guard let likeComment = response.likeComment else { return }
                        
                        DispatchQueue.main.async {
                            self.heartButton.tag = likeComment.likeCommentId
                        }
                    case ResultCode.fail.rawValue:
                        #if DEBUG
                        print("이미 존재함")
                        #endif
                        
                        #if DEBUG
                        print("댓글 좋아요 추가 실패")
                        #endif
                    default:
                        break
                    }
                case .failure(let error):
                    #if DEBUG
                    print(error.localizedDescription)
                    #endif
                }
            }
    }
}




