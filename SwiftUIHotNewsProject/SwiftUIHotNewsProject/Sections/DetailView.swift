//
//  DetailView.swift
//  SwiftUIHotNewsProject
//
//  Created by 北京摩学教育科技有限公司 on 2020/9/3.
//  Copyright © 2020 ZCC. All rights reserved.
//

import SwiftUI
import WebKit

struct DetailView: View {
    var model: ContentModel
    
    var body: some View {
        WebView(loadPath: self.model.href, size: CGSize(width: kScreenW, height: kScreenH))
    }
}

struct WebView: UIViewRepresentable {
    typealias UIViewType = WKWebView
    var loadPath: String?
    var size: CGSize
    
    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.allowsPictureInPictureMediaPlayback = true
        let webView = WKWebView(frame: CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height), configuration: config)
        webView.load(self._createLoadPath())
        webView.sizeToFit()
        webView.allowsBackForwardNavigationGestures = true
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
    }
    
    func _createLoadPath() -> URLRequest {
        var path = self.loadPath ?? kHtmlPath
        path = path.hasPrefix("http") ? path : kHtmlPath + path
        return URLRequest(url: URL(string: path)!)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(model: ContentModel(num: "1", title: "", href: "https://s.weibo.com/weibo?q=%E7%BD%91%E7%BB%9C%E8%B4%A9%E5%A9%B4&Refer=top", subTitle: ""))
    }
}
