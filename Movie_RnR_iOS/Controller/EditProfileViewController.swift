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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let userData = UserManager.getInstance() else { return }
        
        nicknameTextField.text = userData.nickname
        
        biographyTextView.text = userData.biography
        
        fbTextField.text = userData.facebook
        igTextField.text = userData.instagram
        ttTextField.text = userData.twitter
        
        genderPicker.dataSource = self
        genderPicker.delegate = self
        genderPicker.setValue(UIColor.black, forKey: "textColor")
    }
    

    @IBAction func savePressed(_ sender: Any) {
        // 프로필 수정시 모든 정보가 null로 수정되는 오류 발생
        
        
//        var params = [String: String]()
//
//        if let nickname = nicknameTextField.text,
//            let biography = biographyTextView.text,
//            let facebook = fbTextField.text,
//            let instagram = igTextField.text,
//            let twitter = ttTextField.text {
//
//            let gender = ["None","Man","Woman"][genderPicker.selectedRow(inComponent: 0)]
//
//            params["nickname"] = nickname
//            params["biography"] = biography
//            params["gender"] = gender
//            params["facebook"] = facebook
//            params["instagram"] = instagram
//            params["twitter"] = twitter
//
//
//            UserManager.update(with: UpdateProfileRequest(nickname: nickname, gender: gender, biography: biography, facebook: facebook, instagram: instagram, twitter: twitter))
//        }
        
        
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
