//
//  SearchLIstUniversityViewController.swift
//  SearchLIstUniversityViewController
//
//  Created by 황신택 on 2021/08/06.
//

import UIKit

extension Notification.Name {
    static let didTapSendUniversityName = Notification.Name("didTapSendUniversityName")
}

class SearchLIstUniversityViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var listTableView: UITableView!
    
    var searchCountry = [String]()
    var searching = false
    
    static let universityNameTransitionKey = "universityNameTransitionKey"
    
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func completeButton(_ sender: Any) {
        guard let searchBarText = searchBar.text else { return  }
        NotificationCenter.default.post(name: .didTapSendUniversityName, object: nil, userInfo: [SearchLIstUniversityViewController.universityNameTransitionKey: searchBarText])
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listTableView.delegate = self
        listTableView.dataSource = self
        searchBar.delegate = self
        listTableView.isHidden = true

    }
    
}


extension SearchLIstUniversityViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchCountry.count
        }
        
        return universityList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        if searching {
            cell.textLabel?.text = searchCountry[indexPath.row]
        } else {
            cell.textLabel?.text = universityList[indexPath.row]
        }
        
        return cell
    }
    
    
}

extension SearchLIstUniversityViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searching {
            searchBar.text = searchCountry[indexPath.row]
        } else {
            searchBar.text = universityList[indexPath.row]
        }
        
    }
    
}


extension SearchLIstUniversityViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searching = true
        searchCountry = universityList.filter{ $0.prefix(searchText.count) == searchText }
        
        listTableView.reloadData()
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        listTableView.isHidden = false
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
    
    
    
}
