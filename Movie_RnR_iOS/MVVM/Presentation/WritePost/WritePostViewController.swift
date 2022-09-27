//
//  WritePostViewController.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/22.
//

import UIKit
import RxSwift

class WritePostViewController: UIViewController {
    
    var viewModel: WritePostViewModel!
    
    let disposeBag = DisposeBag()
    
    let saveButton = UIBarButtonItem(title: "Save", style: .done, target: nil, action: nil)
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let titleLabel = UILabel()
    let titleTextField = UITextField()
    
    let genreLabel = UILabel()
    let genreStackView1 = UIStackView()
    let genreStackView2 = UIStackView()
    let genreStackView3 = UIStackView()
    let genreStackView4 = UIStackView()
    
    let romanceButton = UIButton()
    let actionButton = UIButton()
    let comedyButton = UIButton()
    let historicalButton = UIButton()
    let horrorButton = UIButton()
    let sfButton = UIButton()
    let thrillerButton = UIButton()
    let mysteryButton = UIButton()
    let animationButton = UIButton()
    let dramaButton = UIButton()
    
    
    let rateLabel = UILabel()
    let rateTextField = UITextField()
    
    let overviewLabel = UILabel()
    let overviewTextView = UITextView()
    
    let deleteButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        attribute()
        bind()
        
    }
    
    private func bind() {
        // 게시글 수정인 경우 입력값을 기존값으로 초기화
        viewModel.title
            .take(1)
            .bind(to: titleTextField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.romance
            .take(1)
            .subscribe(onNext:{
                if $0 {
                    _ = self.genreButtonTap(btn: self.romanceButton)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.action
            .take(1)
            .subscribe(onNext:{
                if $0 {
                    _ = self.genreButtonTap(btn: self.actionButton)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.comedy
            .take(1)
            .subscribe(onNext:{
                if $0 {
                    _ = self.genreButtonTap(btn: self.comedyButton)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.historical
            .take(1)
            .subscribe(onNext:{
                if $0 {
                    _ = self.genreButtonTap(btn: self.historicalButton)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.horror
            .take(1)
            .subscribe(onNext:{
                if $0 {
                    _ = self.genreButtonTap(btn: self.horrorButton)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.sf
            .take(1)
            .subscribe(onNext:{
                if $0 {
                    _ = self.genreButtonTap(btn: self.sfButton)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.thriller
            .take(1)
            .subscribe(onNext:{
                if $0 {
                    _ = self.genreButtonTap(btn: self.thrillerButton)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.mystery
            .take(1)
            .subscribe(onNext:{
                if $0 {
                    _ = self.genreButtonTap(btn: self.mysteryButton)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.animation
            .take(1)
            .subscribe(onNext:{
                if $0 {
                    _ = self.genreButtonTap(btn: self.animationButton)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.drama
            .take(1)
            .subscribe(onNext:{
                if $0 {
                    _ = self.genreButtonTap(btn: self.dramaButton)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.rate
            .take(1)
            .map { "\($0)" }
            .bind(to: rateTextField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.overview
            .take(1)
            .bind(to: overviewTextView.rx.text)
            .disposed(by: disposeBag)
        
        
        titleTextField.rx.text
            .map { $0 ?? "" }
            .bind(to: viewModel.title)
            .disposed(by: disposeBag)
        
        //genre buttons
        romanceButton.rx.tap
            .map {self.genreButtonTap(btn: self.romanceButton)}
            .bind(to: viewModel.romance)
            .disposed(by: disposeBag)
        
        actionButton.rx.tap
            .map {self.genreButtonTap(btn: self.actionButton)}
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)
        
        comedyButton.rx.tap
            .map {self.genreButtonTap(btn: self.comedyButton)}
            .bind(to: viewModel.comedy)
            .disposed(by: disposeBag)
        
        historicalButton.rx.tap
            .map {self.genreButtonTap(btn: self.historicalButton)}
            .bind(to: viewModel.historical)
            .disposed(by: disposeBag)
        
        horrorButton.rx.tap
            .map {self.genreButtonTap(btn: self.horrorButton)}
            .bind(to: viewModel.horror)
            .disposed(by: disposeBag)
        
        sfButton.rx.tap
            .map {self.genreButtonTap(btn: self.sfButton)}
            .bind(to: viewModel.sf)
            .disposed(by: disposeBag)
        
        thrillerButton.rx.tap
            .map {self.genreButtonTap(btn: self.thrillerButton)}
            .bind(to: viewModel.thriller)
            .disposed(by: disposeBag)
        
        mysteryButton.rx.tap
            .map {self.genreButtonTap(btn: self.mysteryButton)}
            .bind(to: viewModel.mystery)
            .disposed(by: disposeBag)
        
        animationButton.rx.tap
            .map {self.genreButtonTap(btn: self.animationButton)}
            .bind(to: viewModel.animation)
            .disposed(by: disposeBag)
        
        dramaButton.rx.tap
            .map {self.genreButtonTap(btn: self.dramaButton)}
            .bind(to: viewModel.drama)
            .disposed(by: disposeBag)
        
        rateTextField.rx.text
            .map { Double($0!) ?? 0.0 }
            .bind(to: viewModel.rate)
            .disposed(by: disposeBag)
        
        overviewTextView.rx.text
            .map { $0 ?? "" }
            .bind(to: viewModel.overview)
            .disposed(by: disposeBag)
        
        saveButton.rx.tap
            .bind(to: viewModel.saveButtonTap)
            .disposed(by: disposeBag)
        
        viewModel.writePostRequestResult
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { result in
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
        
        deleteButton.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                
                guard let self = self else { return }
                
                let alert = UIAlertController(title: "경고", message: "한번 삭제하면 복구할 수 없습니다.\n정말로 지우시겠습니까?", preferredStyle: .alert)
                
                let confirm = UIAlertAction(title: "삭제", style: .destructive) { _ in
                    self.viewModel.deleteRequest.onNext(Void())
                }
                
                let cancel = UIAlertAction(title: "취소", style: .cancel)
                
                alert.addAction(confirm)
                alert.addAction(cancel)
                
                self.present(alert, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.deletePostRequestResult
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { result in
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
    
    private func layout() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        view.addGestureRecognizer(tap)
        
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
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
            .forEach {
                contentView.addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
        
        [
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            titleTextField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            titleTextField.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            titleTextField.heightAnchor.constraint(equalToConstant: 40),
            
            genreLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 15),
            genreLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            genreLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            genreStackView1.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: 15),
            genreStackView1.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            genreStackView1.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            genreStackView2.topAnchor.constraint(equalTo: genreStackView1.bottomAnchor, constant: 15),
            genreStackView2.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            genreStackView2.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            genreStackView3.topAnchor.constraint(equalTo: genreStackView2.bottomAnchor, constant: 15),
            genreStackView3.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            genreStackView3.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            genreStackView4.topAnchor.constraint(equalTo: genreStackView3.bottomAnchor, constant: 15),
            genreStackView4.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            genreStackView4.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            rateLabel.topAnchor.constraint(equalTo: genreStackView4.bottomAnchor, constant: 15),
            rateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            rateLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            rateTextField.topAnchor.constraint(equalTo: rateLabel.bottomAnchor, constant: 15),
            rateTextField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            rateTextField.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            rateTextField.heightAnchor.constraint(equalToConstant: 40),
            
            overviewLabel.topAnchor.constraint(equalTo: rateTextField.bottomAnchor, constant: 15),
            overviewLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            overviewLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            overviewTextView.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 15),
            overviewTextView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            overviewTextView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            overviewTextView.heightAnchor.constraint(equalToConstant: 200),
            
            deleteButton.topAnchor.constraint(equalTo: overviewTextView.bottomAnchor,constant: 50),
            deleteButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            contentView.bottomAnchor.constraint(equalTo: deleteButton.bottomAnchor, constant: 15 )
            
        ].forEach { $0.isActive = true }
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
        
        overviewTextView.textColor = .black
        overviewTextView.backgroundColor = .white
        
        
        titleLabel.text = "Title"
        genreLabel.text = "Genres"
        rateLabel.text = "Rate"
        overviewLabel.text = "Overview"
        
        rateTextField.keyboardType = .numberPad
        rateTextField.delegate = self
        
        romanceButton.setTitle("Romance", for: .normal)
        actionButton.setTitle("Action", for: .normal)
        comedyButton.setTitle("Comedy", for: .normal)
        historicalButton.setTitle("Historical", for: .normal)
        horrorButton.setTitle("Horror", for: .normal)
        sfButton.setTitle("Sci-Fi", for: .normal)
        thrillerButton.setTitle("Thriller", for: .normal)
        mysteryButton.setTitle("Mystery", for: .normal)
        animationButton.setTitle("Animation", for: .normal)
        dramaButton.setTitle("Drama", for: .normal)
        
        
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
        
        
        deleteButton.isHidden = viewModel.post == nil
        deleteButton.titleLabel?.font = UIFont(name: "CarterOne", size: 15)
        deleteButton.setTitle("Delete Post", for: .normal)
        deleteButton.setTitleColor(.white, for: .normal)
        deleteButton.backgroundColor = .systemRed
    }
    
    private func genreButtonTap(btn: UIButton) -> Bool {
        btn.isSelected.toggle()
        btn.backgroundColor = btn.isSelected ? UIColor(named: "headerColor") : UIColor(named: "mainColor")
        return btn.isSelected
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        view.endEditing(true)
    }
}

extension WritePostViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits.union(CharacterSet(charactersIn: "."))
        let characterSet = CharacterSet(charactersIn: string)
        
        return allowedCharacters.isSuperset(of: characterSet) && !(string == "." && rateTextField.text!.contains(".")) && (rateTextField.text! == "" || Double(rateTextField.text! + string)! <= 10 && (rateTextField.text!.count <= 2 || strcmp(string, "\\b") == -92 ))
    }
}
