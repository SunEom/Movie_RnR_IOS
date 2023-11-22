//
//  SearchViewController.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/08.
//

import UIKit
import RxSwift
import SnapKit

final class SearchViewController: UIViewController {
    private var viewModel: SearchViewModel!
    
    private let disposeBag = DisposeBag()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.backgroundColor = UIColor(named: "mainColor")
        searchBar.barTintColor = UIColor(named: "mainColor")
        searchBar.searchTextField.textColor = .black
        searchBar.placeholder = "Search..."
        return searchBar
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PostCell.self, forCellReuseIdentifier: Constant.TableViewCellID.Posting)
        tableView.backgroundColor = UIColor(named: "mainColor")
        tableView.separatorStyle = .none
        return tableView
    }()
    
    init(viewModel: SearchViewModel!) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        uiEvent()
        layout()
    }
    
    private func bindViewModel() {
        let input = SearchViewModel.Input(keyword: searchBar.searchTextField.rx.text.orEmpty.asDriver(),
                                          selection: tableView.rx.itemSelected.asDriver())
        
        let output = viewModel.transfrom(input: input)
        
        output.posts.drive(tableView.rx.items) {tv, row, post in
            let indexPath = IndexPath(row: row, section: 0)
            let cell = tv.dequeueReusableCell(withIdentifier: Constant.TableViewCellID.Posting, for: indexPath) as! PostCell
            let cellVM = PostCellViewModel(post)
            cell.setUp(viewModel: cellVM)
            return cell
        }
        .disposed(by: disposeBag)
        
        output.selected
            .drive(onNext: { post in
                let vc = DetailViewController(viewModel: DetailViewModel(post))
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        
    }
    
    private func uiEvent() {
        searchBar.rx.searchButtonClicked
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.searchBar.endEditing(true)
            })
            .disposed(by: disposeBag)
    }
    
    private func layout() {
        
        [searchBar, tableView].forEach{
            view.addSubview($0)
        }
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.trailing.equalTo(searchBar)
            $0.bottom.equalToSuperview()
        }
    
    }
    
}
