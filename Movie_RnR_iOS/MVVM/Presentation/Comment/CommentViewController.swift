//
//  CommentCell.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/10.
//

import UIKit
import RxSwift
import SnapKit

class CommentViewController: UIViewController {
    private let viewModel: CommentViewModel
    private let disposeBag = DisposeBag()
    
    private let loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.backgroundColor = UIColor(named: "mainColor")
        return view
    }()
    
    private let commentInputStackView = UIStackView()
    
    private let commentTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .black
        textView.backgroundColor = .white
        return textView
    }()
    
    private let commentButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "headerColor")
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Save", for: .normal)
        return button
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor(named: "mainColor")
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.register(CommentCellViewController.self, forCellReuseIdentifier: "CommentCell")
        return tableView
    }()
    
    init(viewModel: CommentViewModel!) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attribute()
        layout()
        bindViewModel()
    }

    private func bindViewModel(){
        
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:))).map { _ in Void() }.asDriver(onErrorJustReturn: Void())
        
        let input = CommentViewModel.Input(trigger: viewWillAppear,
                                           createTrigger: commentButton.rx.tap.asDriver(),
                                           content: commentTextView.rx.text.orEmpty.asDriver())
        
        let output = viewModel.transfrom(input: input)
        
        output.loading
            .drive(onNext: {[weak self] loading in
                if loading {
                    self?.loadingView.startAnimating()
                    self?.loadingView.isHidden = false
                } else {
                    self?.loadingView.stopAnimating()
                    self?.loadingView.isHidden = true
                }
            })
            .disposed(by: disposeBag)
        
        output.comments
            .drive(tableView.rx.items) {[weak self] tv, row, comment in
                let indexPath = IndexPath(row: row, section: 0)
                guard let self = self, let cell = tv.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as? CommentCellViewController else { return UITableViewCell() }
                cell.cellInit(viewModel: CommentCellViewModel(vm: self.viewModel, comment: comment))
                cell.selectionStyle = .none
                
                return cell
            }
            .disposed(by: disposeBag)

        output.createResult
            .drive(onNext: {
                if $0.isSuccess {
                    self.commentTextView.text = ""
                } else {
                    let alert = UIAlertController(title: "실패", message: $0.message ?? "", preferredStyle: .alert)
                    let action = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(action)
                    self.present(alert, animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
    
    
    private func attribute() {
        title = "Comments"
        view.backgroundColor = UIColor(named: "mainColor")
    }
    
    private func layout() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        view.addGestureRecognizer(tap)
        
        commentInputStackView.addArrangedSubview(commentTextView)
        commentInputStackView.addArrangedSubview(commentButton)
        
        [ commentInputStackView, tableView, loadingView].forEach { view.addSubview($0) }
        
        loadingView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        commentInputStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(15)
            $0.leading.equalTo(view).offset(15)
            $0.trailing.equalTo(view).offset(-15)
            $0.height.equalTo(100)
        }
        
        commentButton.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(commentInputStackView.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(commentInputStackView)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        view.endEditing(true)
    }
    
}
