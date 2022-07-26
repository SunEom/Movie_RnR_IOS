//
//  ChangePasswordViewController.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/07/26.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    @IBOutlet weak var currentPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordCheckTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func changePressed(_ sender: UIButton) {
        guard let currentPassword = currentPasswordTextField.text else { return }
        guard let newPassword = newPasswordTextField.text else { return }
        guard let newPasswordCheck = newPasswordCheckTextField.text else { return }
        
        if newPassword != newPasswordCheck {
            let alert = UIAlertController(title: "입력 오류", message: "비밀번호가 같지 않습니다.", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "다시 입력하기", style: .default)
            
            alert.addAction(action)
            
            present(alert, animated: true)
            
        } else {
            
            UserManager.changePassword(current: currentPassword, new: newPassword) { message in
                let alert = UIAlertController(title: "변경 실패", message: message, preferredStyle: .alert)
                
                let action = UIAlertAction(title: "확인", style: .default)
                
                alert.addAction(action)
                
                self.present(alert, animated: true)
            } completion: {
                let alert = UIAlertController(title: "변경 성공", message: "비밀번호가 정상적으로 변경되었습니다.", preferredStyle: .alert)
                
                let action = UIAlertAction(title: "확인", style: .default) { action in
                    self.navigationController?.popViewController(animated: true)
                }
                
                alert.addAction(action)
                
                self.present(alert, animated: true)
            }

            
        }
       
    }
}
