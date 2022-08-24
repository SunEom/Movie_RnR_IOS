//
//  EditProfileViewController.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/19.
//

import UIKit
import RxSwift
import RxCocoa

class EditProfileViewController: UIViewController {
    
    var viewModel : EditProfileViewModel!
    
    let disposeBag = DisposeBag()
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let nicknameTitleLabel = UILabel()
    let nicknameStackView = UIStackView()
    let nicknameTextField = UITextField()
    let nicknameCheckButton = UIButton()
    
    let genderTitleLabel = UILabel()
    let genderPicker = UIPickerView()
    
    let biographyTitleLabel = UILabel()
    let biographyTextView = UITextView()
    
    let fbTitleLabel = UILabel()
    let fbTextField = UITextField()
    
    let igTitleLabel = UILabel()
    let igTextField = UITextField()
    
    let ttTitleLabel = UILabel()
    let ttTextField = UITextField()
    
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
        
        saveButton.rx.tap
            .bind(to: viewModel.saveButtonTap)
            .disposed(by: disposeBag)
        
        nicknameCheckButton.rx.tap
            .bind(to: viewModel.nicknameButtonTap)
            .disposed(by: disposeBag)
        
        //TextField Initialize
        UserManager.getInstance()
            .map { $0?.nickname ?? "" }
            .bind(to: nicknameTextField.rx.text)
            .disposed(by: disposeBag)
        
        UserManager.getInstance()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                var row = 0
                
                switch $0?.gender ?? "None" {
                case "None":
                    row = 0
                case "Man":
                    row = 1
                case "Woman":
                    row = 2
                default:
                    row = 0
                }
                
                self.genderPicker.selectRow(row, inComponent: 0, animated: true)
            })
            .disposed(by: disposeBag)
        
        UserManager.getInstance()
            .map { $0?.biography ?? "" }
            .bind(to: biographyTextView.rx.text)
            .disposed(by: disposeBag)
        
        UserManager.getInstance()
            .map { $0?.facebook ?? "" }
            .bind(to: fbTextField.rx.text)
            .disposed(by: disposeBag)
        
        UserManager.getInstance()
            .map { $0?.instagram ?? "" }
            .bind(to: igTextField.rx.text)
            .disposed(by: disposeBag)
        
        UserManager.getInstance()
            .map { $0?.twitter ?? "" }
            .bind(to: ttTextField.rx.text)
            .disposed(by: disposeBag)
        
        // 수정사항 bind
        
        nicknameTextField.rx.text
            .compactMap { $0 ?? ""}
            .bind(to: viewModel.nickname)
            .disposed(by: disposeBag)
        
        genderPicker.rx.itemSelected
            .compactMap { $0.row }
            .bind(to: viewModel.genderIdx)
            .disposed(by: disposeBag)
        
        biographyTextView.rx.text
            .compactMap { $0 ?? ""}
            .bind(to: viewModel.biography)
            .disposed(by: disposeBag)
        
        fbTextField.rx.text
            .compactMap { $0 ?? ""}
            .bind(to: viewModel.facebook)
            .disposed(by: disposeBag)
        
        igTextField.rx.text
            .compactMap { $0 ?? ""}
            .bind(to: viewModel.instagram)
            .disposed(by: disposeBag)
        
        ttTextField.rx.text
            .compactMap { $0 ?? ""}
            .bind(to: viewModel.twitter)
            .disposed(by: disposeBag)
        
        // 정보 변경 확인
        
        viewModel.saveButtonTap
            .withLatestFrom(UserManager.getInstance())
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { _ in
                let alert = UIAlertController(title: "Update", message: "Updated Successfully", preferredStyle: .alert)

                let action = UIAlertAction(title: "OK", style: .default) { _ in
                    self.navigationController?.popViewController(animated: true)
                }

                alert.addAction(action)

                self.present(alert, animated: true)
            })
            .disposed(by: disposeBag)

        // Alert
        
        viewModel.nickAlert
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { (title, message) in
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                
                let action = UIAlertAction(title: "OK", style: .default)
                
                alert.addAction(action)
                
                self.present(alert, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        view.backgroundColor = UIColor(named: "mainColor")
        
        self.navigationItem.rightBarButtonItem = saveButton
        saveButton.title = "Save"
        
        nicknameStackView.addArrangedSubview(nicknameTextField)
        nicknameStackView.addArrangedSubview(nicknameCheckButton)
        nicknameStackView.alignment = .fill
        nicknameStackView.distribution = .fillProportionally
        nicknameStackView.spacing = 10
        
        nicknameCheckButton.backgroundColor = UIColor(named: "headerColor")
        nicknameCheckButton.setTitle("Check", for: .normal)
        nicknameCheckButton.setTitleColor(.white, for: .normal)
        
        nicknameTitleLabel.text = "Nickname"
        genderTitleLabel.text = "Gender"
        biographyTitleLabel.text = "Biography"
        fbTitleLabel.text = "Facebook"
        igTitleLabel.text = "Instagram"
        ttTitleLabel.text = "Twitter"
        
        [nicknameTitleLabel, genderTitleLabel, biographyTitleLabel, fbTitleLabel, igTitleLabel, ttTitleLabel]
            .forEach {
                $0.textColor = .black
                $0.font = .systemFont(ofSize: 20, weight: .bold)
            }
        
        [nicknameTextField, fbTextField, igTextField, ttTextField]
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
        
        
        biographyTextView.textColor = .black
        biographyTextView.backgroundColor = .white
        
        genderPicker.setValue(UIColor.black, forKeyPath: "textColor")
    }
    
    private func layout() {
        
        // ScrollView Layout
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        [
            nicknameTitleLabel,
            nicknameStackView,
            genderTitleLabel,
            genderPicker,
            biographyTitleLabel,
            biographyTextView,
            fbTitleLabel,
            fbTextField,
            igTitleLabel,
            igTextField,
            ttTitleLabel,
            ttTextField,
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
            nicknameTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            nicknameTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            nicknameTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            nicknameStackView.topAnchor.constraint(equalTo: nicknameTitleLabel.bottomAnchor, constant: 10),
            nicknameStackView.leadingAnchor.constraint(equalTo: nicknameTitleLabel.leadingAnchor),
            nicknameStackView.trailingAnchor.constraint(equalTo: nicknameTitleLabel.trailingAnchor),
            
            nicknameCheckButton.widthAnchor.constraint(equalToConstant: 80),
            
            genderTitleLabel.topAnchor.constraint(equalTo: nicknameStackView.bottomAnchor, constant: 15),
            genderTitleLabel.leadingAnchor.constraint(equalTo: nicknameTitleLabel.leadingAnchor),
            genderTitleLabel.trailingAnchor.constraint(equalTo: nicknameTitleLabel.trailingAnchor),
            
            genderPicker.topAnchor.constraint(equalTo: genderTitleLabel.bottomAnchor, constant: 10),
            genderPicker.leadingAnchor.constraint(equalTo: nicknameTitleLabel.leadingAnchor ),
            genderPicker.trailingAnchor.constraint(equalTo: nicknameTitleLabel.trailingAnchor),
            genderPicker.heightAnchor.constraint(equalToConstant: 120),
            
            biographyTitleLabel.topAnchor.constraint(equalTo: genderPicker.bottomAnchor, constant: 15),
            biographyTitleLabel.leadingAnchor.constraint(equalTo: nicknameTitleLabel.leadingAnchor),
            biographyTitleLabel.trailingAnchor.constraint(equalTo: nicknameTitleLabel.trailingAnchor),
            
            biographyTextView.topAnchor.constraint(equalTo: biographyTitleLabel.bottomAnchor, constant: 10),
            biographyTextView.leadingAnchor.constraint(equalTo: nicknameTitleLabel.leadingAnchor),
            biographyTextView.trailingAnchor.constraint(equalTo: nicknameTitleLabel.trailingAnchor),
            biographyTextView.heightAnchor.constraint(equalToConstant: 150),
            
            fbTitleLabel.topAnchor.constraint(equalTo: biographyTextView.bottomAnchor, constant: 15),
            fbTitleLabel.leadingAnchor.constraint(equalTo: nicknameTitleLabel.leadingAnchor),
            fbTitleLabel.trailingAnchor.constraint(equalTo: nicknameTitleLabel.trailingAnchor),
            
            fbTextField.topAnchor.constraint(equalTo: fbTitleLabel.bottomAnchor, constant: 10),
            fbTextField.leadingAnchor.constraint(equalTo: nicknameTitleLabel.leadingAnchor),
            fbTextField.trailingAnchor.constraint(equalTo: nicknameTitleLabel.trailingAnchor),
            fbTextField.heightAnchor.constraint(equalToConstant: 40),
            
            igTitleLabel.topAnchor.constraint(equalTo: fbTextField.bottomAnchor, constant: 15),
            igTitleLabel.leadingAnchor.constraint(equalTo: nicknameTitleLabel.leadingAnchor),
            igTitleLabel.trailingAnchor.constraint(equalTo: nicknameTitleLabel.trailingAnchor),
            
            igTextField.topAnchor.constraint(equalTo: igTitleLabel.bottomAnchor, constant: 10),
            igTextField.leadingAnchor.constraint(equalTo: nicknameTitleLabel.leadingAnchor),
            igTextField.trailingAnchor.constraint(equalTo: nicknameTitleLabel.trailingAnchor),
            igTextField.heightAnchor.constraint(equalToConstant: 40),
            
            ttTitleLabel.topAnchor.constraint(equalTo: igTextField.bottomAnchor, constant: 15),
            ttTitleLabel.leadingAnchor.constraint(equalTo: nicknameTitleLabel.leadingAnchor),
            ttTitleLabel.trailingAnchor.constraint(equalTo: nicknameTitleLabel.trailingAnchor),
            
            ttTextField.topAnchor.constraint(equalTo: ttTitleLabel.bottomAnchor, constant: 10),
            ttTextField.leadingAnchor.constraint(equalTo: nicknameTitleLabel.leadingAnchor),
            ttTextField.trailingAnchor.constraint(equalTo: nicknameTitleLabel.trailingAnchor),
            ttTextField.heightAnchor.constraint(equalToConstant: 40),
            
            contentView.bottomAnchor.constraint(equalTo: ttTextField.bottomAnchor,constant: 30)
            
            
            
        ].forEach { $0.isActive = true}
        
    }
    
    
}
