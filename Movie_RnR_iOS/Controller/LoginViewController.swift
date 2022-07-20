//
//  LoginViewController.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/07/20.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        if let id = idTextField.text , let password = passwordTextField.text {
            if id.count == 0 {
                let alert = UIAlertController(title: "입력 오류", message: "아이디를 입력해주세요", preferredStyle: .alert)
                
                let action = UIAlertAction(title: "확인", style: .default)
                
                alert.addAction(action)
                
                present(alert, animated: true, completion: nil)
                return
            }
            
            if password.count == 0 {
                let alert = UIAlertController(title: "입력 오류", message: "비밀번호를 입력해주세요", preferredStyle: .alert)
                
                let action = UIAlertAction(title: "확인", style: .default)
                
                alert.addAction(action)
                
                present(alert, animated: true, completion: nil)
                return
            }
            
            UserManager.loginPost(id: id, password: password) {
                if let _ = UserManager.getInstance() {
                    let alert = UIAlertController(title: "로그인 성공", message: "정상적으로 로그인되었습니다!", preferredStyle: .alert)
                    
                    let action = UIAlertAction(title: "확인", style: .default) { action in
                        DispatchQueue.main.async {
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                    }
                    
                    alert.addAction(action)
        
                    self.present(alert, animated: true)
                }
            }
            
            
            
        }
    }
    
}
