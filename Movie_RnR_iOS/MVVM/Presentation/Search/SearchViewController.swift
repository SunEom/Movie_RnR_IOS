//
//  SearchViewController.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/08.
//

import UIKit
import RxSwift

final class SearchViewController: UIViewController {
    var viewModel: SearchViewModel!
    
    let disposeBag = DisposeBag()
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.backgroundColor = UIColor(named: "mainColor")
        searchBar.barTintColor = UIColor(named: "mainColor")
        searchBar.searchTextField.textColor = .black
        searchBar.placeholder = "Search..."
        return searchBar
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PostCell.self, forCellReuseIdentifier: Constant.TableViewCellID.Posting)
        tableView.backgroundColor = UIColor(named: "mainColor")
        tableView.separatorStyle = .none
        return tableView
    }()
    
    
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
            cell.bind(cellVM)
            return cell
        }
        .disposed(by: disposeBag)
        
        output.selected
            .drive(onNext: { post in
                let vc = DetailViewController()
                vc.viewModel = DetailViewModel(post)
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
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 40),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: searchBar.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: searchBar.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
        ].forEach{ $0.isActive = true }
    }
    
}
