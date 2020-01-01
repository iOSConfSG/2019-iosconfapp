//
//  NewsViewController.swift
//  iosconfsg2019
//
//  Created by Vina Melody on 10/11/18.
//  Copyright © 2018 Vina Melody. All rights reserved.
//

import UIKit
import WebKit

class NewsViewController: UIViewController {

    private var webView: WKWebView!
    private var webViewConfiguration: WKWebViewConfiguration = {
        let config = WKWebViewConfiguration()
        return config
    }()

    let headerString = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>"

    private let webContent = """
    <a class="twitter-timeline" href="https://twitter.com/iosconfsg?ref_src=twsrc%5Etfw">Tweets by iosconfsg</a> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>
    """

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        navigationItem.title = "News"
        view.backgroundColor = .white
        webView = WKWebView(frame: self.view.frame, configuration: webViewConfiguration)
        webView.loadHTMLString(headerString + webContent, baseURL: nil)
        webView.navigationDelegate = self

        view.addSubview(webView)
        view.addConstraintsWithFormat("H:|[v0]|", views: webView)
        view.addConstraintsWithFormat("V:|[v0]|", views: webView)
    }
}

extension NewsViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url, navigationAction.navigationType == WKNavigationType.linkActivated, UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }
}
