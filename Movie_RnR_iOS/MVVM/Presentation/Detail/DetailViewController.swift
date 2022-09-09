//
//  DetailViewController.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/08.
//

import UIKit
import RxSwift

class DetailViewController: UIViewController {
    var viewModel: DetailViewModel!
    
    let disposeBag = DisposeBag()
    let tableView = UITableView()
    
    let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: nil, action: nil)
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.refresh.onNext(Void())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(ImageCell.self, forCellReuseIdentifier: "DetailImageCell")
        tableView.register(TitleCell.self, forCellReuseIdentifier: "TitleCell")
        tableView.register(TopStackViewCell.self, forCellReuseIdentifier: "TopStackViewCell")
        tableView.register(OverviewCell.self, forCellReuseIdentifier: "OverviewCell")
        tableView.register(BottomStackViewCell.self, forCellReuseIdentifier: "BottomStackViewCell")
        
        attribute()
        layout()
        bind()
    }
    
    private func bind() {
        
        viewModel.cellList
            .drive(tableView.rx.items) { tv, row, data in
                switch row {
                    case 0:
                        let indexPath = IndexPath(row: row, section: 0)
                        let cell = tv.dequeueReusableCell(withIdentifier: "DetailImageCell", for: indexPath) as! ImageCell
                        cell.selectionStyle = .none
                        cell.cellInit(imageName: "postImage1")
                        return cell
                        
                    case 1:
                        let indexPath = IndexPath(row: row, section: 0)
                        let cell = TitleCellFactory().getInstance(tableView: tv, indexPath: indexPath)
                        cell.selectionStyle = .none
                        
                        self.viewModel.detailData
                            .map { $0?.movie.title }
                            .bind(to: cell.viewModel.title)
                            .disposed(by: self.disposeBag)
                        
                        return cell
                        
                    case 2:
                        let indexPath = IndexPath(row: row, section: 0)
                        let cell = TopStackViewCellFactory().getInstance(tableView: tv, indexPath: indexPath)
                        cell.selectionStyle = .none
                        
                        self.viewModel.detailData
                            .map { $0?.movie.genres }
                            .bind(to: cell.viewModel.genres)
                            .disposed(by: self.disposeBag)
                        
                        self.viewModel.detailData
                            .map { "\($0?.movie.rates ?? 0.0)" }
                            .bind(to: cell.viewModel.rates)
                            .disposed(by: self.disposeBag)
                        
                        return cell
                        
                    case 3:
                        let indexPath = IndexPath(row: row, section: 0)
                        let cell = OverviewCellFactory().getInstance(tableView: tv, indexPath: indexPath)
                        cell.selectionStyle = .none
                        
                        self.viewModel.detailData
                            .map { $0?.movie.overview }
                            .bind(to: cell.viewModel.overview)
                            .disposed(by: self.disposeBag)
                        
                        return cell
                        
                    case 4:
                        let indexPath = IndexPath(row: row, section: 0)
                        let cell = BottomStackViewCellFactory().getInstance(tableView: tv, indexPath: indexPath)
                        cell.selectionStyle = .none
                        
                        self.viewModel.detailData
                            .map { $0?.user.nickname }
                            .bind(to: cell.viewModel.nickname)
                            .disposed(by: self.disposeBag)
                        
                        self.viewModel.detailData
                            .map { $0?.movie.created }
                            .bind(to: cell.viewModel.date)
                            .disposed(by: self.disposeBag)
                        
                        return cell
                        
                    case 5:
                        let cell = UITableViewCell()
                        cell.backgroundColor = .clear
                        cell.textLabel?.text = "Comments (\(self.viewModel.post.commentCount ?? 0))"
                        cell.textLabel?.font = UIFont(name: "CarterOne", size: 18)
                        cell.textLabel?.textColor = .black
                        cell.accessoryView = UIImageView(image: UIImage(systemName: "chevron.right"))
                        cell.tintColor = .black
                        
                        return cell
                        
                    default:
                        return UITableViewCell()
                }
            }
            .disposed(by:disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                if indexPath.row == 5 {
                    self.tableView.cellForRow(at: indexPath)?.isSelected = false
                    let vc = CommentFactory().getInstance(postID: self.viewModel.post.id)
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        editButton.rx.tap
            .subscribe(onNext:{
                let vc = WritePostFactory().getInstance(post: self.viewModel.post)
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        view.backgroundColor = UIColor(named: "mainColor")
        
        tableView.backgroundColor = UIColor(named: "mainColor")
        tableView.separatorStyle = .none
        
        UserManager.getInstance()
            .subscribe(onNext: {
                if $0?.id == self.viewModel.post.user_id {
                    self.navigationItem.rightBarButtonItem = self.editButton
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    private func layout() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ].forEach{ $0.isActive = true}
    }
}

