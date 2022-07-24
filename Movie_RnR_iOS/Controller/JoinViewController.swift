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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        genderPicker.dataSource = self
        genderPicker.delegate = self
        genderPicker.setValue(UIColor.black, forKey: "textColor")
        
    }

    @IBAction func idCheckPressed(_ sender: UIButton) {
    }
    
    @IBAction func nicknameCheckPressed(_ sender: UIButton) {
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
