//
//  CommentCell.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/10.
//

import UIKit
import RxSwift

class CommentViewController: UIViewController {
    let disposeBag = DisposeBag()
    let commentInputStackView = UIStackView()
    let commentTextView = UITextView()
    let commentButton = UIButton()
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attribute()
        layout()
    }
    
    func bind(_ viewModel: CommentViewModel){
        viewModel.cellData
            .drive(tableView.rx.items) { tv, row, comment in
                let indexPath = IndexPath(row: row, section: 0)
                let cell = tv.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
                cell.setUp(comment: comment)
                cell.selectionStyle = .none
                return cell
            }
            .disposed(by: disposeBag)
    }
    
    
    private func attribute() {
    
        title = "Comments"
        
        view.backgroundColor = UIColor(named: "mainColor")
    
        
        commentInputStackView.addArrangedSubview(commentTextView)
        commentInputStackView.addArrangedSubview(commentButton)
        commentInputStackView.alignment = .fill
        
        commentTextView.textColor = .black
        commentTextView.backgroundColor = .white
        
        commentButton.backgroundColor = UIColor(named: "headerColor")
        commentButton.setTitleColor(.white, for: .normal)
        commentButton.setTitle("Save", for: .normal)
        
        tableView.backgroundColor = UIColor(named: "mainColor")
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.register(CommentCell.self, forCellReuseIdentifier: "CommentCell")
        
    }
    
    private func layout() {
        [ commentInputStackView, tableView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        [
            
            commentInputStackView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width-30),
            commentInputStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            commentInputStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            commentInputStackView.heightAnchor.constraint(equalToConstant: 100),
            
            commentButton.widthAnchor.constraint(equalToConstant: 100),
            
            tableView.topAnchor.constraint(equalTo: commentInputStackView.bottomAnchor, constant: 20),
            tableView.widthAnchor.constraint(equalTo: commentInputStackView.widthAnchor),
            tableView.centerXAnchor.constraint(equalTo: commentInputStackView.centerXAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
        ].forEach { $0.isActive = true}
    }
    
}
