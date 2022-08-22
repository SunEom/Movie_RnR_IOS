//
//  DangerZoneViewController.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/22.
//

import UIKit
import RxSwift

class DangerZoneViewController: UIViewController {
    
    var viewModel: DangerZoneViewModel!
    
    let disposeBag = DisposeBag()
    
    let warnningLabel = UILabel()
    let removeButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        layout()
        attribute()
    }
    
    private func bind() {
        removeButton.rx.tap
            .bind(to: viewModel.buttonSelected)
            .disposed(by: disposeBag)
        
        viewModel.buttonSelected
            .subscribe(onNext: {
                let alert = UIAlertController(title: "Remove Account", message: "Are you sure?", preferredStyle: .alert)
                
                let remove = UIAlertAction(title: "Remove", style: .destructive) { _ in
                    self.viewModel.confirmSelected.onNext(Void())
                }
                
                let cancel = UIAlertAction(title: "Cancel", style: .cancel)
                
                alert.addAction(remove)
                alert.addAction(cancel)
                
                self.present(alert, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func layout() {
        [warnningLabel, removeButton]
            .forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview($0)
            }
        
        [
            warnningLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            warnningLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            warnningLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            
            removeButton.topAnchor.constraint(equalTo: warnningLabel.bottomAnchor, constant: 20),
            removeButton.leadingAnchor.constraint(equalTo: warnningLabel.leadingAnchor),
            removeButton.trailingAnchor.constraint(equalTo: warnningLabel.trailingAnchor)
        ].forEach { $0.isActive = true}
    }
    
    private func attribute() {
        view.backgroundColor = UIColor(named: "mainColor")
        
        warnningLabel.text = """
        Once you delete your account,
        there is no going back. Please be certain
        """
        warnningLabel.textColor = .red
        warnningLabel.numberOfLines = 5
        
        removeButton.backgroundColor = .red
        removeButton.setTitle("Remove Account", for: .normal)
        removeButton.setTitleColor(.white, for: .normal)
    }
    
}
