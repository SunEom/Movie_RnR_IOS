//
//  LoginViewController.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/12.
//

import UIKit
import RxSwift

class LoginViewController: UIViewController {
    
    var viewModel: LoginViewModel!
    
    let disposeBag = DisposeBag()
    
    let stackView = UIStackView()
    let titleLabel = UILabel()
    let idTextField = UITextField()
    let passwordTextField = UITextField()
    let loginButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        attribute()
        layout()
        bind()
    }
    
    private func bind() {
        idTextField.rx.text
            .bind(to: viewModel.id)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
        
        loginButton.rx.tap
            .bind(to: viewModel.loginPressed)
            .disposed(by: disposeBag)
        
        UserManager.getInstance()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                if $0 != nil {
                    self.navigationController?.popViewController(animated: true)
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    private func layout() {
        [titleLabel, idTextField, passwordTextField, loginButton]
            .forEach { self.stackView.addArrangedSubview($0) }
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        [
            stackView.widthAnchor.constraint(equalToConstant: 300),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            idTextField.heightAnchor.constraint(equalToConstant: 45),
            passwordTextField.heightAnchor.constraint(equalToConstant: 45),
            loginButton.heightAnchor.constraint(equalToConstant: 40),
            
        ].forEach { $0.isActive = true }
    }
    
    private func attribute() {
        view.backgroundColor = UIColor(named: "mainColor")
        
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 10
        
        titleLabel.text = "Login"
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "CarterOne", size: 20)
        
        [idTextField, passwordTextField].forEach {
            $0.backgroundColor = .white
            $0.textColor = .black
            $0.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 12.0, height: 0.0))
            $0.leftViewMode = .always
            $0.rightView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 12.0, height: 0.0))
            $0.rightViewMode = .always
            $0.autocapitalizationType = .none
            $0.autocorrectionType = .no
        }
        
        idTextField.attributedPlaceholder = NSAttributedString(
            string: "ID",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        
        idTextField.placeholder = "ID"
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        
        loginButton.backgroundColor = UIColor(named: "headerColor")
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.titleLabel?.font = .systemFont(ofSize: 15)
        
    }
}
