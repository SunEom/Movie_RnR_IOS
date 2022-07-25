//
//  MyPageViewController.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/07/21.
//

import UIKit
import WebKit

class MyPageViewController: UIViewController {
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var biographyTextView: UITextView!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var instagramButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    let menuList = Constant.MyPageMenu.list

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("View will appear")
        
        guard let userData = UserManager.getInstance() else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        DispatchQueue.main.async {
            self.nicknameLabel.text = userData.nickname
            self.genderLabel.text = userData.gender
            self.biographyTextView.text = userData.biography
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == Constant.SegueID.SNS, let sender = sender {
            let destination = segue.destination as! WebViewController
            
            
            switch sender as! UIButton {
            case facebookButton:
                destination.urlString = UserManager.getInstance()?.facebook
            case instagramButton:
                destination.urlString = UserManager.getInstance()?.instagram
            case twitterButton:
                destination.urlString = UserManager.getInstance()?.twitter
            default:
                return
            }
            
            
            
        }
    }
    
    @IBAction func socialMediaPressed(_ sender: UIButton) {
        performSegue(withIdentifier: Constant.SegueID.SNS, sender: sender)
    }
    
    @IBAction func logoutPressed(_ sender: UIButton) {
        UserManager.logout {
            let alert = UIAlertController(title: "로그아웃 성공", message: "정상적으로 로그아웃 되었습니다.", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "확인", style: .default) { _ in
                self.navigationController?.popViewController(animated: true)
            }
            
            alert.addAction(action)
            
            self.present(alert, animated: true)
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
        cell.textLabel?.textColor = .black
        
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
            switch selectedMenu {
            case Constant.MyPageMenu.editProfile:
                performSegue(withIdentifier: Constant.SegueID.editProfile, sender: self)
                
            case Constant.MyPageMenu.changePassword:
                performSegue(withIdentifier: Constant.SegueID.changePassword, sender: self)
                
            case Constant.MyPageMenu.viewPostings:
                performSegue(withIdentifier: Constant.SegueID.viewPostings, sender: self)
                
            case Constant.MyPageMenu.dangerZone:
                performSegue(withIdentifier: Constant.SegueID.dangerZone, sender: self)
                
            default:
                return
            }
        }
        
        
    }
}
