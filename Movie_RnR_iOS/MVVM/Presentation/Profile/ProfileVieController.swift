//
//  ProfileVieController.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/18.
//

import RxSwift
import UIKit

class ProfileViewController: UIViewController {
    var viewModel: ProfileViewModel!
    
    let disposeBag = DisposeBag()
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let subtitleLabel2 = UILabel()
    let nicknameLabel = UILabel()
    let genderLabel = UILabel()
    
    let titleLabel2 = UILabel()
    let biographyTextView = UITextView()
    
    let titleLabel3 = UILabel()
    let igButton = UIButton()
    let fbButton = UIButton()
    let ttButton = UIButton()
    
    let titleLabel4 = UILabel()
    let menuTableView = UITableView()
    
    let logoutButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        attribute()
        bind()
    }

    private func bind() {
        viewModel.menuList
            .drive(menuTableView.rx.items) { tv, row, data in
                let cell = UITableViewCell()
                cell.backgroundColor = UIColor(named: "mainColor")
                cell.textLabel?.text = data
                cell.textLabel?.textColor = .black
                return cell
            }
            .disposed(by: disposeBag)
        
        viewModel.profile
            .map{ $0[0].nickname}
            .bind(to: nicknameLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.profile
            .map{ $0[0].gender}
            .bind(to: genderLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.profile
            .map{ $0[0].biography}
            .bind(to: biographyTextView.rx.text)
            .disposed(by: disposeBag)
        
        UserManager.getInstance()
            .map { $0?.nickname ?? "" }
            .bind(to: nicknameLabel.rx.text)
            .disposed(by: disposeBag)
        
        UserManager.getInstance()
            .map { $0?.gender ?? "" }
            .bind(to: genderLabel.rx.text)
            .disposed(by: disposeBag)
        
        UserManager.getInstance()
            .map { $0?.biography ?? "" }
            .bind(to: biographyTextView.rx.text)
            .disposed(by: disposeBag)
        
        menuTableView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                switch indexPath.row {
                case 0:
                    let vc = EditProfileViewController()
                    vc.bind(self.viewModel.editProfileViewModel)
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                case 1:
                    let vc = ChangePasswordViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                default:
                    print(indexPath.row)
                }
            })
            .disposed(by: disposeBag)
        
        fbButton.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                let webVM = WebViewModel(urlString: "https://www.naver.com")
                let webVC = WebViewController()
                webVC.viewModel = webVM
                self.navigationController?.pushViewController(webVC, animated: true)
            })
            .disposed(by: disposeBag)
        
    }
    
    private func layout() {
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
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
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
        
        
        [
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo:scrollView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            subtitleLabel.widthAnchor.constraint(equalToConstant: 100),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            nicknameLabel.topAnchor.constraint(equalTo: subtitleLabel.topAnchor),
            nicknameLabel.leadingAnchor.constraint(equalTo: subtitleLabel.trailingAnchor),
            nicknameLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            subtitleLabel2.widthAnchor.constraint(equalToConstant: 100),
            subtitleLabel2.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 15),
            subtitleLabel2.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            genderLabel.topAnchor.constraint(equalTo: subtitleLabel2.topAnchor),
            genderLabel.leadingAnchor.constraint(equalTo: subtitleLabel2.trailingAnchor),
            genderLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            titleLabel2.topAnchor.constraint(equalTo: subtitleLabel2.bottomAnchor, constant: 30),
            titleLabel2.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            titleLabel2.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            biographyTextView.topAnchor.constraint(equalTo: titleLabel2.bottomAnchor, constant: 15),
            biographyTextView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            biographyTextView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            biographyTextView.heightAnchor.constraint(equalToConstant: 150),
            
            titleLabel3.topAnchor.constraint(equalTo: biographyTextView.bottomAnchor, constant: 30),
            titleLabel3.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            titleLabel3.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            igButton.widthAnchor.constraint(equalToConstant: 50),
            igButton.heightAnchor.constraint(equalToConstant: 50),
            igButton.topAnchor.constraint(equalTo: titleLabel3.bottomAnchor),
            igButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            fbButton.widthAnchor.constraint(equalTo: igButton.widthAnchor),
            fbButton.heightAnchor.constraint(equalTo: igButton.heightAnchor),
            fbButton.topAnchor.constraint(equalTo: igButton.topAnchor),
            fbButton.leadingAnchor.constraint(equalTo: igButton.trailingAnchor),
            
            ttButton.widthAnchor.constraint(equalTo: igButton.widthAnchor),
            ttButton.heightAnchor.constraint(equalTo: igButton.heightAnchor),
            ttButton.topAnchor.constraint(equalTo: igButton.topAnchor),
            ttButton.leadingAnchor.constraint(equalTo: fbButton.trailingAnchor),
            
            titleLabel4.topAnchor.constraint(equalTo: igButton.bottomAnchor, constant: 30),
            titleLabel4.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            titleLabel4.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            menuTableView.topAnchor.constraint(equalTo: titleLabel4.bottomAnchor, constant: 10),
            menuTableView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: -10),
            menuTableView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            menuTableView.heightAnchor.constraint(equalToConstant: 160),
            
            logoutButton.topAnchor.constraint(equalTo: menuTableView.bottomAnchor, constant: 30),
            logoutButton.heightAnchor.constraint(equalToConstant: 40),
            logoutButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            contentView.bottomAnchor.constraint(equalTo: logoutButton.bottomAnchor, constant: 20 )
            
        ].forEach {
            $0.isActive = true
        }
    }
    
    private func attribute() {
        scrollView.backgroundColor = UIColor(named: "mainColor")
        
        titleLabel.text = "Basic Information"
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        
        subtitleLabel.text = "Nickname"
        subtitleLabel.textColor = .black
        subtitleLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        
        nicknameLabel.textColor = .black
        nicknameLabel.font = .systemFont(ofSize: 15)
        
        subtitleLabel2.text = "Gender"
        subtitleLabel2.textColor = .black
        subtitleLabel2.font = .systemFont(ofSize: 15, weight: .semibold)
        
        genderLabel.textColor = .black
        genderLabel.font = .systemFont(ofSize: 15)
        
        titleLabel2.text = "Biography"
        titleLabel2.textColor = .black
        titleLabel2.font = .systemFont(ofSize: 20, weight: .bold)
        
        biographyTextView.textColor = .black
        biographyTextView.font = .systemFont(ofSize: 15)
        biographyTextView.backgroundColor = .white
        biographyTextView.isEditable = false
        
        titleLabel3.text = "SNS"
        titleLabel3.textColor = .black
        titleLabel3.font = .systemFont(ofSize: 20, weight: .bold)
        
        igButton.setImage(UIImage(named: "instagram"), for: .normal)
        igButton.imageView?.contentMode = .scaleAspectFill
        
        fbButton.setImage(UIImage(named: "facebook"), for: .normal)
        fbButton.imageView?.contentMode = .scaleAspectFill
        
        ttButton.setImage(UIImage(named: "twitter"), for: .normal)
        ttButton.imageView?.contentMode = .scaleAspectFill
        
        titleLabel4.text = "More"
        titleLabel4.textColor = .black
        titleLabel4.font = .systemFont(ofSize: 20, weight: .bold)
        
        menuTableView.rowHeight = 40
        menuTableView.backgroundColor = UIColor(named: "mainColor")
        
        logoutButton.backgroundColor = UIColor(named: "headerColor")
        logoutButton.titleLabel?.textColor = .white
        logoutButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        logoutButton.setTitle("Logout", for: .normal)
        
    }
}
