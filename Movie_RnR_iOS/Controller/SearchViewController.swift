//
//  SearchViewController.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/07/27.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let postingManager = PostingManager()
    
    var keyword = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        postingManager.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "TitleTableViewCell", bundle: nil), forCellReuseIdentifier: Constant.TableViewCellID.Title)
        tableView.register(UINib(nibName: "PostingTableViewCell", bundle: nil), forCellReuseIdentifier: Constant.TableViewCellID.Posting)
    }
}

//MARK: - Table View Data Source Method

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postingManager.postings.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constant.TableViewCellID.Title, for: indexPath) as! TitleTableViewCell
            
            cell.titleLabel.text = "Keyword: \(keyword)"
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constant.TableViewCellID.Posting, for: indexPath) as! PostingTableViewCell
            
            cell.titleLabel.text = postingManager.postings[indexPath.row-1].title
            cell.genreLabel.text = postingManager.postings[indexPath.row-1].genres
            cell.rateLabel.text = "✭ \(postingManager.postings[indexPath.row-1].rates)"
            cell.overviewLabel.text = postingManager.postings[indexPath.row-1].overview
            
            if let commentCount = postingManager.postings[indexPath.row-1].commentCount {
                cell.commentNumLabel.text = "💬 \(commentCount)"
            } else {
                cell.commentNumLabel.text = "\(0)"
            }
            
            return cell
        }
        
        
    }
}

//MARK: - Posting Manager Delegate Method

extension SearchViewController: PostingManagerDelegate {
    func didSearchPostings(_ postingManager: PostingManager, postings: [Posting]) {
        
        activityIndicator.stopAnimating()
        
        tableView.reloadData()
    }
}


//MARK: - Table View Delegate Method

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constant.SegueID.detail, sender: postingManager.postings[indexPath.row-1].id)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.SegueID.detail {
            let detailVC = segue.destination as! DetailViewController

            guard let postNum = sender else { return }
            
            detailVC.postNum = (postNum as! Int)
        }
    }
}

//MARK: - Search Bar Delegate Methods

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text else { return }
        self.keyword = keyword
        activityIndicator.startAnimating()
        postingManager.searchPostings(keyword: keyword)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            DispatchQueue.main.async {
                 searchBar.resignFirstResponder()
            }
        }
        
        
    }
}
