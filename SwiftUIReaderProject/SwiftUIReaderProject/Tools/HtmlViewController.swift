//
//  HtmlViewController.swift
//  SwiftUIReaderProject
//
//  Created by 北京摩学教育科技有限公司 on 2020/9/2.
//  Copyright © 2020 ZCC. All rights reserved.
//

import SwiftUI
import UIKit
import WebKit
import Ji

struct HtmlView: UIViewControllerRepresentable {
    let path: String?
    
    typealias UIViewControllerType = HtmlViewController
    func makeUIViewController(context: Context) -> HtmlViewController {
        return HtmlViewController(self.path) { (str) in
            
            
        }
    }
    
    func updateUIViewController(_ uiViewController: HtmlViewController, context: Context) {
        
    }
}

class HtmlViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    init(_ path: String?, block: ((String?)->Void)?) {
        super.init(nibName: nil, bundle: nil)
        
        self._block = block
        self._path = kHtmlPath + (path ?? "")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var _path: String?
    private var _block: ((String?)->Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newUAStr = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.135 Safari/537.36"
        UserDefaults.standard.register(defaults: ["UserAgent": newUAStr, "User-Agent": newUAStr])
        
        let webView = WKWebView(frame: self.view.bounds, configuration: WKWebViewConfiguration())
        webView.load(URLRequest(url: URL(string: self._path ?? "")!))
        self.view.addSubview(webView)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "estimatedProgress" {
            let webView = object as? WKWebView
            let progress = (change?[.newKey] as? NSNumber)?.doubleValue  ?? 0.0
            print("加载进度:\(progress)")
            if progress >= 1.0 {
                self._runJs(webView: webView)
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
    
    func _runJs(webView: WKWebView?) {
        let jsStr = "document.getElementsByTagName(\"html\")[0].innerHTML.toString()"
        webView?.evaluateJavaScript(jsStr) { [weak self] (data, error) in

            var htmlStr = data as? String ?? ""
            print(htmlStr)

            htmlStr = htmlStr.replacingOccurrences(of: "charset=gbk", with: "charset=utf8")
            let html = Ji(htmlString: htmlStr)
            let contents = html?.xPath("//div[@id=\"content\"]//text()")
            for c in contents ?? [] {
                print(c)
            }
            
            
            self?._block?(htmlStr)
        }
    }
}
