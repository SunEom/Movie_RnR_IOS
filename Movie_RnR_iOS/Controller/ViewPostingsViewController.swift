//
//  ViewPostingsViewController.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/07/22.
//

import UIKit

class ViewPostingsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var postingManager = PostingManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "TitleTableViewCell", bundle: nil), forCellReuseIdentifier: Constant.TableViewCellID.Title)
        tableView.register(UINib(nibName: "PostingTableViewCell", bundle: nil), forCellReuseIdentifier: Constant.TableViewCellID.Posting)
        
        postingManager.delegate = self
        
        postingManager.fetchMyPostings()
        
    }

}

//MARK: - Posting Manager Delegate Methods

extension ViewPostingsViewController: PostingManagerDelegate {
    func didFetchMyPostings(_ postingManager: PostingManager, postings: [Posting]) {
        tableView.reloadData()
    }
}

//MARK: - Table view Data Source Methods

extension ViewPostingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        postingManager.postings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constant.TableViewCellID.Title, for: indexPath) as! TitleTableViewCell
            
            cell.titleLabel.text = "My Postings"
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constant.TableViewCellID.Posting, for: indexPath) as! PostingTableViewCell
            
            cell.titleLabel.text = postingManager.postings[indexPath.row-1].title
            cell.genreLabel.text = postingManager.postings[indexPath.row-1].genres
            cell.rateLabel.text = "\(postingManager.postings[indexPath.row-1].rates)"
            cell.overviewLabel.text = postingManager.postings[indexPath.row-1].overview
            if let commentCount = postingManager.postings[indexPath.row-1].commentCount {
                cell.commentNumLabel.text = "\(commentCount)"
            } else {
                cell.commentNumLabel.text = "\(0)"
            }
            
            return cell
        }
        
    }
}

//MARK: - Table View Delegate Method

extension ViewPostingsViewController: UITableViewDelegate {
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
