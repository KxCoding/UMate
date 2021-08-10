//
//  CategoryBoardViewController.swift
//  CategoryBoardViewController
//
//  Created by 남정은 on 2021/08/03.
//


import UIKit


class CategoryBoardViewController: UIViewController {
    
    @IBOutlet weak var postListTableView: UITableView!
    
    
    @IBAction func showSearchViewController(_ sender: Any) {
        performSegue(withIdentifier: "searchSegue", sender: self)
    }
    
    
    var categoryWidth: CGFloat = .zero
    
    var tableViewHeaderView: UIView = {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 5))
        return headerView
    }()
    
    
    var selectedBoard: Board?
    var filteredPostList: [Post] = []
    var nonCliked = true
    
    
    @IBOutlet weak var categoryListCollectionView: UICollectionView!
    
    @IBOutlet weak var categoryListTableView: UITableView!
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let cell = sender as? UITableViewCell,
           let indexPath = postListTableView.indexPath(for: cell) {
            
            if let vc = segue.destination as? DetailPostViewController {
                vc.selectedPost = filteredPostList[indexPath.row]
            }
            
        } else if segue.identifier == "searchSegue", let vc = segue.destination as? SearchViewController {
            vc.selectedBoard = selectedBoard
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = selectedBoard?.boardTitle
        postListTableView.tableHeaderView = tableViewHeaderView
        
        filteredPostList = selectedBoard?.posts ?? []
    }
}




extension CategoryBoardViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedBoard?.categories.count ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryBoardCollectionViewCell",
                                                      for: indexPath) as! CategoryBoardCollectionViewCell
        
        categoryWidth = cell.frame.width
       
        guard let cateigories = selectedBoard?.categories else { return cell }
        
        if indexPath.row == 0 {
            if nonCliked {
                cell.categoryView.backgroundColor = .lightGray
            } else {
                cell.categoryView.backgroundColor = .white
            }
        }
        
        cell.configure(categories: cateigories, indexPath: indexPath)
        return cell
    }
}




extension CategoryBoardViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        if nonCliked {
            nonCliked = false
            collectionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
        }
        
        return true
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        filteredPostList.removeAll()
        
        guard let posts = selectedBoard?.posts else {
            return }
        
        var isFiltering: Bool {
            let categoryFiltering = indexPath.row != 0
            return categoryFiltering
        }
        
        if isFiltering {
            filterPostByCategory(with: posts, indexPath: indexPath)
        } else {
            filteredPostList = posts
        }
        
        categoryListTableView.reloadData()
    }
    
    
    private func filterPostByCategory(with posts: [Post], indexPath: IndexPath) {
        
        if posts.first?.publicity != nil {
            filteredPostList = posts.filter{ post in
                return post.publicity?.rawValue == selectedBoard?.categories[indexPath.row]
            }
        } else if posts.first?.club != nil {
            filteredPostList = posts.filter{ post in
                return post.club?.rawValue == selectedBoard?.categories[indexPath.row]
            }
        } else if posts.first?.career != nil {
            filteredPostList = posts.filter{ post in
                return post.career?.rawValue == selectedBoard?.categories[indexPath.row]
            }
        }
    }
}




extension CategoryBoardViewController: UICollectionViewDelegateFlowLayout {
    //이 메소드가 cellForRowAt보다 먼저 실행됨.
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return .zero
        }
        
        let width:CGFloat
        guard let categoryCount = selectedBoard?.categories.count else { return .zero }
        let withoutInsetWidth = (view.frame.width -
                                 (flowLayout.minimumInteritemSpacing * CGFloat((categoryCount - 1))
                                     + flowLayout.sectionInset.left
                                     + flowLayout.sectionInset.right))
        
        if categoryCount == 3 {
            width = withoutInsetWidth / 3
            return CGSize(width: width, height: 50)
            
        } else if categoryCount == 4 {
            if indexPath.row == 0 || indexPath.row == 3 {
                width = withoutInsetWidth / 2 * 0.4
                return CGSize(width: width, height: 50)
                
            } else {
                width = withoutInsetWidth / 2 * 0.6
                return CGSize(width: width, height: 50)
            }
        }
        return .zero
    }
}




extension CategoryBoardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filteredPostList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FreeBoardTableViewCell",
                                                 for: indexPath) as! FreeBoardTableViewCell
        
        let post = filteredPostList[indexPath.row]
        
        cell.configure(post: post)
        return cell
    }
}
