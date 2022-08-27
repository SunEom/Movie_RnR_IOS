//
//  ChangePasswordViewController.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/20.
//

import UIKit
import RxSwift

class ChangePasswordViewController: UIViewController {
    
    var viewModel: ChangePasswordViewModel!
    
    let disposeBag = DisposeBag()
    
    let subtitleLabel = UILabel()
    let currentTextField = UITextField()
    
    let subtitleLabel2 = UILabel()
    let newPasswordTextField = UITextField()
    
    let subtitleLabel3 = UILabel()
    let passwordCheckTextField = UITextField()
    
    let changeButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        attribute()
        bind()
    }
    
    private func bind() {
        currentTextField.rx.text
            .map { $0 ?? ""}
            .bind(to: viewModel.currentPassword)
            .disposed(by: disposeBag)
        
        newPasswordTextField.rx.text
            .map { $0 ?? ""}
            .bind(to: viewModel.newPassword)
            .disposed(by: disposeBag)
        
        passwordCheckTextField.rx.text
            .map { $0 ?? ""}
            .bind(to: viewModel.newPasswordCheck)
            .disposed(by: disposeBag)
        
        changeButton.rx.tap
            .bind(to: viewModel.saveButtonTap)
            .disposed(by: disposeBag)
        
        viewModel.alert
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                let alert = UIAlertController(title: $0.title, message: $0.messsage, preferredStyle: .alert)
                let action = UIAlertAction(title: "확인", style: .default)
                alert.addAction(action)
                self.present(alert, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func layout() {
        
        [subtitleLabel, currentTextField, subtitleLabel2, newPasswordTextField, subtitleLabel3, passwordCheckTextField, changeButton]
            .forEach {
                view.addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
        
        [
            subtitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            
            currentTextField.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 10),
            currentTextField.leadingAnchor.constraint(equalTo: subtitleLabel.leadingAnchor),
            currentTextField.trailingAnchor.constraint(equalTo: subtitleLabel.trailingAnchor),
            currentTextField.heightAnchor.constraint(equalToConstant: 40),
            
            subtitleLabel2.topAnchor.constraint(equalTo: currentTextField.bottomAnchor, constant: 15),
            subtitleLabel2.leadingAnchor.constraint(equalTo: subtitleLabel.leadingAnchor),
            subtitleLabel2.trailingAnchor.constraint(equalTo: subtitleLabel.trailingAnchor),
            
            newPasswordTextField.topAnchor.constraint(equalTo: subtitleLabel2.bottomAnchor, constant: 10),
            newPasswordTextField.leadingAnchor.constraint(equalTo: subtitleLabel.leadingAnchor),
            newPasswordTextField.trailingAnchor.constraint(equalTo: subtitleLabel.trailingAnchor),
            newPasswordTextField.heightAnchor.constraint(equalToConstant: 40),
            
            subtitleLabel3.topAnchor.constraint(equalTo: newPasswordTextField.bottomAnchor, constant: 15),
            subtitleLabel3.leadingAnchor.constraint(equalTo: subtitleLabel.leadingAnchor),
            subtitleLabel3.trailingAnchor.constraint(equalTo: subtitleLabel.trailingAnchor),
            
            passwordCheckTextField.topAnchor.constraint(equalTo: subtitleLabel3.bottomAnchor, constant: 10),
            passwordCheckTextField.leadingAnchor.constraint(equalTo: subtitleLabel.leadingAnchor),
            passwordCheckTextField.trailingAnchor.constraint(equalTo: subtitleLabel.trailingAnchor),
            passwordCheckTextField.heightAnchor.constraint(equalToConstant: 40),
            
            changeButton.topAnchor.constraint(equalTo: passwordCheckTextField.bottomAnchor, constant: 20),
            changeButton.leadingAnchor.constraint(equalTo: subtitleLabel.leadingAnchor),
            changeButton.trailingAnchor.constraint(equalTo: subtitleLabel.trailingAnchor),
            changeButton.heightAnchor.constraint(equalToConstant: 40),
            
        ]
            .forEach { $0.isActive = true }
        
    }
    
    private func attribute() {
        view.backgroundColor = UIColor(named: "mainColor")
        
        subtitleLabel.text = "Current Password"
        subtitleLabel2.text = "New Password"
        subtitleLabel3.text = "New Password Check"
        
        [subtitleLabel, subtitleLabel2, subtitleLabel3]
            .forEach {
                $0.textColor = .black
                $0.font = .systemFont(ofSize: 18, weight: .bold)
            }
        
        [currentTextField, newPasswordTextField, passwordCheckTextField]
            .forEach {
                $0.textColor = .black
                $0.backgroundColor = .white
                $0.layer.cornerRadius = 5
                $0.isSecureTextEntry = true
                
                $0.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 12.0, height: 0.0))
                $0.leftViewMode = .always
                $0.rightView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 12.0, height: 0.0))
                $0.rightViewMode = .always
                $0.autocapitalizationType = .none
                $0.autocorrectionType = .no
            }
        
        changeButton.backgroundColor = UIColor(named: "headerColor")
        changeButton.titleLabel?.textColor = .white
        changeButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        changeButton.setTitle("Change Password", for: .normal)
        
    }
}
