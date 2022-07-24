//
//  JoinViewController.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/07/24.
//

import UIKit

class JoinViewController: UIViewController {
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordCheckTextField: UITextField!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var genderPicker: UIPickerView!
    
    let joinManager = JoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        genderPicker.dataSource = self
        genderPicker.delegate = self
        genderPicker.setValue(UIColor.black, forKey: "textColor")
        
        [idTextField, nicknameTextField].forEach{ $0?.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)}
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == idTextField {
            print("id")
        } else if textField == nicknameTextField {
            print("nickname")
        }
    }

    @IBAction func idCheckPressed(_ sender: UIButton) {
        
        if let id = idTextField.text {
            joinManager.requestIdCheck(id, completion: {
                let alert = UIAlertController(title: "중복 확인", message: "사용 가능한 아이디입니다.", preferredStyle: .alert)
                
                let action = UIAlertAction(title: "확인", style: .default)
                
                alert.addAction(action)
                
                self.present(alert, animated: true)
                
            }, failure: {
                let alert = UIAlertController(title: "중복 확인", message: "이미 사용중인 아이디입니다.", preferredStyle: .alert)
                
                let action = UIAlertAction(title: "다시 입력하기", style: .default)
                
                alert.addAction(action)
                
                self.present(alert, animated: true)
                
            })
        }
        
    }
    
    @IBAction func nicknameCheckPressed(_ sender: UIButton) {
        if let nickname = nicknameTextField.text {
            joinManager.requestNicknameCheck(nickname, completion: {
                let alert = UIAlertController(title: "중복 확인", message: "사용 가능한 닉네임입니다.", preferredStyle: .alert)
                
                let action = UIAlertAction(title: "확인", style: .default)
                
                alert.addAction(action)
                
                self.present(alert, animated: true)
                
            }, failure: {
                let alert = UIAlertController(title: "중복 확인", message: "이미 사용중인 닉네임입니다.", preferredStyle: .alert)
                
                let action = UIAlertAction(title: "다시 입력하기", style: .default)
                
                alert.addAction(action)
                
                self.present(alert, animated: true)
                
            })
        }
    }
    
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        
        guard let id = idTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let passwordCheck = passwordCheckTextField.text else { return }
        guard let nickname = nicknameTextField.text else { return }
        let gender = Constant.genderList[genderPicker.selectedRow(inComponent: 0)]
        
        if id.count == 0 {
            let alert = UIAlertController(title: "입력 확인", message: "아이디를 입력해주세요.", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "확인", style: .default)
            
            alert.addAction(action)
            
            self.present(alert, animated: true)
            
            return
        }
        
        if password.count == 0 {
            let alert = UIAlertController(title: "입력 확인", message: "비밀번호를 입력해주세요.", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "확인", style: .default)
            
            alert.addAction(action)
            
            self.present(alert, animated: true)
            
            return
        }
        
        if nickname.count == 0 {
            let alert = UIAlertController(title: "입력 확인", message: "닉네임를 입력해주세요.", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "확인", style: .default)
            
            alert.addAction(action)
            
            self.present(alert, animated: true)
            
            return
        }
        
        if !joinManager.isIdChecked {
            let alert = UIAlertController(title: "중복 확인", message: "아이디 중복확인을 해주세요.", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "확인", style: .default)
            
            alert.addAction(action)
            
            self.present(alert, animated: true)
            
            return
        }
        
        joinManager.passwordCheck(for: password, with: passwordCheck)
        
        if !joinManager.isPasswordChecked {
            let alert = UIAlertController(title: "입력 확인", message: "비밀번호가 같지 않습니다.", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "확인", style: .default)
            
            alert.addAction(action)
            
            self.present(alert, animated: true)
            
            return
        }
        
        if !joinManager.isNicknameChecked {
            let alert = UIAlertController(title: "중복 확인", message: "닉네임 중복확인을 해주세요.", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "확인", style: .default)
            
            alert.addAction(action)
            
            self.present(alert, animated: true)
            
            return
        }
        
        joinManager.requestJoin(id: id, password: password, nickname: nickname, gender: gender) {
            let alert = UIAlertController(title: "가입성공", message: "정상적으로 가입되었습니다.", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "확인", style: .default) { action in
                self.navigationController?.popToRootViewController(animated: true)
            }
            
            alert.addAction(action)
            
            self.present(alert, animated: true)
            
            return
        }
    }
}

//MARK: - GenderPicker Data Source Methods

extension JoinViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }

}

//MARK: - GenderPicker Delegate Methods
extension JoinViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch row {
        case 0:
            return "None"
        case 1:
            return "Man"
        case 2:
            return "Woman"
        default:
            return ""
        }
    }

}
