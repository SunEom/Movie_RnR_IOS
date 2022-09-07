//
//  CommentEditViewController.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/09/07.
//

import UIKit
import Presentr

class CommentEditViewController: UIViewController {
    
    var viewModel: CommentEditViewModel!
    
    let saveButton = UIButton()
    let contentsTextView = UITextView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        bind()
        attribute()
        layout()
        
    }
    
    private func bind() {
        
    }
    
    private func attribute() {
        view.backgroundColor = UIColor(named: "mainColor")
        
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.black, for: .normal)
        
        contentsTextView.backgroundColor = .white
        contentsTextView.textColor = .black
        contentsTextView.font = .systemFont(ofSize: 16)
    }
    
    private func layout() {
    
        [saveButton, contentsTextView]
            .forEach {
                view.addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
        
        [
            saveButton.widthAnchor.constraint(equalToConstant: 80),
            saveButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            
            contentsTextView.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 15),
            contentsTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            contentsTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            contentsTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
        ].forEach { $0.isActive = true }
    }
    
}
