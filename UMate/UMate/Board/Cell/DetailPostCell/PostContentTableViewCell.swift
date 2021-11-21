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
}


/// 게시물 '공감' 및 '스크랩' 정보 서비스
enum ScrapInfoService {
    case saveScrapInfo(ScrapPostData)
    case saveLikeInfo(LikePostData)
}



extension ScrapInfoService: TargetType {
    
    /// 기본 URL
    var baseURL: URL {
        return URL(string: "https://board1104.azurewebsites.net")!
    }
    
    /// 기본 URL제외한 경로
    var path: String {
        switch self {
        case .saveScrapInfo:
            return "/api/scrapPost"
        case .saveLikeInfo:
            return "/likePost"
        }
    }
    
    /// HTTP요청 메소드
    var method: Moya.Method {
        return .post
    }
    
    /// HTTP 작업
    var task: Task {
        switch self {
        case .saveScrapInfo(let scrapPostData):
            return .requestJSONEncodable(scrapPostData)
        case .saveLikeInfo(let likePostData):
            return .requestJSONEncodable(likePostData)
        }
    }
    
    /// HTTP 헤더
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}



/// 게시글 작성자, 제목, 내용에 관한 테이블 뷰 셀
/// - Author: 남정은(dlsl7080@gmail.com)
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
    
    /// 네트워크 통신 관리 객체
    let provider = MoyaProvider<ScrapInfoService>()
    
    /// 선택된 게시글
    var selectedPost: PostDtoResponseData.Post?
    
    /// 게시글 좋아요 여부
    var isLiked = false
    
    /// 게시글 스크랩 여부
    var isScrapped = false
    
    
    // MARK: 공감 버튼
    /// 하트 이미지 뷰
    @IBOutlet weak var likeImageView: UIImageView!
    
    
    /// 하트 버튼을 눌렀을 때 하트 이미지의 색상이 변경됩니다.
    /// - Parameter sender: 하트 버튼
    /// - Author: 남정은(dlsl7080@gmail.com)
    @IBAction func toggleLikeButton(_ sender: UIButton) {
        guard let post = selectedPost else { return }
        
        if isLiked {
            NotificationCenter.default.post(name: .postAlreadyLiked, object: nil)
        }
        
        likeImageView.image = UIImage(named: "heart2.fill")
        likeImageView.tintColor = UIColor.init(named: "blackSelectedColor")
        
        
        let dateStr = BoardDataManager.shared.postDateFormatter.string(from: Date())
        #warning("사용자 수정")
        let likePostdata = LikePostData(userId: "6c1c72d6-fa9b-4af6-8730-bb98fded0ad8", postId: post.postId, createdAt: dateStr)
        
        sendLikeInfoToServer(likePostData: likePostdata)

        isLiked = true
        NotificationCenter.default.post(name: .postDidLike, object: nil, userInfo: ["postId": post.postId])
    }
    
    
    // MARK: 스크랩 버튼
    /// 스크랩 이미지 뷰
    @IBOutlet weak var scrapImageView: UIImageView!
    @IBOutlet weak var scrapButton: UIButton!
    
    
    /// 스크랩 버튼을 눌렀을 때 스크랩 이미지 색상이 변경됩니다.
    /// - Parameter sender: 스크랩 버튼
    /// - Author: 남정은(dlsl7080@gmail.com)
    @IBAction func toggleScrapButton(_ sender: UIButton) {
        guard let post = selectedPost else { return }
        let scrapPostId = sender.tag
    
        if isScrapped {
            isScrapped = false
            scrapImageView.image = UIImage(named: "bookmark64")
            scrapImageView.tintColor = UIColor.init(named: "darkGraySubtitleColor")
            scrapImageView.alpha = 0.9
            
            deleteScrapPost(scrapPostId: scrapPostId)
            NotificationCenter.default.post(name: .postCancelScrap, object: nil, userInfo: ["postId":post.postId])
            
        } else {
            isScrapped = true
            scrapImageView.image = UIImage(named: "bookmark64.fill")
            scrapImageView.tintColor = UIColor.init(named: "blackSelectedColor")
            scrapImageView.alpha = 1
            
            
            let dateStr = BoardDataManager.shared.postDateFormatter.string(from: Date())
            #warning("사용자 수정")
            let scrapPostData = ScrapPostData(userId: "6c1c72d6-fa9b-4af6-8730-bb98fded0ad8", postId: post.postId, createdAt: dateStr)
            
            sendScrapInfoToServer(scrapPostData: scrapPostData)
        }
    }
    
    
    /// 신고 혹은 게시글 수정, 삭제를 actionSheet로 나타냅니다.
    /// - Parameter sender: 햄버거 버튼
    /// - Author: 남정은(dlsl7080@gmail.com)
    @IBAction func showMenu(_ sender: Any) {
        NotificationCenter.default.post(name: .alertDidSend, object: nil)
    }
    
    
    /// 게시물 '스크랩' 정보를 서버에 저장합니다.
    /// - Parameter likePostData: 게시물 스크랩 정보 객체
    ///   - Author: 남정은(dlsl7080@gmail.com), 김정민(kimjm010@icloud.com)
    private func sendScrapInfoToServer(scrapPostData: ScrapPostData) {
        provider.rx.request(.saveScrapInfo(scrapPostData))
            .filterSuccessfulStatusCodes()
            .map(SaveScrapPostPostResponse.self)
            .subscribe { (result) in
                switch result {
                case .success(let response):
                    switch response.resultCode {
                    case ResultCode.ok.rawValue:
                        DispatchQueue.main.async {
                            self.scrapButton.tag = response.scrapPost?.scrapPostId ?? 0
                        }
                        
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
                case .failure(let error):
                    #if DEBUG
                    print(error)
                    #endif
                }
            }
            .disposed(by: rx.disposeBag)
    }
    
    
    /// 게시물 '공감' 정보를 서버에 저장합니다.
    /// - Parameter likePostData: 게시물 공감 정보 객체
    ///   - Author: 남정은(dlsl7080@gmail.com), 김정민(kimjm010@icloud.com)
    private func sendLikeInfoToServer(likePostData: LikePostData) {
        provider.rx.request(.saveLikeInfo(likePostData))
            .filterSuccessfulStatusCodes()
            .map(SaveScrapPostPostResponse.self)
            .subscribe { (result) in
                switch result {
                case .success(let response):
                    switch response.resultCode {
                    case ResultCode.ok.rawValue:
                        DispatchQueue.main.async {
                            self.scrapButton.tag = response.scrapPost?.scrapPostId ?? 0
                        }
                        
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
                case .failure(let error):
                    #if DEBUG
                    print(error)
                    #endif
                }
            }
            .disposed(by: rx.disposeBag)
    }
    
    
    /// 게시물 스크랩을 취소합니다.
    /// - Parameter scrapPostId: 스크랩 Id
    /// - Author: 남정은(dlsl7080@gmail.com)
    private func deleteScrapPost(scrapPostId: Int) {
        guard let url = URL(string: "https://board1104.azurewebsites.net/api/scrapPost/\(scrapPostId)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        BoardDataManager.shared.session.dataTask(with: request) { data, response, error in
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
                let res = try decoder.decode(CommonResponse.self, from: data)
                
                switch res.resultCode {
                case ResultCode.ok.rawValue:
                    #if DEBUG
                    print("삭제 성공")
                    #endif
                case ResultCode.fail.rawValue:
                    #if DEBUG
                    print("삭제 실패")
                    #endif
                default:
                    break
                }
            } catch {
                print(error)
            }
        }.resume()
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
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
        
        userNameLabel.text = post.userId
        dateLabel.text = post.createdAt
        postTitleLabel.text = post.title
        postContentLabel.text = post.content
    
        // 게시글을 셀 클래스에서 사용하기위해 저장
        selectedPost = post
        self.isLiked = isLiked
        self.isScrapped = isScrapped
        scrapButton.tag = scrapPostId
    }
}



