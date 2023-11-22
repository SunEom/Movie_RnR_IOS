//
//  DetailViewController.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/08.
//

import UIKit
import RxSwift
import SnapKit

class DetailViewController: UIViewController {
    private let viewModel: DetailViewModel!
    
    private let disposeBag = DisposeBag()
    
    private let loadingView: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView()
        loadingView.backgroundColor = UIColor(named: "mainColor")
        return loadingView
    }()
    
    let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: nil, action: nil)
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let topStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    let bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "postImage1")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    let genresLabel = UILabel()
    let ratesLabel = UILabel()
    
    let overviewTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .black
        textView.font = .systemFont(ofSize: 15)
        textView.backgroundColor = .white
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.backgroundColor = UIColor(named: "mainColor")
        textView.font = .systemFont(ofSize: 15)
        return textView
    }()
    
    let dateLabel = UILabel()
    let nicknameButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: "CarterOne", size: 13)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    let commentButton: UIButton = {
        let button = UIButton()
        button.setTitle("Comments", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.tintColor = .black
        button.titleLabel?.font = UIFont(name: "CarterOne", size: 20)
        return button
    }()
    
    init(viewModel: DetailViewModel!) {
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
    
    private func bindViewModel() {
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:))).map { _ in Void() }.asDriver(onErrorJustReturn: Void())
        
        let input = DetailViewModel.Input(trigger: viewWillAppear)
        
        let output = viewModel.transform(input: input)

        output.postDetail
            .filter { $0 != nil }
            .drive(onNext: {[weak self] post in
                guard let movie = post?.movie, let user = post?.user, let self = self else { return }
                self.titleLabel.text = movie.title
                self.genresLabel.text = movie.genres
                self.ratesLabel.text = "✭ \(movie.rates)/10.0"
                self.overviewTextView.text = movie.overview
                self.dateLabel.text = dateFormat(with: movie.created)
                self.nicknameButton.setTitle(user.nickname, for: .normal)
            })
            .disposed(by: disposeBag)
        
        output.isMine
            .drive(onNext: {
                if $0 {
                    self.navigationItem.rightBarButtonItem = self.editButton
                }
            })
            .disposed(by: disposeBag)
        
        output.loading
            .drive(onNext:{[weak self] loading in
                if loading {
                    self?.loadingView.startAnimating()
                    self?.loadingView.isHidden = false
                } else {
                    self?.loadingView.stopAnimating()
                    self?.loadingView.isHidden = true
                }
            })
            .disposed(by: disposeBag)
        
        editButton.rx.tap
            .asDriver()
            .drive(onNext:{ [weak self] in
                let vc = WritePostViewController(viewModel: WritePostViewModel(post: output.post))
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        commentButton.rx.tap
            .asDriver()
            .drive(onNext: {[weak self] _ in
                let vc = CommentViewController(viewModel: CommentViewModel(postID: output.post.id))
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        nicknameButton.rx.tap
            .asDriver()
            .withLatestFrom(output.postDetail)
            .drive(onNext: { [weak self] detail in
                guard let self = self, let detail = detail else { return }
                let vc = ProfileViewController(viewModel: ProfileViewModel(userID: detail.user.id))
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        
        view.backgroundColor = UIColor(named: "mainColor")
            
        [
            genresLabel,
            ratesLabel,
            dateLabel,
        ].forEach {
            $0.font = .systemFont(ofSize: 15, weight: .semibold)
            $0.textColor = .black
        }
    }
    
    private func layout() {
        
        view.addSubview(scrollView)
        view.addSubview(loadingView)
        
        scrollView.addSubview(contentView)
        
        [postImageView, titleLabel, topStackView, overviewTextView, bottomStackView, commentButton].forEach {
            contentView.addSubview($0)
        }
        
        topStackView.addArrangedSubview(genresLabel)
        topStackView.addArrangedSubview(ratesLabel)
        
        
        bottomStackView.addArrangedSubview(dateLabel)
        bottomStackView.addArrangedSubview(nicknameButton)
        
        loadingView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-15)
        }
        
        contentView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.width.equalTo(scrollView)
        }
        
        postImageView.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(15)
            $0.leading.trailing.equalTo(contentView)
            $0.width.equalTo(UIScreen.main.bounds.width-30)
            $0.height.equalTo((UIScreen.main.bounds.width-30)*0.65)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(postImageView.snp.bottom).offset(15)
            $0.leading.trailing.equalTo(contentView)
        }
        
        topStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(15)
            $0.leading.trailing.equalTo(contentView)
        }
        
        overviewTextView.snp.makeConstraints {
            $0.top.equalTo(topStackView.snp.bottom).offset(15)
            $0.leading.trailing.equalTo(contentView)
        }

        bottomStackView.snp.makeConstraints {
            $0.top.equalTo(overviewTextView.snp.bottom).offset(15)
            $0.leading.trailing.equalTo(contentView)
        }
        
        commentButton.snp.makeConstraints {
            $0.top.equalTo(bottomStackView.snp.bottom).offset(15)
            $0.leading.trailing.equalTo(contentView)
            $0.bottom.equalTo(contentView).offset(-20)
        }
        
    }
    
    private func dateFormat(with: String?) -> String {
        guard let with = with else {
            return ""
        }
        
        return String(with.split(separator: "T")[0])
    }
}
