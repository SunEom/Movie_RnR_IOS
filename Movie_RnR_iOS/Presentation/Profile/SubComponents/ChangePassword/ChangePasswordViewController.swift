//
//  ChangePasswordViewController.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/20.
//

import UIKit
import RxSwift
import SnapKit

class ChangePasswordViewController: UIViewController {
    
    private let viewModel: ChangePasswordViewModel
    
    private let disposeBag = DisposeBag()
    
    private let subtitleLabel: UILabel = {
       let label = UILabel()
        label.text = "Current Password"
        return label
    }()
    
    private let currentTextField = UITextField()
    
    private let subtitleLabel2: UILabel = {
        let label = UILabel()
        label.text = "New Password"
        return label
    }()
    
    private let newPasswordTextField = UITextField()
    
    private let subtitleLabel3: UILabel = {
        let label = UILabel()
        label.text = "New Password Check"
        return label
    }()
    
    private let passwordCheckTextField = UITextField()
    
    private let changeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "headerColor")
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        button.setTitle("Change Password", for: .normal)
        return button
    }()
    
    init(viewModel: ChangePasswordViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        attribute()
        bindViewModel()
    }
    
    private func bindViewModel() {
        
        let input = ChangePasswordViewModel.Input(trigger: changeButton.rx.tap.asDriver(), 
                                                  current: currentTextField.rx.text.orEmpty.asDriver(),
                                                  new: newPasswordTextField.rx.text.orEmpty.asDriver(),
                                                  newCheck: passwordCheckTextField.rx.text.orEmpty.asDriver())

        let output = viewModel.transform(input: input)
        
        output.result
            .drive(onNext: { result in
                let alert = UIAlertController(title: result.isSuccess ? "성공" : "실패", message: result.message ?? "", preferredStyle: .alert)
                let action: UIAlertAction!
                
                if result.isSuccess {
                    action = UIAlertAction(title: "확인", style: .default) {_ in
                        self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    action = UIAlertAction(title: "확인", style: .default)
                }
                
                alert.addAction(action)
                self.present(alert, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func layout() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        view.addGestureRecognizer(tap)
    
        [subtitleLabel, currentTextField, subtitleLabel2, newPasswordTextField, subtitleLabel3, passwordCheckTextField, changeButton]
            .forEach { view.addSubview($0) }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.equalTo(view).offset(15)
            $0.trailing.equalTo(view).offset(-15)
        }
        
        currentTextField.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(subtitleLabel)
            $0.height.equalTo(40)
        }
        
        subtitleLabel2.snp.makeConstraints {
            $0.top.equalTo(currentTextField.snp.bottom).offset(15)
            $0.leading.trailing.equalTo(subtitleLabel)
        }
        
        newPasswordTextField.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel2.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(subtitleLabel)
            $0.height.equalTo(40)
        }
        
        subtitleLabel3.snp.makeConstraints {
            $0.top.equalTo(newPasswordTextField.snp.bottom).offset(15)
            $0.leading.trailing.equalTo(subtitleLabel)
        }
        
        passwordCheckTextField.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel3.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(subtitleLabel)
            $0.height.equalTo(40)
        }
        
        changeButton.snp.makeConstraints {
            $0.top.equalTo(passwordCheckTextField.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(subtitleLabel)
            $0.height.equalTo(40)
        }
        
    }
    
    private func attribute() {
        view.backgroundColor = UIColor(named: "mainColor")
        
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
        
    }
    
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        view.endEditing(true)
    }
}
