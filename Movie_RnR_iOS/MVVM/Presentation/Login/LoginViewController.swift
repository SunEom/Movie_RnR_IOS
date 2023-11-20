//
//  LoginViewController.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/12.
//

import UIKit
import RxSwift
import SnapKit

class LoginViewController: UIViewController {
    
    private let viewModel: LoginViewModel!
    
    private let disposeBag = DisposeBag()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Login"
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: "CarterOne", size: 20)
        return label
    }()
    
    private let idTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "ID"
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 12.0, height: 0.0))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 12.0, height: 0.0))
        textField.rightViewMode = .always
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 12.0, height: 0.0))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 12.0, height: 0.0))
        textField.rightViewMode = .always
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        
        return textField
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "headerColor")
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        return button
    }()
    
    private let joinButton: UIButton = {
        let button = UIButton()
        button.setTitle("Join >", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        return button
    }()

    init(viewModel: LoginViewModel!) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attribute()
        layout()
        bindViewModel()
        uiEvent()
    }
    
    private func bindViewModel() {
        let input = LoginViewModel.Input(id: idTextField.rx.text.orEmpty.asDriver(),
                                         pwd: passwordTextField.rx.text.orEmpty.asDriver(),
                                         loginTrigger: loginButton.rx.tap.asDriver())
        
        let output = viewModel.transfrom(input: input)
        
        output.loginResult.drive(onNext: { result in
            if result.isSuccess {
                self.navigationController?.popViewController(animated: true)
            } else {
                let alert = UIAlertController(title: "실패", message: result.message, preferredStyle: .alert)
                let action = UIAlertAction(title: "확인", style: .default)
                alert.addAction(action)
                self.present(alert, animated: true)
            }
        })
        .disposed(by: disposeBag)
    }
    
    private func uiEvent() {
        joinButton.rx.tap.asDriver()
            .drive(onNext: { _ in
                let joinVC = JoinFactory().getInstance()
                self.navigationController?.pushViewController(joinVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func layout() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        view.addGestureRecognizer(tap)
        
        [titleLabel, idTextField, passwordTextField, loginButton]
            .forEach { self.stackView.addArrangedSubview($0) }
        
        [stackView, joinButton].forEach {
            view.addSubview($0)
        }
        
        stackView.snp.makeConstraints {
            $0.width.equalTo(300)
            $0.centerX.centerY.equalTo(view)
        }
        
        idTextField.snp.makeConstraints {
            $0.height.equalTo(45)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.height.equalTo(45)
        }
        
        loginButton.snp.makeConstraints {
            $0.height.equalTo(40)
        }
        
        joinButton.snp.makeConstraints {
            $0.trailing.equalTo(stackView)
            $0.top.equalTo(stackView.snp.bottom).offset(5)
            $0.height.equalTo(30)
            $0.width.equalTo(50)
        }

    }
    
    private func attribute() {
        view.backgroundColor = UIColor(named: "mainColor")
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        view.endEditing(true)
    }    
}
