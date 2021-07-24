//
//  DetailPostViewController.swift
//  DetailPostViewController
//
//  Created by 남정은 on 2021/07/24.
//

import UIKit


class DetailPostViewController: UIViewController {

    var selectedPost: Post?
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBAction func likeButton(_ sender: UIButton) {
        //공감 버튼
        print("+1 like")
    }
    @IBAction func scrapButton(_ sender: UIButton) {
        //스크랩 버튼
        print("+1 scrap")
    }
    
    @IBOutlet weak var likeContainerView: UIView!
    @IBOutlet weak var scrapContainerView: UIView!
    
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postContentLabel: UILabel!
    
    
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var scarpLabel: UILabel!
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        likeContainerView.layer.borderColor = UIColor.darkGray.cgColor
        likeContainerView.layer.borderWidth = 1.0
        likeContainerView.layer.cornerRadius = 5
        scrapContainerView.layer.borderColor = UIColor.darkGray.cgColor
        scrapContainerView.layer.borderWidth = 1.0
        scrapContainerView.layer.cornerRadius = 5
        
        guard let post = selectedPost else { return }
        configure(post: post)

    }
    
    private func configure(post: Post) {
        userNameLabel.text = selectedPost?.postWriter
        dateLabel.text = selectedPost?.insertDate.string
        postTitleLabel.text = selectedPost?.postTitle
        postContentLabel.text = selectedPost?.postContent
        likeLabel.text = selectedPost?.likeCount.description
        commentLabel.text = selectedPost?.commentCount.description
    }
}



extension DetailPostViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedPost?.images.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailPostImageCollectionViewCell", for: indexPath) as! DetailPostImageCollectionViewCell
        
        guard let image = selectedPost?.images[indexPath.row] else { return cell}
        cell.configure(image: image)
        return cell
    }
    
    
}

