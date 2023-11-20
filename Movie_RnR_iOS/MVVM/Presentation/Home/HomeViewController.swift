//
//  HomeViewController.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/08.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class HomeViewController: UIViewController {
    var viewModel: HomeViewModel!
    
    private let disposeBag = DisposeBag()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        let refreshControl: UIRefreshControl = {
            let refreshControl = UIRefreshControl()
            refreshControl.tintColor = .black
            return refreshControl
        }()
        tableView.backgroundColor = UIColor(named: "mainColor")
        tableView.contentInset.top = 20
        tableView.contentInset.bottom = 20
        tableView.separatorStyle = .none
        tableView.refreshControl = refreshControl
        return tableView
    }()
    
    let rightBarButtonItem = UIBarButtonItem(systemItem: .search)
    let leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person"), style: .plain, target: nil, action: nil)
    
    let newPostButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20)
        var config = UIButton.Configuration.plain()
        config.preferredSymbolConfigurationForImage = imageConfig
        button.configuration = config
        button.tintColor = .white
        button.backgroundColor = UIColor(named: "headerColor")
        button.layer.cornerRadius = 25
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.imageView?.contentMode = .scaleToFill
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(PostCell.self, forCellReuseIdentifier: Constant.TableViewCellID.Posting)
        tableView.register(TitleCell.self, forCellReuseIdentifier: Constant.TableViewCellID.Title)
        
        bindViewModel()
        uiEvent()
        attribute()
        layout()
    }
    
    private func bindViewModel() {
        
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .map { _ in  Void()}
            .asDriver(onErrorJustReturn: Void())
    
        let pull = tableView.refreshControl!.rx
            .controlEvent(.valueChanged)
            .asDriver()
        
        let input = HomeViewModel.Input(triger: Driver.merge(viewWillAppear, pull), selection: tableView.rx.itemSelected.asDriver())
        
        let output = viewModel.transfrom(input: input)
        
        output.posts.drive(tableView.rx.items) { tv, row, post in
            let indexPath = IndexPath(row: row, section: 0)
            if row == 0 {
                let cell = TitleCellFactory().getInstance(tableView: tv, indexPath: indexPath)
                cell.viewModel.title
                    .onNext("Recent Postings")
                return cell
            } else {
                let cell = tv.dequeueReusableCell(withIdentifier: Constant.TableViewCellID.Posting, for: indexPath) as! PostCell
                let cellVM = PostCellViewModel(post)
                cell.bind(cellVM)
                return cell
            }
        }
        .disposed(by: disposeBag)
    
        output.selectedPost.drive(onNext: { post in
            let vc = DetailFactory().getInstance(post: post)
            self.navigationController?.pushViewController(vc, animated: true)
        })
        .disposed(by: disposeBag)
        
        output.fetching.drive(tableView.refreshControl!.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        output.login.map { !$0 }.drive(newPostButton.rx.isHidden)
            .disposed(by: disposeBag)
        
    }
    
    private func uiEvent() {
        newPostButton.rx.tap
            .asDriver()
            .drive(onNext: {
                let vc = WritePostFactory().getInstance()
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
        
        rightBarButtonItem.rx.tap
            .subscribe(onNext: {_ in
                let vc = SearchFactory().getInstance()
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }

    
    private func attribute() {
        let appearance = UINavigationBarAppearance()
        
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "headerColor")
        appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "CarterOne", size: 20)!, .foregroundColor: UIColor.black]
        appearance.backButtonAppearance.normal.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "CarterOne", size: 15)!]
        
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.standardAppearance = appearance;
        navigationController?.navigationBar.scrollEdgeAppearance =  navigationController?.navigationBar.standardAppearance
        
        title = "MOVIE R&R 🎬"
        
        navigationItem.rightBarButtonItem = rightBarButtonItem
        navigationItem.leftBarButtonItem = leftBarButtonItem
        
        view.backgroundColor = UIColor(named: "mainColor")
        
    }
    
    
    private func layout() {
        [tableView, newPostButton].forEach {
            view.addSubview($0)
        }
        
        tableView.snp.makeConstraints{
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        newPostButton.snp.makeConstraints {
            $0.height.width.equalTo(50)
            $0.trailing.equalTo(tableView.frameLayoutGuide.snp.trailing).offset(-20)
            $0.bottom.equalTo(tableView.frameLayoutGuide.snp.bottom)
        }

    }
    
}
