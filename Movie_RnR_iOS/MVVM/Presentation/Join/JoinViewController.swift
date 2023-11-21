//
//  JoinViewController.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/09/04.
//

import UIKit
import RxSwift
import SnapKit

class JoinViewController : UIViewController {
    
    var viewModel: JoinViewModel!
    
    let disposeBag = DisposeBag()
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let idTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "ID"
        return label
    }()
    let idStackView = UIStackView()
    let idTextField = UITextField()
    let idCheckButton = UIButton()
    
    let pwdTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Password"
        return label
    }()
    let pwdTextField = UITextField()
    
    let pwdCheckTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Password Check"
        return label
    }()
    let pwdCheckTextField = UITextField()
    
    let nicknameTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Nickname"
        return label
    }()
    let nicknameStackView = UIStackView()
    let nicknameTextField = UITextField()
    let nicknameCheckButton = UIButton()
    
    let genderTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Gender"
        return label
    }()
    
    let genderPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.setValue(UIColor.black, forKeyPath: "textColor")
        return picker
    }()

    let saveButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = "Save"
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        attribute()
        layout()
    }
    
    private func bind() {
        
        let input = JoinViewModel.Input(idCheckTrigger: idCheckButton.rx.tap.asDriver(),
                                        nickCheckTrigger: nicknameCheckButton.rx.tap.asDriver(),
                                        joinTrigger: saveButton.rx.tap.asDriver(),
                                        id: idTextField.rx.text.orEmpty.asDriver(),
                                        password: pwdTextField.rx.text.orEmpty.asDriver(),
                                        passwordCheck: pwdCheckTextField.rx.text.orEmpty.asDriver(),
                                        nickname: nicknameTextField.rx.text.orEmpty.asDriver(),
                                        genderIdx: genderPicker.rx.itemSelected.map { $0.row }.asDriver(onErrorJustReturn: 0))
        
        let output = viewModel.transfrom(input: input)
        
        output.genderList
            .drive(genderPicker.rx.itemTitles) { idx, title in
                return title
            }
            .disposed(by: disposeBag)
        
        output.idCheckResult
            .drive(onNext: { result in
                if result.isSuccess {
                    let alert = UIAlertController(title: "성공", message: "사용 가능한 아이디입니다.", preferredStyle: .alert)
                    let action = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(action)
                    self.present(alert, animated: true)
                } else {
                    let alert = UIAlertController(title: "실패", message: result.message ?? "", preferredStyle: .alert)
                    let action = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(action)
                    self.present(alert, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        output.nickCheckResult
            .drive(onNext: { result in
                if result.isSuccess {
                    let alert = UIAlertController(title: "성공", message: "사용 가능한 닉네임입니다.", preferredStyle: .alert)
                    let action = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(action)
                    self.present(alert, animated: true)
                } else {
                    let alert = UIAlertController(title: "실패", message: result.message ?? "", preferredStyle: .alert)
                    let action = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(action)
                    self.present(alert, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        output.joinResult
            .drive(onNext: { result in
                if result.isSuccess {
                    let alert = UIAlertController(title: "성공", message: "정상적으로 회원가입 되었습니다!", preferredStyle: .alert)
                    let action = UIAlertAction(title: "확인", style: .default) { _ in
                        self.navigationController?.popViewController(animated: true)
                    }
                    alert.addAction(action)
                    self.present(alert, animated: true)
                } else {
                    let alert = UIAlertController(title: "실패", message: result.message ?? "", preferredStyle: .alert)
                    let action = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(action)
                    self.present(alert, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        output.saveAvailable
            .drive(saveButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
    }
    
    private func attribute() {
        view.backgroundColor = UIColor(named: "mainColor")
        
        self.navigationItem.rightBarButtonItem = saveButton
        
        [idStackView, nicknameStackView]
            .forEach {
                $0.alignment = .fill
                $0.distribution = .fillProportionally
                $0.spacing = 10
            }

        
        [nicknameCheckButton, idCheckButton]
            .forEach {
                $0.backgroundColor = UIColor(named: "headerColor")
                $0.setTitle("Check", for: .normal)
                $0.setTitleColor(.white, for: .normal)
            }
        
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
        
        [pwdTextField, pwdCheckTextField].forEach { $0.isSecureTextEntry = true }
        
    }
    
    private func layout() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        view.addGestureRecognizer(tap)
        
        idStackView.addArrangedSubview(idTextField)
        idStackView.addArrangedSubview(idCheckButton)
        
        nicknameStackView.addArrangedSubview(nicknameTextField)
        nicknameStackView.addArrangedSubview(nicknameCheckButton)
        
        view.addSubview(scrollView)
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
            contentView.addSubview($0)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.width.equalTo(scrollView)
        }
        
        idTitleLabel.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(15)
            $0.leading.equalTo(contentView).offset(15)
            $0.trailing.equalTo(contentView).offset(-15)
        }
        
        idStackView.snp.makeConstraints {
            $0.top.equalTo(idTitleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(idTitleLabel)
        }
        
        idCheckButton.snp.makeConstraints {
            $0.width.equalTo(80)
        }
        
        pwdTitleLabel.snp.makeConstraints {
            $0.top.equalTo(idStackView.snp.bottom).offset(15)
            $0.leading.trailing.equalTo(idTitleLabel)
        }
        
        pwdTextField.snp.makeConstraints {
            $0.top.equalTo(pwdTitleLabel.snp.bottom).offset(15)
            $0.leading.trailing.equalTo(idTitleLabel)
            $0.height.equalTo(33)
        }
        
        pwdCheckTitleLabel.snp.makeConstraints {
            $0.top.equalTo(pwdTextField.snp.bottom).offset(15)
            $0.leading.trailing.equalTo(idTitleLabel)
        }
        
        pwdCheckTextField.snp.makeConstraints {
            $0.top.equalTo(pwdCheckTitleLabel.snp.bottom).offset(15)
            $0.leading.trailing.equalTo(idTitleLabel)
            $0.height.equalTo(33)
        }
        
        nicknameTitleLabel.snp.makeConstraints {
            $0.top.equalTo(pwdCheckTextField.snp.bottom).offset(15)
            $0.leading.trailing.equalTo(idTitleLabel)
        }
        
        nicknameStackView.snp.makeConstraints {
            $0.top.equalTo(nicknameTitleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(idTitleLabel)
        }
        
        nicknameCheckButton.snp.makeConstraints {
            $0.width.equalTo(80)
        }
        
        genderTitleLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameStackView.snp.bottom).offset(15)
            $0.leading.trailing.equalTo(idTitleLabel)
        }
        
        genderPicker.snp.makeConstraints {
            $0.top.equalTo(genderTitleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(idTitleLabel)
            $0.height.equalTo(120)
            $0.bottom.equalTo(contentView).offset(-30)
        }
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        view.endEditing(true)
    }
}
