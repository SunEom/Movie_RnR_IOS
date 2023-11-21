//
//  EditProfileViewController.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/19.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class EditProfileViewController: UIViewController {
    
    private let viewModel: EditProfileViewModel
    
    let disposeBag = DisposeBag()
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let nicknameTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Nickname"
        return label
    }()
    
    let nicknameStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        return stackView
    }()
    
    let nicknameTextField = UITextField()
    let nicknameCheckButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "headerColor")
        button.setTitle("Check", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
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
    
    let biographyTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Biography"
        return label
    }()
    
    let biographyTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .black
        textView.backgroundColor = .white
        return textView
    }()
    
    let fbTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Facebook"
        return label
    }()
    let fbTextField = UITextField()
    
    let igTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Instagram"
        return label
    }()
    let igTextField = UITextField()
    
    let ttTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Twitter"
        return label
    }()
    let ttTextField = UITextField()
    
    let saveButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.title = "Save"
        return button
    }()
    
    init(viewModel: EditProfileViewModel!) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        attribute()
        layout()
    }
    
    private func bindViewModel() {
        
        let input = EditProfileViewModel.Input(nickCheckTrigger: nicknameCheckButton.rx.tap.asDriver(),
                                               nickname: nicknameTextField.rx.text.orEmpty.asDriver(),
                                               genderIdx: genderPicker.rx.itemSelected.map { $0.row }.asDriver(onErrorJustReturn: 0),
                                               biography: biographyTextView.rx.text.orEmpty.asDriver(),
                                               facebook: fbTextField.rx.text.orEmpty.asDriver(),
                                               instagram: igTextField.rx.text.orEmpty.asDriver(),
                                               twiiter: ttTextField.rx.text.orEmpty.asDriver(),
                                               updateTrigger: saveButton.rx.tap.asDriver())
        
        let output = viewModel.transform(input: input)
        
        output.genderList
            .drive(genderPicker.rx.itemTitles) { idx, title in
                return title
            }
            .disposed(by: disposeBag)
        
        UserManager.getInstance()
            .filter { $0 != nil }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] user in
                guard let user = user, let self = self else { return }
                
                self.nicknameTextField.rx.text.onNext(user.nickname)
                
                var row = 0
                switch user.gender {
                    case "None":
                        row = 0
                    case "Man":
                        row = 1
                    case "Woman":
                        row = 2
                    default:
                        row = 0
                }
                self.genderPicker.selectRow(row, inComponent: 0, animated: false)
                
                self.biographyTextView.rx.text.onNext(user.biography)
                self.fbTextField.rx.text.onNext(user.facebook)
                self.igTextField.rx.text.onNext(user.instagram)
                self.ttTextField.rx.text.onNext(user.twitter)
            })
            .disposed(by: disposeBag)

        output.updateResult
            .drive(onNext: { result in
                if result.isSuccess {
                    let alert = UIAlertController(title: "성공", message: "정상적으로 수정되었습니다.", preferredStyle: .alert)

                    let action = UIAlertAction(title: "OK", style: .default) { _ in
                        self.navigationController?.popViewController(animated: true)
                    }

                    alert.addAction(action)

                    self.present(alert, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        output.nickCheckResult
            .drive(onNext: { result in
                let alert = UIAlertController(title: result.isSuccess ? "성공" : "실패", message: result.message ?? "", preferredStyle: .alert)

                let action = UIAlertAction(title: "OK", style: .default)

                alert.addAction(action)

                self.present(alert, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        view.backgroundColor = UIColor(named: "mainColor")
        self.navigationItem.rightBarButtonItem = saveButton

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
        
    }
    
    private func layout() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        view.addGestureRecognizer(tap)
    
        
        // ScrollView Layout
        view.addSubview(scrollView)
        
        nicknameStackView.addArrangedSubview(nicknameTextField)
        nicknameStackView.addArrangedSubview(nicknameCheckButton)
        
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
            contentView.addSubview($0)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.width.equalTo(scrollView)
        }
        
        nicknameTitleLabel.snp.makeConstraints{
            $0.top.leading.equalTo(contentView).offset(15)
            $0.trailing.equalTo(contentView).offset(-15)
        }
        
        nicknameStackView.snp.makeConstraints {
            $0.top.equalTo(nicknameTitleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(nicknameTitleLabel)
        }
        
        nicknameCheckButton.snp.makeConstraints {
            $0.width.equalTo(80)
        }
        
        genderTitleLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameStackView.snp.bottom).offset(15)
            $0.leading.trailing.equalTo(nicknameTitleLabel)
        }
        
        genderPicker.snp.makeConstraints {
            $0.top.equalTo(genderTitleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(nicknameTitleLabel)
            $0.height.equalTo(120)
        }
        
        biographyTitleLabel.snp.makeConstraints {
            $0.top.equalTo(genderPicker.snp.bottom).offset(15)
            $0.leading.trailing.equalTo(nicknameTitleLabel)
        }
        
        biographyTextView.snp.makeConstraints {
            $0.top.equalTo(biographyTitleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(nicknameTitleLabel)
            $0.height.equalTo(150)
        }
        
        fbTitleLabel.snp.makeConstraints {
            $0.top.equalTo(biographyTextView.snp.bottom).offset(15)
            $0.leading.trailing.equalTo(nicknameTitleLabel)
        }
        
        fbTextField.snp.makeConstraints {
            $0.top.equalTo(fbTitleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(nicknameTitleLabel)
            $0.height.equalTo(40)
        }
        
        igTitleLabel.snp.makeConstraints {
            $0.top.equalTo(fbTextField.snp.bottom).offset(15)
            $0.leading.trailing.equalTo(nicknameTitleLabel)
        }
        
        igTextField.snp.makeConstraints {
            $0.top.equalTo(igTitleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(nicknameTitleLabel)
            $0.height.equalTo(40)
        }
        
        ttTitleLabel.snp.makeConstraints {
            $0.top.equalTo(igTextField.snp.bottom).offset(15)
            $0.leading.trailing.equalTo(nicknameTitleLabel)
        }
        
        ttTextField.snp.makeConstraints {
            $0.top.equalTo(ttTitleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(nicknameTitleLabel)
            $0.height.equalTo(40)
            $0.bottom.equalTo(contentView)
        }
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        view.endEditing(true)
    }
}
