//
//  StartViewController.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/23.
//

import UIKit
import RxSwift
import SnapKit

class StartViewController: UIViewController {
    
    private var viewModel: StartViewModel!
    
    let disposeBag = DisposeBag()
    
    let imageView = UIImageView(image: UIImage(named: "launchScreenIcon"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        attribute()
        bindViewModel()
    }
    
    init(viewModel: StartViewModel!) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func bindViewModel() {
        
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .map { _ in  Void()}
            .asDriver(onErrorJustReturn: Void())
    
        let input = StartViewModel.Input(trigger: viewWillAppear)
        
        let output = viewModel.transfrom(input: input)
        
        output.loginCheckFin.drive(onNext: {
            let vc = UINavigationController(rootViewController: HomeFactory().getInstance())
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true)
        })
        .disposed(by: disposeBag)
        
    }
    
    private func attribute() {
        view.backgroundColor = UIColor(named: "mainColor")
    }
    
    private func layout() {
        view.addSubview(imageView)
        
        imageView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.height.width.equalTo(180)
        }

    }
    
}
