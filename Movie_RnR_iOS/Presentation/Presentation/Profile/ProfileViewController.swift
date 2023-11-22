//
//  ProfileVieController.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/18.
//

import RxSwift
import UIKit
import SnapKit

class ProfileViewController: UIViewController {
    private let viewModel: ProfileViewModel
    
    private let disposeBag = DisposeBag()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor(named: "mainColor")
        return scrollView
    }()
    
    private let contentView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Basic Information"
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Nickname"
        label.textColor = .black
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        return label
    }()
    
    private let subtitleLabel2: UILabel = {
        let label = UILabel()
        label.text = "Gender"
        label.textColor = .black
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        return label
    }()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    private let genderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    private let titleLabel2: UILabel = {
        let label = UILabel()
        label.text = "Biography"
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let biographyTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .black
        textView.font = .systemFont(ofSize: 15)
        textView.backgroundColor = .white
        textView.isEditable = false
        return textView
    }()
    
    private let titleLabel3: UILabel = {
        let label = UILabel()
        label.text = "SNS"
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let igButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "instagram"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    
    private let fbButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "facebook"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    
    private let ttButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "twitter"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    
    private let titleLabel4: UILabel = {
        let label = UILabel()
        label.text = "More"
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let menuTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "menuCell")
        tableView.rowHeight = 40
        tableView.backgroundColor = UIColor(named: "mainColor")
        return tableView
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "headerColor")
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        button.setTitle("Logout", for: .normal)
        return button
    }()
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        bindViewModel()
    }
    
    private func bindViewModel() {
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:))).map { _ in Void() }.asDriver(onErrorJustReturn: Void())
    
        menuTableView.rx.itemSelected
            .asDriver()
            .drive(onNext: {[weak self] indexPath in
                self?.menuTableView.cellForRow(at: indexPath)?.isSelected = false
            })
            .disposed(by: disposeBag)
        
        let input = ProfileViewModel.Input(trigger: viewWillAppear,
                                           logoutTrigger: logoutButton.rx.tap.asDriver(),
                                           menuSelect: menuTableView.rx.itemSelected.asDriver())
        
        let output = viewModel.transform(input: input)
        
        output.menuList
            .drive(menuTableView.rx.items) { tv, row, data in
                let cell = tv.dequeueReusableCell(withIdentifier: "menuCell", for: IndexPath(row: row, section: 0)) as UITableViewCell
                cell.backgroundColor = UIColor(named: "mainColor")
                cell.textLabel?.text = data.rawValue
                cell.textLabel?.textColor = .black
                return cell
            }
            .disposed(by: disposeBag)
        
        output.profile
            .filter { $0 != nil }
            .drive(onNext: { [weak self] profile in
                guard let profile = profile, let self = self else { return }
                self.nicknameLabel.text = profile.nickname
                self.genderLabel.text = profile.gender
                self.biographyTextView.text = profile.biography
            })
            .disposed(by: disposeBag)
    
        output.selectedMenu
            .withLatestFrom(output.profile) { ($0, $1) }
            .drive(onNext: {menu, profile in
                switch menu {
                    case .editProfile:
                        let vc = EditProfileViewController(viewModel: EditProfileViewModel())
                        self.navigationController?.pushViewController(vc, animated: true)
                    case .changePassword:
                        let vc = ChangePasswordViewController(viewModel: ChangePasswordViewModel())
                        self.navigationController?.pushViewController(vc, animated: true)
                    case .viewPostings:
                        let vc = UserPostingViewController(viewModel: UserPostingViewModel(userID: profile!.id))
                        self.navigationController?.pushViewController(vc, animated: true)
                    case .dangerZone:
                        let vc = DangerZoneViewController(viewModel: DangerZoneViewModel())
                        self.navigationController?.pushViewController(vc, animated: true)
                    default:
                        return
                }
            })
            .disposed(by: disposeBag)

        igButton.rx.tap
            .asDriver()
            .withLatestFrom(output.profile)
            .drive(onNext: {
                
                let webVC = WebViewController(viewModel: WebViewModel(urlString: $0?.instagram ?? ""))
                self.navigationController?.pushViewController(webVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        fbButton.rx.tap
            .asDriver()
            .withLatestFrom(output.profile)
            .drive(onNext: {
                let webVC = WebViewController(viewModel: WebViewModel(urlString: $0?.facebook ?? ""))
                self.navigationController?.pushViewController(webVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        ttButton.rx.tap
            .asDriver()
            .withLatestFrom(output.profile)
            .drive(onNext: {
                let webVC = WebViewController(viewModel: WebViewModel(urlString: $0?.twitter ?? ""))
                self.navigationController?.pushViewController(webVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        output.isMine
            .map { !$0 }
            .drive(logoutButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.logoutResult
            .drive(onNext: {
                if $0.isSuccess {
                    let alert = UIAlertController(title: "로그아웃", message: "정상적으로 로그아웃 되었습니다.", preferredStyle: .alert)
                    
                    let action = UIAlertAction(title: "확인", style: .default) { _ in
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                    alert.addAction(action)
                    
                    self.present(alert, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    private func layout() {
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [
            titleLabel,
            subtitleLabel,
            nicknameLabel,
            subtitleLabel2,
            genderLabel,
            titleLabel2,
            biographyTextView,
            titleLabel3,
            igButton,
            fbButton,
            ttButton,
            titleLabel4,
            menuTableView,
            logoutButton
        ]
            .forEach {
                contentView.addSubview($0)
            }
        
        
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(view)
        }
        
        contentView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.width.equalTo(scrollView)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalTo(contentView).offset(15)
            $0.trailing.equalTo(contentView).offset(-15)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.top.equalTo(titleLabel.snp.bottom).offset(15)
            $0.leading.equalTo(titleLabel)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel)
            $0.leading.equalTo(subtitleLabel.snp.trailing)
            $0.trailing.equalTo(titleLabel)
        }
        
        subtitleLabel2.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(15)
            $0.leading.equalTo(titleLabel)
        }
        
        genderLabel.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel2)
            $0.leading.equalTo(subtitleLabel2.snp.trailing)
            $0.trailing.equalTo(titleLabel)
        }
        
        titleLabel2.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel2.snp.bottom).offset(30)
            $0.leading.trailing.equalTo(titleLabel)
        }
        
        biographyTextView.snp.makeConstraints {
            $0.top.equalTo(titleLabel2.snp.bottom).offset(15)
            $0.leading.trailing.equalTo(titleLabel)
            $0.height.equalTo(150)
        }
        
        titleLabel3.snp.makeConstraints {
            $0.top.equalTo(biographyTextView.snp.bottom).offset(30)
            $0.leading.trailing.equalTo(titleLabel)
        }
        
        igButton.snp.makeConstraints {
            $0.width.height.equalTo(50)
            $0.top.equalTo(titleLabel3.snp.bottom)
            $0.leading.equalTo(titleLabel)
        }
        
        fbButton.snp.makeConstraints {
            $0.width.height.equalTo(50)
            $0.top.equalTo(igButton)
            $0.leading.equalTo(igButton.snp.trailing)
        }
        
        ttButton.snp.makeConstraints {
            $0.width.height.equalTo(50)
            $0.top.equalTo(igButton)
            $0.leading.equalTo(fbButton.snp.trailing)
        }
        
        titleLabel4.snp.makeConstraints {
            $0.top.equalTo(igButton.snp.bottom).offset(30)
            $0.leading.trailing.equalTo(titleLabel)
        }
        
        menuTableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel4.snp.bottom).offset(10)
            $0.leading.equalTo(titleLabel).offset(-15)
            $0.trailing.equalTo(titleLabel)
            $0.height.equalTo(160)
        }
        
        logoutButton.snp.makeConstraints {
            $0.top.equalTo(menuTableView.snp.bottom).offset(30)
            $0.height.equalTo(40)
            $0.leading.trailing.equalTo(titleLabel)
            $0.bottom.equalTo(contentView).offset(-20)
        }
        
    }
}
