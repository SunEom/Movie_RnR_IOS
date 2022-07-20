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
            
            AF.request("\(ProcessInfo.processInfo.environment["ServerURL"]!)/auth/login", method: .post, parameters: ["id": id, "password": password])
                .validate(statusCode: 200..<300)
                .responseDecodable(of: LoginResponse.self) { response in
                    if let res = response.value {
                        print(res)
                    }
                }
            
        }
    }
    
}
