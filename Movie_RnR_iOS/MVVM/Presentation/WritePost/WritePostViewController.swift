//
//  WritePostViewController.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/22.
//

import UIKit

class WritePostViewController: UIViewController {
    var viewModel: WritePostViewModel!
    
    let saveButton = UIBarButtonItem(title: "Save", style: .done, target: nil, action: nil)
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let titleLabel = UILabel()
    let titleTextField = UITextField()
    
    let genreLabel = UILabel()

    let rateLabel = UILabel()
    let rateTextField = UITextField()
    
    let overviewLabel = UILabel()
    let overviewTextView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        layout()
        attribute()
    }
    
    private func bind() {
        
    }
    
    private func layout() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        [titleLabel, titleTextField, genreLabel, rateLabel, rateTextField, overviewLabel, overviewTextView]
            .forEach {
                contentView.addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
        
        [
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
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
            
            rateLabel.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: 15),
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
        genreLabel.text = "Genre"
        rateLabel.text = "Rate"
        overviewLabel.text = "Overview"
        
    }
}
