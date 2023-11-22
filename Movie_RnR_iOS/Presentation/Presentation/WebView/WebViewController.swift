//
//  WebViewController.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/19.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    private let viewModel: WebViewModel
    
    private let webView = WKWebView()
    
    init(viewModel: WebViewModel) {
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
        
        let url = URL(string: viewModel.urlString)
        webView.load(URLRequest(url: url!))
        
    }
    
    
    private func layout() {
        self.view.backgroundColor = .white
        self.view.addSubview(webView)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        [
            webView.topAnchor
                .constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            webView.leftAnchor
                .constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            webView.bottomAnchor
                .constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            webView.rightAnchor
                .constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor)
        ].forEach { $0.isActive = true }
    }
    
    private func attribute() {
//        webView.configuration = WKWebViewConfiguration()
    }
}
