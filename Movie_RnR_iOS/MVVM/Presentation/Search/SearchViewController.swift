//
//  SearchViewController.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/08.
//

import UIKit
import RxSwift

class SearchViewController: UIViewController {
    var viewModel: SearchViewModel!
    
    let disposeBag = DisposeBag()
    let tableView = UITableView()
    let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(PostCell.self, forCellReuseIdentifier: Constant.TableViewCellID.Posting)
        
        searchBarSetting()
        layout()
        attribute()
        bind()
    }
    
    private func bind() {
        searchBar.searchTextField.rx.text
            .bind(to: viewModel.keyword)
            .disposed(by: disposeBag)
        
        viewModel.cellData
            .drive(tableView.rx.items) { tv, row, post in
                let indexPath = IndexPath(row: row, section: 0)
                let cell = tv.dequeueReusableCell(withIdentifier: Constant.TableViewCellID.Posting, for: indexPath) as! PostCell
                let cellVM = PostCellViewModel(post)
                
                cell.bind(cellVM)
                
                return cell
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: {
                self.tableView.cellForRow(at: $0)?.isSelected = false
            })
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .map { indexPath -> Int in
                indexPath.row
            }
            .bind(to: viewModel.itemSelected)
            .disposed(by: disposeBag)
        
        viewModel.selectedItem
            .drive(onNext: { post in
                let vc = DetailViewController()
                vc.viewModel = DetailViewModel(post!)
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func layout() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        view.addGestureRecognizer(tap)
        
        [tableView].forEach{
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.topAnchor.constraint(equalTo: tableView.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 40)
        ].forEach{ $0.isActive = true }
    }
    
    private func attribute() {
        
        searchBar.backgroundColor = UIColor(named: "mainColor")
        tableView.backgroundColor = UIColor(named: "mainColor")
        
        searchBar.barTintColor = UIColor(named: "mainColor")
        searchBar.searchTextField.textColor = .black
        
        tableView.separatorStyle = .none
    }
    
    private func searchBarSetting() {
        searchBar.placeholder = "Search..."
        searchBar.sizeToFit()
        tableView.tableHeaderView = searchBar
    }
    
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        view.endEditing(true)
    }
}
