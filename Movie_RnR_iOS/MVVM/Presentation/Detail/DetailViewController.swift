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
    
    let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: nil, action: nil)
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let topStackView = UIStackView()
    let bottomStackView = UIStackView()
    
    let postImageView = UIImageView()
    
    let titleLabel = UILabel()
    let genresLabel = UILabel()
    let ratesLabel = UILabel()
    let overviewTextView = UITextView()
    let dateLabel = UILabel()
    let nicknameButton = UIButton()
    
    let commentButton = UIButton()
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.refresh.onNext(Void())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attribute()
        layout()
        bind()
    }
    
    private func bind() {
        
        viewModel.detailData
            .map { $0?.movie.title ?? "" }
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.detailData
            .map { $0?.movie.genres ?? "" }
            .bind(to: genresLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.detailData
            .map { "✭ \($0?.movie.rates ?? 0)/10.0" }
            .bind(to: ratesLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.detailData
            .map { $0?.movie.overview ?? "" }
            .bind(to: overviewTextView.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.detailData
            .map { $0?.movie.created ?? "" }
            .map(dateFormat)
            .bind(to: dateLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.detailData
            .map { $0?.user.nickname ?? "" }
            .bind(to: nicknameButton.rx.title())
            .disposed(by: disposeBag)
        
        editButton.rx.tap
            .subscribe(onNext:{
                let vc = WritePostFactory().getInstance(post: self.viewModel.post)
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        commentButton.rx.tap
        
            .subscribe(onNext: { _ in
                let vc = CommentFactory().getInstance(postID: self.viewModel.post.id)
                
                self.navigationController?.pushViewController(vc, animated: true)
                
            })
            .disposed(by: disposeBag)
        
        
    }
    
    private func attribute() {
        
        view.backgroundColor = UIColor(named: "mainColor")
        
        // 임시 사진
        postImageView.image = UIImage(named: "postImage1")
        postImageView.contentMode = .scaleAspectFit
        
        titleLabel.font = UIFont(name: "CarterOne", size: 20)
        titleLabel.textColor = .black
        
        [
            genresLabel,
            ratesLabel,
            dateLabel,
        ].forEach {
            $0.font = UIFont(name: "CarterOne", size: 13)
            $0.textColor = .black
        }
        
        nicknameButton.titleLabel?.font = UIFont(name: "CarterOne", size: 13)
        nicknameButton.setTitleColor(.black, for: .normal)
        
        overviewTextView.textColor = .black
        overviewTextView.font = .systemFont(ofSize: 15)
        overviewTextView.backgroundColor = .white
        overviewTextView.isEditable = false
        overviewTextView.isScrollEnabled = false
        overviewTextView.backgroundColor = UIColor(named: "mainColor")
        overviewTextView.font = UIFont(name: "CarterOne", size: 15)
        
        commentButton.setTitle("Comments", for: .normal)
        commentButton.setTitleColor(.black, for: .normal)
        commentButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        commentButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        commentButton.semanticContentAttribute = .forceRightToLeft
        commentButton.tintColor = .black
        commentButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        commentButton.titleLabel?.font = UIFont(name: "CarterOne", size: 20)
        
        UserManager.getInstance()
            .subscribe(onNext: {
                if $0?.id == self.viewModel.post.user_id {
                    self.navigationItem.rightBarButtonItem = self.editButton
                }
            })
            .disposed(by: disposeBag)
        
        nicknameButton.rx.tap
            .observe(on: MainScheduler.instance)
            .withLatestFrom(viewModel.detailData)
            .subscribe(onNext: { [weak self] detail in
                guard let self = self else { return }
                let vc = ProfileFactory().getInstance(userID: detail!.user.id)
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
    }
    
    private func layout() {
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        [postImageView, titleLabel, topStackView, overviewTextView, bottomStackView, commentButton].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        titleLabel.textAlignment = .center
        
        topStackView.addArrangedSubview(genresLabel)
        topStackView.addArrangedSubview(ratesLabel)
        topStackView.alignment = .fill
        topStackView.distribution = .equalSpacing
        
        bottomStackView.addArrangedSubview(dateLabel)
        bottomStackView.addArrangedSubview(nicknameButton)
        bottomStackView.distribution = .equalSpacing
        topStackView.alignment = .fill
        topStackView.distribution = .equalSpacing
        
        [
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo:scrollView.widthAnchor),
            
            postImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            postImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            postImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            postImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width-30),
            postImageView.heightAnchor.constraint(equalToConstant:(UIScreen.main.bounds.width-30)*0.65),
            
            titleLabel.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            topStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            topStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            topStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            overviewTextView.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: 15),
            overviewTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            overviewTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            bottomStackView.topAnchor.constraint(equalTo: overviewTextView.bottomAnchor, constant: 15),
            bottomStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottomStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            commentButton.topAnchor.constraint(equalTo: bottomStackView.bottomAnchor, constant: 15),
            commentButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            commentButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            contentView.bottomAnchor.constraint(equalTo: commentButton.bottomAnchor)
        ].forEach{ $0.isActive = true}
    }
    
    private func dateFormat(with: String?) -> String {
        guard let with = with else {
            return ""
        }
        
        return String(with.split(separator: "T")[0])
    }
}
