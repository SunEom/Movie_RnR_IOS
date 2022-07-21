//
//  MyPageViewController.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/07/21.
//

import UIKit

class MyPageViewController: UIViewController {
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var biographyTextView: UITextView!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var instagramButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    let menuList = ["Edit Profile", "Change Password", "View Postings", "Danger Zone"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBAction func socialMediaPressed(_ sender: UIButton) {
        
        if sender == facebookButton {
            print("FaceBook")
        } else if sender == instagramButton {
            print("Instagram")
        } else if sender == twitterButton {
            print("Twitter")
        }
        
    }
    
}

//MARK: - Menu Table View Data Source Methods

extension MyPageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.TableViewCellID.MyPageMenu, for: indexPath)
        
        cell.accessoryType = .disclosureIndicator
        
        cell.textLabel?.text = menuList[indexPath.row]
        
        DispatchQueue.main.async {
            self.tableViewHeight.constant = self.tableView.contentSize.height
        }
        
        return cell
    }
    
}

//MARK: - Menu Table View Delegate Methods

extension MyPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath)!
        
        selectedCell.isSelected = false
        
        if let selectedMenu = selectedCell.textLabel?.text {
            print(selectedMenu)
        }
        
        
    }
}
