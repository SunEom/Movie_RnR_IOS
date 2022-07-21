//
//  ViewController.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/07/15.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let postingManager = PostingManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        // Config Table View
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "PostingTableViewCell", bundle: nil), forCellReuseIdentifier: Constant.TableViewCellID.Posting)
        tableView.register(UINib(nibName: "TitleTableViewCell", bundle: nil), forCellReuseIdentifier: Constant.TableViewCellID.Title)
        
        
        postingManager.delegate = self
        
        postingManager.fetchRecentPost()
        

        if let id = UserDefaults.standard.object(forKey: "id") as? String, let password = UserDefaults.standard.object(forKey: "password") as? String {
            UserManager.loginPost(id: id, password: password)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UserManager.loginGet()
    }

    @IBAction func userPressed(_ sender: UIBarButtonItem) {
        if UserManager.getInstance() != nil {
            performSegue(withIdentifier: Constant.SegueID.myPage, sender: self)
        } else {
            performSegue(withIdentifier: Constant.SegueID.login, sender: self)
        }
    }
    
}

//MARK: - Table View Data Source Methods

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postingManager.postings.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constant.TableViewCellID.Title, for: indexPath)
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

extension HomeViewController: UITableViewDelegate {
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

//MARK: - Post Manager delegate Method

extension HomeViewController: PostingManagerDelegate {
    func didUpdatePostings(_ postingManager: PostingManager, postings: [Posting]) {
        activityIndicator.stopAnimating()
        tableView.reloadData()
    }
}
