//
//  DetailViewController.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/08.
//

import UIKit
import RxSwift

class DetailViewController: UIViewController {
    let disposeBag = DisposeBag()
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(ImageCell.self, forCellReuseIdentifier: "DetailImageCell")
        tableView.register(TitleCell.self, forCellReuseIdentifier: "DetailTitleCell")
        tableView.register(TopStackViewCell.self, forCellReuseIdentifier: "DetailTopStackViewCell")
        tableView.register(OverviewCell.self, forCellReuseIdentifier: "DetailOverviewCell")
        tableView.register(BottomStackViewCell.self, forCellReuseIdentifier: "DetailBottomStackViewCell")
        tableView.register(CommentListCell.self, forCellReuseIdentifier: "DetailCommentListCell")
        
        attribute()
        layout()
    }
    
    func bind(_ viewModel: DetailViewModel) {
        title = viewModel.post.title
        
        viewModel.cellData
            .drive(tableView.rx.items) { tv, row, data in
                switch row {
                case 0:
                    let indexPath = IndexPath(row: row, section: 0)
                    let cell = tv.dequeueReusableCell(withIdentifier: "DetailImageCell", for: indexPath) as! ImageCell
                    cell.isUserInteractionEnabled = false
                    cell.setUp(imageName: "postImage1")
                    return cell
                case 1:
                    let indexPath = IndexPath(row: row, section: 0)
                    let cell = tv.dequeueReusableCell(withIdentifier: "DetailTitleCell", for: indexPath) as! TitleCell
                    cell.isUserInteractionEnabled = false
                    cell.setUp(title: viewModel.post.title)
                    return cell
                case 2:
                    let indexPath = IndexPath(row: row, section: 0)
                    let cell = tv.dequeueReusableCell(withIdentifier: "DetailTopStackViewCell", for: indexPath) as! TopStackViewCell
                    cell.isUserInteractionEnabled = false
                    cell.setUp(genres: viewModel.post.genres, rates: viewModel.post.rates)
                    return cell
                case 3:
                    let indexPath = IndexPath(row: row, section: 0)
                    let cell = tv.dequeueReusableCell(withIdentifier: "DetailOverviewCell", for: indexPath) as! OverviewCell
                    cell.isUserInteractionEnabled = false
                    cell.setup(overview: viewModel.post.overview)
                    return cell
                case 4:
                    let indexPath = IndexPath(row: row, section: 0)
                    let cell = tv.dequeueReusableCell(withIdentifier: "DetailBottomStackViewCell", for: indexPath) as! BottomStackViewCell
                    cell.isUserInteractionEnabled = false
                    cell.setUp(date: viewModel.post.created, nickname: "")
                    return cell
                case 5:
                    let indexPath = IndexPath(row: row, section: 0)
                    let cell = tv.dequeueReusableCell(withIdentifier: "DetailCommentListCell", for: indexPath) as! CommentListCell
                    cell.isUserInteractionEnabled = false
                    cell.setUp()
                    return cell
                default:
                    return UITableViewCell()
                }
            }
            .disposed(by:disposeBag)
    }
    
    private func attribute() {
        view.backgroundColor = UIColor(named: "mainColor")
        
        tableView.backgroundColor = UIColor(named: "mainColor")
        tableView.separatorStyle = .none
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

