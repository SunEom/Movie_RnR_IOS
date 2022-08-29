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
    var viewModel: HomeViewModel!
    
    let disposeBag = DisposeBag()
    
    let tableView = UITableView()
    let rightBarButtonItem = UIBarButtonItem(systemItem: .search)
    let leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person"), style: .plain, target: nil, action: nil)
    
    let refreshControl = UIRefreshControl()
    
    let newPostButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(PostCell.self, forCellReuseIdentifier: Constant.TableViewCellID.Posting)
        tableView.register(TitleCell.self, forCellReuseIdentifier: Constant.TableViewCellID.Title)
        
        layout()
        attribute()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.refresh.onNext(Void())
    }
    
    private func bind() {
        
        viewModel.cellData
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items) { tv, row, post in
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
                let vc = SearchFactory().getInstance()
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
                let vc = DetailFactory().getInstance(post: post!)
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        leftBarButtonItem.rx.tap
            .withLatestFrom(UserManager.getInstance())
            .subscribe(onNext: {
                if $0 == nil {
                    let vc = LoginFactory().getInstance()
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    let vc = ProfileFactory().getInstance(userID: $0!.id)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        newPostButton.rx.tap
            .bind(to: viewModel.newPostButtonTap)
            .disposed(by: disposeBag)
        
        viewModel.newPostButtonTap
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                let vc = WritePostFactory().getInstance()
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        UserManager.getInstance()
            .map{ $0 == nil }
            .bind(to: newPostButton.rx.isHidden)
            .disposed(by: disposeBag)
        
    }
    
    private func layout() {
        [tableView, newPostButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        [
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            newPostButton.heightAnchor.constraint(equalToConstant: 80),
            newPostButton.widthAnchor.constraint(equalToConstant: 80),
            newPostButton.trailingAnchor.constraint(equalTo: tableView.frameLayoutGuide.trailingAnchor, constant: -20),
            newPostButton.bottomAnchor.constraint(equalTo: tableView.frameLayoutGuide.bottomAnchor),
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
        title = "MOVIE R&R 🎬"
        
        navigationItem.rightBarButtonItem = rightBarButtonItem
        navigationItem.leftBarButtonItem = leftBarButtonItem
        
        view.backgroundColor = UIColor(named: "mainColor")
        
        tableView.backgroundColor = UIColor(named: "mainColor")
        tableView.contentInset.top = 20
        tableView.contentInset.bottom = 20
        tableView.separatorStyle = .none
        
        newPostButton.backgroundColor = UIColor(named: "headerColor")
        newPostButton.layer.cornerRadius = 40
        newPostButton.setImage(UIImage(systemName: "pencil"), for: .normal)
        newPostButton.imageView?.contentMode = .scaleToFill
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20)
        var config = UIButton.Configuration.plain()
        config.preferredSymbolConfigurationForImage = imageConfig
        newPostButton.configuration = config
        newPostButton.tintColor = .white
        
        refreshControl.tintColor = .black
        refreshControl.addTarget(self, action: #selector(sendRefreshSignal), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
    }
    
    @objc private func sendRefreshSignal() {
        viewModel.refresh.onNext(Void())
        refreshControl.endRefreshing()
    }
    
}
