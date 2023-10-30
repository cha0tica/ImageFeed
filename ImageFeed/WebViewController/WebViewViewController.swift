//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Agata on 18.08.2023.
//

import Foundation
import UIKit
import WebKit
import SwiftKeychainWrapper

final class WebViewViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    @IBAction func didTapBackButton(_ sender: Any) {
        delegate?.webViewViewControllerDidCancel(self)
    }
    @IBOutlet weak var progressView: UIProgressView!
    
    private struct QueryKeys {
        static let clientId = "client_id"
        static let redirectURI = "redirect_uri"
        static let responseType = "response_type"
        static let accessScope = "scope"
    }
    
    weak var delegate: WebViewViewControllerDelegate?
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: {
                 [weak self] _, _ in
                 guard let self else { return }
                 self.updateProgress()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        
        loadWebView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}

private extension WebViewViewController {
    func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
    
    func loadWebView() {
        var urlComponents = URLComponents(string: unsplashAuthorizeURLString)
        urlComponents?.queryItems = [
            URLQueryItem(name: QueryKeys.clientId, value: accessKey),
            URLQueryItem(name: QueryKeys.redirectURI, value: redirectURI),
            URLQueryItem(name: QueryKeys.responseType, value: "code"),
            URLQueryItem(name: QueryKeys.accessScope, value: accessScope)
        ]
        
        if let url = urlComponents?.url {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    func fetchCode(from navigationAction: WKNavigationAction) -> String? {
        guard
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let codeItem = urlComponents.queryItems?.first(where: { $0.name == "code"})
        else { return nil }
        
        return codeItem.value
    }
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = fetchCode(from: navigationAction) {
            decisionHandler(.cancel)
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
        } else {
            decisionHandler(.allow)
        }
    }
}
