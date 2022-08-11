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
        
        attribute()
        layout()
    }
    
    func bind(_ viewModel: DetailViewModel) {
        
        viewModel.cellList
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
                    cell.bind(viewModel.titleCellViewModel)
                    cell.setUp()
                    return cell
                case 2:
                    let indexPath = IndexPath(row: row, section: 0)
                    let cell = tv.dequeueReusableCell(withIdentifier: "DetailTopStackViewCell", for: indexPath) as! TopStackViewCell
                    cell.isUserInteractionEnabled = false
                    cell.bind(viewModel.topStackViewCellViewModel)
                    cell.setUp()
                    return cell
                case 3:
                    let indexPath = IndexPath(row: row, section: 0)
                    let cell = tv.dequeueReusableCell(withIdentifier: "DetailOverviewCell", for: indexPath) as! OverviewCell
                    cell.isUserInteractionEnabled = false
                    cell.bind(viewModel.overviewCellViewModel)
                    cell.setUp()
                    return cell
                case 4:
                    let indexPath = IndexPath(row: row, section: 0)
                    let cell = tv.dequeueReusableCell(withIdentifier: "DetailBottomStackViewCell", for: indexPath) as! BottomStackViewCell
                    cell.isUserInteractionEnabled = false
                    cell.bind(viewModel.bottomStackViewCellViewModel)
                    cell.setUp()
                    return cell
                case 5:
                    let cell = UITableViewCell()
                    cell.backgroundColor = .clear
                    cell.textLabel?.text = "Comments (\(viewModel.post.commentCount ?? 0))"
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
                self.tableView.cellForRow(at: indexPath)?.isSelected = false
                let vc = CommentViewController()
                let vm = CommentViewModel(postID: viewModel.post.id)
                vc.bind(vm)
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
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

