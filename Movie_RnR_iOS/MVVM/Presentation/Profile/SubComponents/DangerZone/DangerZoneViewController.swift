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
                let alert = UIAlertController(title: "계정 삭제", message: "정말로 삭제하시겠습니까?", preferredStyle: .alert)
                
                let remove = UIAlertAction(title: "삭제", style: .destructive) { _ in
                    self.viewModel.confirmSelected.onNext(Void())
                }
                
                let cancel = UIAlertAction(title: "취소", style: .cancel)
                
                alert.addAction(remove)
                alert.addAction(cancel)
                
                self.present(alert, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.alert
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                let alert = UIAlertController(title: $0.0, message: $0.1, preferredStyle: .alert)
                let action = $0.0 == "성공" ? UIAlertAction(title: "확인", style: .default) { _ in
                    self.navigationController?.popToRootViewController(animated: true)
                } : UIAlertAction(title: "확인", style: .default)
                
                alert.addAction(action)
                
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
        한 번 계정을 삭제한 경우,
        더이상 되돌릴 수 없습니다.
        신중히 선택해주시기 바랍니다.
        """
        
        warnningLabel.font = .systemFont(ofSize: 20, weight: .bold)
        warnningLabel.textColor = UIColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 1)
        warnningLabel.numberOfLines = 5
        
        removeButton.backgroundColor = UIColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 1)
        removeButton.setTitle("계정 삭제", for: .normal)
        removeButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        removeButton.setTitleColor(.white, for: .normal)
    }
    
}
