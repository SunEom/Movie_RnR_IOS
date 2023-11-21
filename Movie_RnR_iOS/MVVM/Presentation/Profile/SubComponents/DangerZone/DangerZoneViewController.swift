//
//  DangerZoneViewController.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/22.
//

import UIKit
import RxSwift

class DangerZoneViewController: UIViewController {
    
    private let viewModel: DangerZoneViewModel
    
    private let disposeBag = DisposeBag()
    
    private let warnningLabel: UILabel = {
        let label = UILabel()
        label.text = """
        한 번 계정을 삭제한 경우,
        더이상 되돌릴 수 없습니다.
        신중히 선택해주시기 바랍니다.
        """
        
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = UIColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 1)
        label.numberOfLines = 5
        return label
    }()
    
    private let removeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 1)
        button.setTitle("계정 삭제", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    init(viewModel: DangerZoneViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        layout()
        attribute()
    }
    
    private func bindViewModel() {
        let confirmTap = PublishSubject<Void>()
        
        let input = DangerZoneViewModel.Input(trigger: confirmTap.asDriver(onErrorJustReturn: Void()))
        
        let output = viewModel.transform(input: input)
        
        removeButton.rx.tap.asDriver()
            .drive(onNext: {
                let alert = UIAlertController(title: "계정 삭제", message: "정말로 삭제하시겠습니까?", preferredStyle: .alert)
                
                let remove = UIAlertAction(title: "삭제", style: .destructive) { _ in
                    confirmTap.onNext(Void())
                }
                
                let cancel = UIAlertAction(title: "취소", style: .cancel)
                
                alert.addAction(remove)
                alert.addAction(cancel)
                
                self.present(alert, animated: true)
            })
            .disposed(by: disposeBag)
        
        output.result
            .drive(onNext: {
                if $0.isSuccess {
                    let alert = UIAlertController(title: "알림", message: "그 동안 이용해주셔서 감사합니다.", preferredStyle: .alert)
                    let action = UIAlertAction(title: "확인", style: .default) { _ in
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                    
                    alert.addAction(action)
                    
                    self.present(alert, animated: true)
                } else {
                    let alert = UIAlertController(title: "실패", message: $0.message ?? "", preferredStyle: .alert)
                    let action = UIAlertAction(title: "확인", style: .default)
                    
                    alert.addAction(action)
                    
                    self.present(alert, animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func layout() {
        [warnningLabel, removeButton].forEach { view.addSubview($0) }
        
        warnningLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(15)
            $0.leading.equalTo(view).offset(15)
            $0.trailing.equalTo(view).offset(-15)
        }
        
        removeButton.snp.makeConstraints {
            $0.top.equalTo(warnningLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(warnningLabel)
        }
    }
    
    private func attribute() {
        view.backgroundColor = UIColor(named: "mainColor")
    }
    
}
