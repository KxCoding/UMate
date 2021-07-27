//
//  DetailPostViewController.swift
//  DetailPostViewController
//
//  Created by 남정은 on 2021/07/27.
//

import UIKit

class DetailPostViewController: UIViewController {

    
    var selectedPost: Post?

    @IBOutlet weak var detailPostTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        detailPostTableView.rowHeight = UITableView.automaticDimension
        detailPostTableView.estimatedRowHeight = 180
    }
}



extension DetailPostViewController: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return detailPostTableView.rowHeight
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        default: return 0
        } //댓글과 대댓글은 section 2,3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch indexPath.section {
        case 0:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostContentTableViewCell", for: indexPath) as! PostContentTableViewCell
            guard let post = selectedPost else { return cell }
            //print("1")
            cell.configure(post: post)
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostImageTableViewCell", for: indexPath) as! PostImageTableViewCell
            guard let post = selectedPost else { return cell }
            //print(post.images.count)
            cell.configure(post: post)
            return cell
            
        default: fatalError()
        }
        
    }
}

