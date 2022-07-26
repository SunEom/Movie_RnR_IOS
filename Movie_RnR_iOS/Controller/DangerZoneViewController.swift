//
//  DangerZoneViewController.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/07/25.
//

import UIKit

class DangerZoneViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func removeAccountPressed(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "계정 삭제", message: "정말로 삭제하시겠습니까?", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let confirm = UIAlertAction(title: "삭제", style: .destructive) { action in
            UserManager.removeAccount {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    
        alert.addAction(cancel)
        alert.addAction(confirm)
        
        present(alert, animated: true)
    }
    
}
