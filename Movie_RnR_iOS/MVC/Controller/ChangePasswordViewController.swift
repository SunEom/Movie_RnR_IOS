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
    
    var keyHeight: CGFloat?
    
    @objc func keyboardWillShow(_ sender: Notification) {
        
        let userInfo:NSDictionary = sender.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        keyHeight = keyboardHeight

        self.view.frame.size.height -= keyboardHeight
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        
        self.view.frame.size.height += keyHeight!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
  
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
    @IBAction func tapBackgroundView(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}
