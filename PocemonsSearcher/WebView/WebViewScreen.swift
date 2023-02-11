//
//  WebViewScreen.swift
//  PocemonsSearcher
//
//  Created by Егор Худяев on 07.02.2023.
//

import UIKit
import WebKit

final class WebViewScreen: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    private var stringUrl: String?
    
    init(stringUrl: String?) {
        super.init(nibName: nil, bundle: nil)
        self.stringUrl = stringUrl
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var webView: WKWebView = {
        let web = WKWebView()
        web.backgroundColor = .white
        web.uiDelegate = self
        web.navigationDelegate = self
        web.translatesAutoresizingMaskIntoConstraints = false
        return web
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Colors.gray
        
        loadWebView()
        setupConstraint()
    }
    
    private func loadWebView() {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                guard let stringUrl = self.stringUrl,
                      let url = URL(string: stringUrl) else { return }
                let request = URLRequest(url: url)
                self.webView.load(request)
            }
        }
    }
    
        //MARK: - устанавливаем констрейнты
    
    private func setupConstraint() {
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

