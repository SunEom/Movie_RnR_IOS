//
//  ViewController.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/07/15.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let postings = ["Hello","World","Data"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PostingTableViewCell", bundle: nil), forCellReuseIdentifier: Constant.TableViewCellID.PostingCellID)
        tableView.register(UINib(nibName: "TitleTableViewCell", bundle: nil), forCellReuseIdentifier: Constant.TableViewCellID.TitleCellID)
    }


}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postings.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constant.TableViewCellID.TitleCellID, for: indexPath)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constant.TableViewCellID.PostingCellID, for: indexPath)
            return cell
        }
        
        
        
    }
}
