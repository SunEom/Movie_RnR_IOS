//
//  EditProfileViewController.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/07/22.
//

import UIKit

class EditProfileViewController: UIViewController {
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var genderPicker: UIPickerView!
    @IBOutlet weak var biographyTextView: UITextView!
    @IBOutlet weak var fbTextField: UITextField!
    @IBOutlet weak var igTextField: UITextField!
    @IBOutlet weak var ttTextField: UITextField!
    
    var keyHeight: CGFloat?
    
    @objc func keyboardWillShow(_ sender: Notification) {
        
        let userInfo:NSDictionary = sender.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        keyHeight = keyboardHeight
        print("appear")
        self.view.frame.size.height -= keyboardHeight
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
            print("disappear")
        self.view.frame.size.height += keyHeight!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        guard let userData = UserManager.getInstance() else { return }
        
        nicknameTextField.text = userData.nickname
        
        biographyTextView.text = userData.biography
        
        fbTextField.text = userData.facebook
        igTextField.text = userData.instagram
        ttTextField.text = userData.twitter
        
        genderPicker.dataSource = self
        genderPicker.delegate = self
        genderPicker.setValue(UIColor.black, forKey: "textColor")
        
        switch userData.gender {
        case "None":
            genderPicker.selectRow(0, inComponent: 0, animated: false)
        case "Man":
            genderPicker.selectRow(1, inComponent: 0, animated: false)
        case "Woman":
            genderPicker.selectRow(2, inComponent: 0, animated: false)
        default:
            break
        }
        
    }
    

    @IBAction func savePressed(_ sender: Any) {
        
        var params = [String: String]()

        if let nickname = nicknameTextField.text,
            let biography = biographyTextView.text,
            let facebook = fbTextField.text,
            let instagram = igTextField.text,
            let twitter = ttTextField.text {

            let gender = Constant.genderList[genderPicker.selectedRow(inComponent: 0)]

            params["nickname"] = nickname
            params["biography"] = biography
            params["gender"] = gender
            params["facebook"] = facebook
            params["instagram"] = instagram
            params["twitter"] = twitter


            UserManager.update(with: UserUpdateRequest(nickname: nickname, gender: gender, biography: biography, facebook: facebook, instagram: instagram, twitter: twitter)) {
                let alert = UIAlertController(title: "정보 수정", message: "정상적으로 수정되었습니다.", preferredStyle: .alert)
                
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

//MARK: - Picker View Data Source Methods

extension EditProfileViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }

}

extension EditProfileViewController: UIPickerViewDelegate {
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
