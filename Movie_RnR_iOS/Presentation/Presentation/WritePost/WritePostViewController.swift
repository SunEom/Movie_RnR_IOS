//
//  WritePostViewController.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/22.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class WritePostViewController: UIViewController {
    
    private let viewModel: WritePostViewModel
    
    private let disposeBag = DisposeBag()
    
    private let saveButton = UIBarButtonItem(title: "Save", style: .done, target: nil, action: nil)
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        return label
    }()
    
    private let titleTextField = UITextField()
    
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.text = "Genres"
        return label
    }()
    
    private let genreStackView1 = UIStackView()
    private let genreStackView2 = UIStackView()
    private let genreStackView3 = UIStackView()
    private let genreStackView4 = UIStackView()
    
    private let romanceButton: UIButton = {
        let button = UIButton()
        button.setTitle("Romance", for: .normal)
        return button
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton()
        button.setTitle("Action", for: .normal)
        return button
    }()
    
    private let comedyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Comedy", for: .normal)
        return button
    }()
    
    private let historicalButton: UIButton = {
        let button = UIButton()
        button.setTitle("Historical", for: .normal)
        return button
    }()
    
    private let horrorButton: UIButton = {
        let button = UIButton()
        button.setTitle("Horror", for: .normal)
        return button
    }()
    
    private let sfButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sci-Fi", for: .normal)
        return button
    }()
    
    private let thrillerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Thriller", for: .normal)
        return button
    }()
    
    private let mysteryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Mystery", for: .normal)
        return button
    }()
    
    private let animationButton: UIButton = {
        let button = UIButton()
        button.setTitle("Animation", for: .normal)
        return button
    }()
    
    private let dramaButton: UIButton = {
        let button = UIButton()
        button.setTitle("Drama", for: .normal)
        return button
    }()
    
    private let rateLabel: UILabel = {
        let label = UILabel()
        label.text = "Rate"
        return label
    }()
    
    private let rateTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.text = "Overview"
        return label
    }()
    
    private let overviewTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .black
        textView.backgroundColor = .white
        return textView
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: "CarterOne", size: 15)
        button.setTitle("Delete Post", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemRed
        return button
    }()
    
    init(viewModel: WritePostViewModel) {
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
        let delete = PublishSubject<Void>()
        
        let input = WritePostViewModel.Input(title: titleTextField.rx.text.orEmpty.asDriver(),
                                             romanceTrigger: romanceButton.rx.tap.asDriver(),
                                             actionTrigger: actionButton.rx.tap.asDriver(),
                                             comedyTrigger: comedyButton.rx.tap.asDriver(),
                                             historicalTrigger: historicalButton.rx.tap.asDriver(),
                                             horrorTrigger: horrorButton.rx.tap.asDriver(),
                                             sfTrigger: sfButton.rx.tap.asDriver(),
                                             thrillerTrigger: thrillerButton.rx.tap.asDriver(),
                                             mysteryTrigger: mysteryButton.rx.tap.asDriver(),
                                             animationTrigger: animationButton.rx.tap.asDriver(),
                                             dramaTrigger: dramaButton.rx.tap.asDriver(),
                                             rate: rateTextField.rx.text.orEmpty.map { Double($0) ?? 0.0 }.asDriver(onErrorJustReturn: 0.0),
                                             overview: overviewTextView.rx.text.orEmpty.asDriver(),
                                             writeTrigger: saveButton.rx.tap.asDriver(),
                                             deleteTrigger: delete.asDriver(onErrorJustReturn:()))
        
        let output = viewModel.transform(input: input)
        
        if let post = output.post {
            titleTextField.rx.text.onNext(post.title)
            rateTextField.rx.text.onNext ("\(post.rates)")
            overviewTextView.rx.text.onNext(post.overview)
        }
        
        output.romance
            .drive(onNext: {[weak self] selected in
                guard let self = self else { return }
                genreButtonTap(btn: romanceButton, selected: selected)
            })
            .disposed(by: disposeBag)
        
        output.action
            .drive(onNext: {[weak self] selected in
                guard let self = self else { return }
                genreButtonTap(btn: actionButton, selected: selected)
            })
            .disposed(by: disposeBag)
        
        output.comedy
            .drive(onNext: {[weak self] selected in
                guard let self = self else { return }
                genreButtonTap(btn: comedyButton, selected: selected)
            })
            .disposed(by: disposeBag)
        
        output.historical
            .drive(onNext: {[weak self] selected in
                guard let self = self else { return }
                genreButtonTap(btn: historicalButton, selected: selected)
            })
            .disposed(by: disposeBag)
        
        output.horror
            .drive(onNext: {[weak self] selected in
                guard let self = self else { return }
                genreButtonTap(btn: horrorButton, selected: selected)
            })
            .disposed(by: disposeBag)
        
        output.sf
            .drive(onNext: {[weak self] selected in
                guard let self = self else { return }
                genreButtonTap(btn: sfButton, selected: selected)
            })
            .disposed(by: disposeBag)
        
        output.thriller
            .drive(onNext: {[weak self] selected in
                guard let self = self else { return }
                genreButtonTap(btn: thrillerButton, selected: selected)
            })
            .disposed(by: disposeBag)
        
        output.mystery
            .drive(onNext: {[weak self] selected in
                guard let self = self else { return }
                genreButtonTap(btn: mysteryButton, selected: selected)
            })
            .disposed(by: disposeBag)
        
        output.animation
            .drive(onNext: {[weak self] selected in
                guard let self = self else { return }
                genreButtonTap(btn: animationButton, selected: selected)
            })
            .disposed(by: disposeBag)
        
        output.drama
            .drive(onNext: {[weak self] selected in
                guard let self = self else { return }
                genreButtonTap(btn: dramaButton, selected: selected)
            })
            .disposed(by: disposeBag)
        
        output.result
            .drive(onNext: { [weak self] result in
                guard let self = self else { return }
                let alert: UIAlertController!

                var action: UIAlertAction!

                if result.isSuccess {
                    alert = UIAlertController(title: "성공", message: result.message, preferredStyle: .alert)
                    action = UIAlertAction(title: "확인", style: .default) { _ in
                        self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    alert = UIAlertController(title: "실패", message: result.message, preferredStyle: .alert)
                    action = UIAlertAction(title: "확인", style: .default)
                }

                alert.addAction(action)

                self.present(alert, animated: true)
            })
            .disposed(by: disposeBag)
        
        if let post = output.post {
            deleteButton.isHidden = false
        } else {
            deleteButton.isHidden = true
        }
        
        deleteButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                
                let alert = UIAlertController(title: "경고", message: "한번 삭제하면 복구할 수 없습니다.\n정말로 지우시겠습니까?", preferredStyle: .alert)
                
                let confirm = UIAlertAction(title: "삭제", style: .destructive) { _ in
                    delete.onNext(())
                }
                
                let cancel = UIAlertAction(title: "취소", style: .cancel)
                
                alert.addAction(confirm)
                alert.addAction(cancel)
                
                self.present(alert, animated: true)
            })
            .disposed(by: disposeBag)
        
        output.deletResult
            .drive(onNext: { [weak self] result in
                guard let self = self else { return }
                let alert: UIAlertController!

                var action: UIAlertAction!

                if result.isSuccess {
                    alert = UIAlertController(title: "성공", message: result.message, preferredStyle: .alert)
                    action = UIAlertAction(title: "확인", style: .default) { _ in
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                } else {
                    alert = UIAlertController(title: "실패", message: result.message, preferredStyle: .alert)
                    action = UIAlertAction(title: "확인", style: .default)
                }

                alert.addAction(action)

                self.present(alert, animated: true)
            })
            .disposed(by: disposeBag)
        
    }
    
    private func attribute() {
        view.backgroundColor = UIColor(named: "mainColor")
        
        self.navigationItem.rightBarButtonItem = saveButton
        
        [titleLabel, genreLabel, rateLabel, overviewLabel]
            .forEach {
                $0.font = .systemFont(ofSize: 20, weight: .semibold)
                $0.textColor = .black
            }
        
        [titleTextField, rateTextField]
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
        
        [genreStackView1, genreStackView2, genreStackView3, genreStackView4]
            .forEach {
                $0.distribution = .fillEqually
                $0.alignment = .fill
                $0.spacing = 5
            }
        
        [
            romanceButton,
            actionButton,
            comedyButton,
            historicalButton,
            horrorButton,
            sfButton,
            thrillerButton,
            mysteryButton,
            animationButton,
            dramaButton
        ]
            .forEach {
                $0.setTitleColor(.black, for: .normal)
                $0.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
                $0.layer.borderWidth = 1
                $0.layer.cornerRadius = 3
            }
        
        
    }
    
    private func layout() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        view.addGestureRecognizer(tap)
        
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        genreStackView1.addArrangedSubview(romanceButton)
        genreStackView1.addArrangedSubview(actionButton)
        genreStackView1.addArrangedSubview(comedyButton)
        
        genreStackView2.addArrangedSubview(historicalButton)
        genreStackView2.addArrangedSubview(horrorButton)
        genreStackView2.addArrangedSubview(sfButton)
        
        genreStackView3.addArrangedSubview(thrillerButton)
        genreStackView3.addArrangedSubview(mysteryButton)
        genreStackView3.addArrangedSubview(animationButton)
        
        genreStackView4.addArrangedSubview(dramaButton)
        genreStackView4.addArrangedSubview(UIView())
        genreStackView4.addArrangedSubview(UIView())
        
        [titleLabel, titleTextField, genreLabel, rateLabel, rateTextField, overviewLabel, overviewTextView, genreStackView1, genreStackView2, genreStackView3, genreStackView4, deleteButton]
            .forEach { contentView.addSubview($0) }
        
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.width.equalTo(scrollView)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalTo(contentView).offset(15)
            $0.trailing.equalTo(contentView).offset(-15)
        }
        
        titleTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(15)
            $0.leading.trailing.equalTo(titleLabel)
            $0.height.equalTo(40)
        }
        
        genreLabel.snp.makeConstraints {
            $0.top.equalTo(titleTextField.snp.bottom).offset(15)
            $0.leading.trailing.equalTo(titleLabel)
        }
        
        genreStackView1.snp.makeConstraints {
            $0.top.equalTo(genreLabel.snp.bottom).offset(15)
            $0.leading.trailing.equalTo(titleLabel)
        }
        
        genreStackView2.snp.makeConstraints {
            $0.top.equalTo(genreStackView1.snp.bottom).offset(15)
            $0.leading.trailing.equalTo(titleLabel)
        }
        
        genreStackView3.snp.makeConstraints {
            $0.top.equalTo(genreStackView2.snp.bottom).offset(15)
            $0.leading.trailing.equalTo(titleLabel)
        }
        
        genreStackView4.snp.makeConstraints {
            $0.top.equalTo(genreStackView3.snp.bottom).offset(15)
            $0.leading.trailing.equalTo(titleLabel)
        }
        
        rateLabel.snp.makeConstraints {
            $0.top.equalTo(genreStackView4.snp.bottom).offset(15)
            $0.leading.trailing.equalTo(titleLabel)
        }
        
        rateTextField.snp.makeConstraints {
            $0.top.equalTo(rateLabel.snp.bottom).offset(15)
            $0.leading.trailing.equalTo(titleLabel)
            $0.height.equalTo(40)
        }
        
        overviewLabel.snp.makeConstraints {
            $0.top.equalTo(rateTextField.snp.bottom).offset(15)
            $0.leading.trailing.equalTo(titleLabel)
        }
        
        overviewTextView.snp.makeConstraints {
            $0.top.equalTo(overviewLabel.snp.bottom).offset(15)
            $0.leading.trailing.equalTo(titleLabel)
            $0.height.equalTo(200)
        }
        
        deleteButton.snp.makeConstraints {
            $0.top.equalTo(overviewTextView.snp.bottom).offset(50)
            $0.leading.trailing.equalTo(titleLabel)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-15)
        }
    }
    
    private func genreButtonTap(btn: UIButton, selected: Bool){
        if selected {
            btn.backgroundColor = UIColor(named: "headerColor")
        } else {
            btn.backgroundColor = UIColor(named: "mainColor")
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        view.endEditing(true)
    }
}
