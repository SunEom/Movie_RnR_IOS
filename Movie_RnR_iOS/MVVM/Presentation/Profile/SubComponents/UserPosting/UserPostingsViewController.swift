//
//  UserPostingsViewController.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/22.
//

import UIKit
import RxSwift
import SnapKit

final class UserPostingViewController: UIViewController {
    
    private let viewModel: UserPostingViewModel
    
    private let disposeBag = DisposeBag()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor(named: "mainColor")
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "작성된 게시글이 없습니다."
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    init(viewModel: UserPostingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(TitleCell.self, forCellReuseIdentifier: Constant.TableViewCellID.Title)
        tableView.register(PostCell.self, forCellReuseIdentifier: Constant.TableViewCellID.Posting)
        
        layout()
        attribute()
        bindViewModel()
    }
    
    private func bindViewModel() {
        
        let input = UserPostingViewModel.Input(selected: tableView.rx.itemSelected.asDriver())
        
        let output = viewModel.transform(input: input)
        
        output.posts
            .map { $0.count != 0 }
            .drive(infoLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.posts
            .drive(tableView.rx.items) { tv, row, data in
                let indexPath = IndexPath(row: row, section: 0)
                let cell = tv.dequeueReusableCell(withIdentifier: Constant.TableViewCellID.Posting, for: indexPath) as! PostCell
                cell.setUp(viewModel: PostCellViewModel(data))
                return cell
            }
            .disposed(by: disposeBag)
        
        output.selectedPost
            .drive(onNext: { post in
                let vc = DetailFactory().getInstance(post: post)
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        
    }
    
    private func layout() {
        [tableView, infoLabel].forEach { view.addSubview($0) }
        
        tableView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalTo(view)
        }
        
        infoLabel.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalTo(view)
        }
    }
    
    private func attribute() {
        view.backgroundColor = UIColor(named: "mainColor")
    }
    
    
}
