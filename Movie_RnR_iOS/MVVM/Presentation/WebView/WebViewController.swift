//
//  WebViewController.swift
//  Movie_RnR_iOS
//
//  Created by 엄태양 on 2022/08/19.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    var viewModel: WebViewModel!
    
    let webView = WKWebView()
    
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
