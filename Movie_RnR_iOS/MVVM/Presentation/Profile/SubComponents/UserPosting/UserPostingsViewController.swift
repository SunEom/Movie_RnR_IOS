//
//  UserPostingsViewController.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/22.
//

import UIKit
import RxSwift

class UserPostingViewController: UIViewController {
    
    var viewModel: UserPostingViewModel!
    
    let disposeBag = DisposeBag()
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(TitleCell.self, forCellReuseIdentifier: Constant.TableViewCellID.Title)
        tableView.register(PostCell.self, forCellReuseIdentifier: Constant.TableViewCellID.Posting)
        
        layout()
        attribute()
        bind()
    }
    
    private func bind() {
        
        viewModel.cellData
            .drive(tableView.rx.items) { tv, row, data in
                let indexPath = IndexPath(row: row, section: 0)
                let cell = tv.dequeueReusableCell(withIdentifier: Constant.TableViewCellID.Posting, for: indexPath) as! PostCell
                cell.bind(PostCellViewModel(data))
                return cell
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .map {
                self.tableView.cellForRow(at: $0)?.isSelected = false
                return $0
            }
            .bind(to: viewModel.selectedIdx)
            .disposed(by: disposeBag)
        
        viewModel.selectedItem
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                let vc = DetailFactory().getInstance(post: $0)
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        
    }
    
    private func layout() {
        [tableView]
            .forEach {
                view.addSubview($0)
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
        
        [
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ].forEach { $0.isActive = true }
    }
    
    private func attribute() {
        view.backgroundColor = UIColor(named: "mainColor")
        tableView.backgroundColor = UIColor(named: "mainColor")
    }
    
    
}
