//
//  JoinViewController.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/09/04.
//

import UIKit
import RxSwift

class JoinViewController : UIViewController {
    
    var viewModel: JoinViewModel!
    
    let disposeBag = DisposeBag()
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let idTitleLabel = UILabel()
    let idStackView = UIStackView()
    let idTextField = UITextField()
    let idCheckButton = UIButton()
    
    let pwdTitleLabel = UILabel()
    let pwdTextField = UITextField()
    
    let pwdCheckTitleLabel = UILabel()
    let pwdCheckTextField = UITextField()
    
    let nicknameTitleLabel = UILabel()
    let nicknameStackView = UIStackView()
    let nicknameTextField = UITextField()
    let nicknameCheckButton = UIButton()
    
    let genderTitleLabel = UILabel()
    let genderPicker = UIPickerView()

    let saveButton = UIBarButtonItem()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        attribute()
        layout()
    }
    
    private func bind() {
        
        viewModel.genderList
            .drive(genderPicker.rx.itemTitles) { idx, title in
                return title
            }
            .disposed(by: disposeBag)
        
    }
    
    private func attribute() {
        view.backgroundColor = UIColor(named: "mainColor")
        
        self.navigationItem.rightBarButtonItem = saveButton
        saveButton.title = "Save"
        
        [idStackView, nicknameStackView]
            .forEach {
                $0.alignment = .fill
                $0.distribution = .fillProportionally
                $0.spacing = 10
            }
        idStackView.addArrangedSubview(idTextField)
        idStackView.addArrangedSubview(idCheckButton)
        
        nicknameStackView.addArrangedSubview(nicknameTextField)
        nicknameStackView.addArrangedSubview(nicknameCheckButton)
        
        [nicknameCheckButton, idCheckButton]
            .forEach {
                $0.backgroundColor = UIColor(named: "headerColor")
                $0.setTitle("Check", for: .normal)
                $0.setTitleColor(.white, for: .normal)
            }
        
        idTitleLabel.text = "ID"
        nicknameTitleLabel.text = "Nickname"
        genderTitleLabel.text = "Gender"
        pwdTitleLabel.text = "Password"
        pwdCheckTitleLabel.text = "Password Check"

        
        [idTitleLabel, nicknameTitleLabel, genderTitleLabel, pwdTitleLabel, pwdCheckTitleLabel]
            .forEach {
                $0.textColor = .black
                $0.font = .systemFont(ofSize: 20, weight: .bold)
            }
        
        [ pwdTextField, pwdCheckTextField, idTextField, nicknameTextField, pwdTextField, pwdCheckTextField]
            .forEach {
                $0.textColor = .black
                $0.backgroundColor = .white
                $0.layer.cornerRadius = 5
                
                $0.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 12.0, height: 0.0))
                $0.leftViewMode = .always
                $0.rightView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 12.0, height: 0.0))
                $0.rightViewMode = .always
                $0.autocapitalizationType = .none
                $0.autocorrectionType = .no
            }
        
        genderPicker.setValue(UIColor.black, forKeyPath: "textColor")
    }
    
    private func layout() {
        
        // ScrollView Layout
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        [
            idTitleLabel,
            idStackView,
            pwdTitleLabel,
            pwdTextField,
            pwdCheckTitleLabel,
            pwdCheckTextField,
            nicknameTitleLabel,
            nicknameStackView,
            genderTitleLabel,
            genderPicker,
            
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        [
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo:scrollView.widthAnchor),
            
            // leading trailing 기준
            idTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            idTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            idTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            idStackView.topAnchor.constraint(equalTo: idTitleLabel.bottomAnchor, constant: 10),
            idStackView.leadingAnchor.constraint(equalTo: idTitleLabel.leadingAnchor),
            idStackView.trailingAnchor.constraint(equalTo: idTitleLabel.trailingAnchor),
            
            idCheckButton.widthAnchor.constraint(equalToConstant: 80),
            
            pwdTitleLabel.topAnchor.constraint(equalTo: idStackView.bottomAnchor, constant: 15),
            pwdTitleLabel.leadingAnchor.constraint(equalTo: idTitleLabel.leadingAnchor),
            pwdTitleLabel.trailingAnchor.constraint(equalTo: idTitleLabel.trailingAnchor),
            
            pwdTextField.topAnchor.constraint(equalTo: pwdTitleLabel.bottomAnchor, constant: 15),
            pwdTextField.leadingAnchor.constraint(equalTo: idTitleLabel.leadingAnchor),
            pwdTextField.trailingAnchor.constraint(equalTo: idTitleLabel.trailingAnchor),
            pwdTextField.heightAnchor.constraint(equalToConstant: 33),
            
            pwdCheckTitleLabel.topAnchor.constraint(equalTo: pwdTextField.bottomAnchor, constant: 15),
            pwdCheckTitleLabel.leadingAnchor.constraint(equalTo: idTitleLabel.leadingAnchor),
            pwdCheckTitleLabel.trailingAnchor.constraint(equalTo: idTitleLabel.trailingAnchor),
            
            pwdCheckTextField.topAnchor.constraint(equalTo: pwdCheckTitleLabel.bottomAnchor, constant: 15),
            pwdCheckTextField.leadingAnchor.constraint(equalTo: idTitleLabel.leadingAnchor),
            pwdCheckTextField.trailingAnchor.constraint(equalTo: idTitleLabel.trailingAnchor),
            pwdCheckTextField.heightAnchor.constraint(equalToConstant: 33),
            
            nicknameTitleLabel.topAnchor.constraint(equalTo: pwdCheckTextField.bottomAnchor, constant: 15),
            nicknameTitleLabel.leadingAnchor.constraint(equalTo: idTitleLabel.leadingAnchor),
            nicknameTitleLabel.trailingAnchor.constraint(equalTo: idTitleLabel.trailingAnchor),
            
            nicknameStackView.topAnchor.constraint(equalTo: nicknameTitleLabel.bottomAnchor, constant: 10),
            nicknameStackView.leadingAnchor.constraint(equalTo: idTitleLabel.leadingAnchor),
            nicknameStackView.trailingAnchor.constraint(equalTo: idTitleLabel.trailingAnchor),
            
            nicknameCheckButton.widthAnchor.constraint(equalToConstant: 80),
            
            genderTitleLabel.topAnchor.constraint(equalTo: nicknameStackView.bottomAnchor, constant: 15),
            genderTitleLabel.leadingAnchor.constraint(equalTo: idTitleLabel.leadingAnchor),
            genderTitleLabel.trailingAnchor.constraint(equalTo: idTitleLabel.trailingAnchor),
            
            genderPicker.topAnchor.constraint(equalTo: genderTitleLabel.bottomAnchor, constant: 10),
            genderPicker.leadingAnchor.constraint(equalTo: idTitleLabel.leadingAnchor ),
            genderPicker.trailingAnchor.constraint(equalTo: idTitleLabel.trailingAnchor),
            genderPicker.heightAnchor.constraint(equalToConstant: 120),
            
            contentView.bottomAnchor.constraint(equalTo: genderPicker.bottomAnchor,constant: 30)
            
        ].forEach { $0.isActive = true}
        
    }
}
