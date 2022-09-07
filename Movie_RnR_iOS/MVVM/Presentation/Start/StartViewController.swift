//
//  StartViewController.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/23.
//

import UIKit
import RxSwift

class StartViewController: UIViewController {
    
    var viewModel: StartViewModel!
    
    let disposeBag = DisposeBag()
    
    let imageView = UIImageView(image: UIImage(named: "launchScreenIcon"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        attribute()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        bind()
    }
    
    private func bind() {
        
        viewModel.loginChecked
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                if $0 {
                    let vc = UINavigationController(rootViewController: HomeFactory().getInstance())
                    vc.modalPresentationStyle = .fullScreen
                    vc.modalTransitionStyle = .crossDissolve
                    self.present(vc, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    private func layout() {
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        [
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 180),
            imageView.heightAnchor.constraint(equalToConstant: 180)
        ].forEach {$0.isActive = true}
    }
    
    private func attribute() {
        view.backgroundColor = UIColor(named: "mainColor")
    }
}
