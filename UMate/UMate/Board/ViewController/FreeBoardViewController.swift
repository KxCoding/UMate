//
//  FreeBoardViewController.swift
//  FreeBoardViewController
//
//  Created by 남정은 on 2021/07/21.
//

import UIKit

class FreeBoardViewController: UIViewController {
    
    var selectedBoard: Board?
    
    @IBOutlet weak var postListTableView: UITableView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell, let indexPath = postListTableView.indexPath(for: cell) {
            if let vc = segue.destination as? DetailPostViewController {
                vc.selectedPost = selectedBoard?.posts[indexPath.row]
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = selectedBoard?.boardTitle
    }
}



extension FreeBoardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedBoard?.posts.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //if selectedBoard == scrapBoard라면 indexPath.reversed()하고 셀을 리턴해야함.
        let cell = tableView.dequeueReusableCell(withIdentifier: "FreeBoardTableViewCell", for: indexPath) as! FreeBoardTableViewCell
        guard let post = selectedBoard?.posts[indexPath.row] else { return cell }
        
        cell.configure(post: post)
        return cell
    }
}
