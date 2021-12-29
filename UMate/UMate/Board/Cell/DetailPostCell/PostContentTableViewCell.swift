//
//  PostContentTableViewCell.swift
//  PostContentTableViewCell
//
//  Created by 남정은 on 2021/07/27.
//

import UIKit
import RxSwift
import Moya


/// 스크랩과 '좋아요'에대한 노티피케이션
/// - Author: 남정은(dlsl7080@gmail.com)
extension  Notification.Name {
    static let postDidScrap = Notification.Name("postDidScrap")
    static let postDidLike = Notification.Name("postDidLike")

    static let postCancelScrap = Notification.Name("postCancelScrap")
    static let postAlreadyLiked = Notification.Name("postAlreadyLiked")
    
    static let menuSheetDidAlert = Notification.Name("menuSheetDidAlert")
}



/// 게시글 작성자, 제목, 내용에 관한 테이블 뷰 셀
/// - Author: 남정은(dlsl7080@gmail.com), 김정민(kimjm010@icloud.com)
class PostContentTableViewCell: UITableViewCell {
    /// 작성자 프로필 이미지 뷰
    @IBOutlet weak var userImageView: UIImageView!
    
    /// 작성자 이름 레이블
    @IBOutlet weak var userNameLabel: UILabel!
    
    /// 작성일 레이블
    @IBOutlet weak var dateLabel: UILabel!
    
    /// 게시글 제목 레이블
    @IBOutlet weak var postTitleLabel: UILabel!
    
    /// 게시글 내용 레이블
    @IBOutlet weak var postContentLabel: UILabel!
    
    /// 선택된 게시글
    var selectedPost: PostDtoResponseData.Post?
    
    /// ViewController의 Extension을 사용하기 위한 속성
    let vc = UIViewController()
    
    /// 선택된 게시글 Id
    var postId = -1
    
    /// 게시글 좋아요 여부
    var isLiked = false
    
    /// 게시글 스크랩 여부
    var isScrapped = false

    
    // MARK: 공감 버튼
    /// 하트 이미지 뷰
    @IBOutlet weak var likeImageView: UIImageView!
    
    /// 하트 버튼
    @IBOutlet weak var likeButton: UIButton!
    
    
    /// 하트 버튼을 눌렀을 때 하트 이미지의 색상이 변경됩니다.
    /// - Parameter sender: 하트 버튼
    /// - Author: 남정은(dlsl7080@gmail.com)
    private func toggleLikeButton(_ sender: UIButton) {
        
        if isLiked {
            NotificationCenter.default.post(name: .postAlreadyLiked, object: nil)
        } else {
            likeImageView.image = UIImage(named: "heart2.fill")
            likeImageView.tintColor = UIColor.init(named: "blackSelectedColor")
            
            let likePostdata = LikePostData(postId: postId, createdAt: BoardDataManager.shared.postDateFormatter.string(from: Date()))
            
            sendLikeInfoData(likePostData: likePostdata)
            NotificationCenter.default.post(name: .postDidLike, object: nil, userInfo: ["postId": postId])
        }
        isLiked = true
    }
    
    
    // MARK: 스크랩 버튼
    /// 스크랩 이미지 뷰
    @IBOutlet weak var scrapImageView: UIImageView!
    @IBOutlet weak var scrapButton: UIButton!
    
    
    /// 스크랩 버튼을 눌렀을 때 스크랩 이미지 색상이 변경됩니다.
    /// - Parameter sender: 스크랩 버튼
    /// - Author: 남정은(dlsl7080@gmail.com)
    @IBAction func toggleScrapButton(_ sender: UIButton) {
        let scrapPostId = sender.tag
    
        if isScrapped {
            isScrapped = false
            scrapImageView.image = UIImage(named: "bookmark64")
            scrapImageView.tintColor = UIColor.init(named: "darkGraySubtitleColor")
            scrapImageView.alpha = 0.9
            
            deleteScrapPost(scrapPostId: scrapPostId)
            NotificationCenter.default.post(name: .postCancelScrap, object: nil, userInfo: ["postId": postId])
            
        } else {
            isScrapped = true
            scrapImageView.image = UIImage(named: "bookmark64.fill")
            scrapImageView.tintColor = UIColor.init(named: "blackSelectedColor")
            scrapImageView.alpha = 1
            
            let scrapPostData = ScrapPostData(postId: postId, createdAt: BoardDataManager.shared.postDateFormatter.string(from: Date()))
            
            sendScrapInfoData(scrapPostData: scrapPostData)
            NotificationCenter.default.post(name: .postDidScrap, object: nil, userInfo: ["postId": postId])
        }
    }
    
    
    /// 신고 혹은 게시글 수정, 삭제를 actionSheet로 나타냅니다.
    /// - Parameter sender: 햄버거 버튼
    /// - Author: 남정은(dlsl7080@gmail.com)
    @IBAction func showMenu(_ sender: Any) {
        NotificationCenter.default.post(name: .menuSheetDidAlert, object: nil)
    }
    
    
    /// 게시물 '스크랩' 정보를 서버에 저장합니다.
    /// - Parameter likePostData: 게시물 스크랩 정보 객체
    ///   - Author: 남정은(dlsl7080@gmail.com), 김정민(kimjm010@icloud.com)
    private func sendScrapInfoData(scrapPostData: ScrapPostData) {
        BoardDataManager.shared.provider.rx.request(.saveScrapInfo(scrapPostData))
            .filterSuccessfulStatusCodes()
            .map(SaveScrapPostPostResponse.self)
            .observe(on: MainScheduler.instance)
            .subscribe { (result) in
                switch result {
                case .success(let response):
                    switch response.code {
                    case ResultCode.ok.rawValue:
                        self.scrapButton.tag = response.scrapPost?.scrapPostId ?? 0
                    case ResultCode.fail.rawValue:
                        self.vc.alertVersion3(title: "알림", message: "이미 존재합니다.", handler: nil)
                    default:
                        break
                    }
                case .failure(let error):
                    self.vc.alertVersion3(title: "알림", message: error.localizedDescription, handler: nil)
                }
            }
            .disposed(by: rx.disposeBag)
    }
    
    
    /// 게시물 '공감' 정보를 서버에 저장합니다.
    /// - Parameter likePostData: 게시물 공감 정보 객체
    ///   - Author: 남정은(dlsl7080@gmail.com), 김정민(kimjm010@icloud.com)
    private func sendLikeInfoData(likePostData: LikePostData) {
        BoardDataManager.shared.provider.rx.request(.saveLikeInfo(likePostData))
            .filterSuccessfulStatusCodes()
            .map(SaveScrapPostPostResponse.self)
            .observe(on: MainScheduler.instance)
            .subscribe { (result) in
                switch result {
                case .success(let response):
                    switch response.code {
                    case ResultCode.ok.rawValue:
                        self.scrapButton.tag = response.scrapPost?.scrapPostId ?? 0
                    case ResultCode.fail.rawValue:
                        self.vc.alertVersion3(title: "알림", message: "이미 존재합니다.", handler: nil)
                    default:
                        break
                    }
                case .failure(let error):
                    self.vc.alertVersion3(title: "알림", message: error.localizedDescription, handler: nil)
                }
            }
            .disposed(by: rx.disposeBag)
    }
    
    
    /// 게시물 스크랩을 취소합니다.
    /// - Parameter scrapPostId: 스크랩 Id
    /// - Author: 남정은(dlsl7080@gmail.com)
    private func deleteScrapPost(scrapPostId: Int) {
        BoardDataManager.shared.provider.rx.request(.deleteScrapPost(scrapPostId))
            .filterSuccessfulStatusCodes()
            .map(CommonResponse.self)
            .subscribe(onSuccess: {
                if $0.code == ResultCode.ok.rawValue {
                    self.vc.alertVersion3(title: "알림", message: "게시물 스크랩을 취소했습니다.", handler: nil)
                } else {
                    self.vc.alertVersion3(title: "알림", message: "이미 스크랩을 취소한 게시물 입니다..", handler: nil)
                }
            })
            .disposed(by: rx.disposeBag)
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        likeButton.rx.tap
            .throttle(.milliseconds(1000), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: {
                $0.0.toggleLikeButton($0.0.likeButton)
            })
            .disposed(by: rx.disposeBag)
        
        // 사용자 이미지 모서리 깎기
        userImageView.layer.cornerRadius = userImageView.frame.height / 2
    }
    
  
    /// 작성자, 제목, 내용을 나타내는 셀을 초기화합니다.
    /// - Parameters:
    ///   - post: 선택된 post
    ///   - isLiked: 사용자의 게시물 좋아요 여부
    ///   - isScrapped: 사용자의 게시물 스크랩 여부
    ///   - scrapPostId: 스크랩 Id, 사용자가 스크랩하지 않은 경우는 0이 전달됩니다.
    /// - Author: 남정은(dlsl7080@gmail.com)
    func configure(post: PostDtoResponseData.Post, isLiked: Bool, isScrapped: Bool, scrapPostId: Int) {
    
        if isScrapped {
            scrapImageView.image = UIImage(named: "bookmark64.fill")
            scrapImageView.tintColor = UIColor.init(named: "blackSelectedColor")
            scrapImageView.alpha = 1
        } else {
            scrapImageView.image = UIImage(named: "bookmark64")
            scrapImageView.tintColor = UIColor.init(named: "darkGraySubtitleColor")
            scrapImageView.alpha = 0.9
        }
        
        
        if isLiked {
            likeImageView.image = UIImage(named: "heart2.fill")
            likeImageView.tintColor = UIColor.init(named: "blackSelectedColor")
        } else {
            likeImageView.image = UIImage(named: "heart2")
            likeImageView.tintColor = UIColor.init(named: "darkGraySubtitleColor")
        }
        
        if let urlStr = post.profileUrl {
            BoardDataManager.shared.downloadImage(from: urlStr) { [weak self] image in
                guard let self = self else { return }
                if let image = image {
                    self.userImageView.image = BoardDataManager.shared.resizeImage(image: image, targetSize: CGSize(width: 40, height: 40))
                }
            }
        } else {
            self.userImageView.image = UIImage(named: "user")
        }
    
        userNameLabel.text = post.userName
        dateLabel.text = post.dateStr
        postTitleLabel.text = post.title
        postContentLabel.text = post.content
    
        // 게시글을 셀 클래스에서 사용하기위해 저장
        postId = post.postId
        self.isLiked = isLiked
        self.isScrapped = isScrapped
        scrapButton.tag = scrapPostId
    }
}



