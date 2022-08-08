//
//  StartViewController.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/07/21.
//

import UIKit

class StartViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let id = UserDefaults.standard.object(forKey: "id") as? String, let password = UserDefaults.standard.object(forKey: "password") as? String {
            UserManager.loginPost(id: id, password: password, errorHandler: {
                self.goToHome()
                UserDefaults.standard.removeObject(forKey: "id")
                UserDefaults.standard.removeObject(forKey: "password")
            }, completion: goToHome)
        } else {
            goToHome()
        }
    }
    
    func goToHome() {
        performSegue(withIdentifier: Constant.SegueID.Home, sender: self)
    }
    
}

