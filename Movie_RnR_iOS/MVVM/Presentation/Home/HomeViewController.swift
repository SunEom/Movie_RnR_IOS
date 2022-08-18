//
//  HomeViewController.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/08.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    let tableView = UITableView()
    let rightBarButtonItem = UIBarButtonItem(systemItem: .search)
    let leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person"), style: .plain, target: self, action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(PostCell.self, forCellReuseIdentifier: Constant.TableViewCellID.Posting)
        tableView.register(TitleCell.self, forCellReuseIdentifier: Constant.TableViewCellID.Title)
        
        layout()
        attribute()
    }
    
    func bind(_ viewModel: HomeViewModel) {
        
        viewModel.cellData
            .drive(tableView.rx.items) { tv, row, post in
                let indexPath = IndexPath(row: row, section: 0)
                if row == 0 {
                    
                    let cell = tv.dequeueReusableCell(withIdentifier: Constant.TableViewCellID.Title, for: indexPath) as! TitleCell
                    let vm = TitleCellViewModel()
                    
                    cell.bind(vm)
                    vm.title.onNext("Recent Postings")
                    
                    cell.setUp()
                    
                    return cell
                } else {
                
                    let cell = tv.dequeueReusableCell(withIdentifier: Constant.TableViewCellID.Posting, for: indexPath) as! PostCell
                    let cellVM = PostCellViewModel(post)
                    
                    cell.bind(cellVM)
                    
                    return cell
                }
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: {
                self.tableView.cellForRow(at: $0)?.isSelected = false
            })
            .disposed(by: disposeBag)
            
        rightBarButtonItem.rx.tap
            .subscribe(onNext: {_ in
                let vc = SearchViewController()
                vc.bind(viewModel.searchViewModel)
                self.navigationController?.pushViewController(vc, animated: true)
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
                let vm = DetailViewModel(post!)
                vc.bind(vm)
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        leftBarButtonItem.rx.tap
            .subscribe(onNext: {
                if UserManager.getInstance() == nil {
                    let vc = LoginViewController()
                    vc.bind(viewModel.loginViewModel)
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    let vc = ProfileViewController()
                    vc.bind(viewModel.profileViewModel)
                    viewModel.profileViewModel.userID.onNext(UserManager.getInstance()!.id)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func layout() {
        [tableView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        [
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ].forEach{ $0.isActive = true}
    }
    
    private func attribute() {
     
        let appearance = UINavigationBarAppearance()
        
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "headerColor")
        appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "CarterOne", size: 20)!]
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance;
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        title = "MOVIE R&R"
        
        navigationItem.rightBarButtonItem = rightBarButtonItem
        navigationItem.leftBarButtonItem = leftBarButtonItem
        
        view.backgroundColor = UIColor(named: "mainColor")
        
        tableView.backgroundColor = UIColor(named: "mainColor")
        tableView.contentInset.top = 20
        tableView.contentInset.bottom = 20
        tableView.separatorStyle = .none
        
    }
    
}
