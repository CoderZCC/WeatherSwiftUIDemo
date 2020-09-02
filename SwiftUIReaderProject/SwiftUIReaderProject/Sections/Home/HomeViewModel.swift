//
//  HomeViewModel.swift
//  SwiftUIReaderProject
//
//  Created by 北京摩学教育科技有限公司 on 2020/9/1.
//  Copyright © 2020 ZCC. All rights reserved.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    
    @Published var model: HomeModel?
    
    func loadData() {
        APIManager.start(.html(kHtmlPath)).receive(on: DispatchQueue.global()).sink(receiveCompletion: { (result) in
            switch result {
            case .failure(let error):
                print(error)
            default:
                break
            }
        }) { [weak self] (html) in
            // 热门
            let divArr = html?.xPath("//div[@id=\"hotcontent\"]/div[@class=\"l\"]/div") ?? []
            var hotArr: [HotModel] = []
            for div in divArr {
                let href = div.xPath(".//a/@href").first?.content
                let cover = div.xPath(".//img/@src").first?.content
                let title = div.xPath(".//dt/a/text()").first?.content
                let author = div.xPath(".//dt/span").first?.content
                let desc = div.xPath(".//dd").first?.content
                hotArr.append(HotModel(href: href, cover: cover, title: title, desc: desc, author: author))
            }
            DispatchQueue.main.async {
                self?.model = HomeModel(hotContents: hotArr)
            }
        }.cancel()
    }
}


class DetailViewModel: ObservableObject {
    
    @Published var model: DetailModel?
    
    func loadData(_ path: String?) {
        guard let path = path else { return }
        APIManager.start(.html(path)).sink(receiveCompletion: { (_) in
            
        }) { [weak self] (html) in
            let title = html?.xPath("//div[@id=\"info\"]/h1/text()")?.first?.content
            let spans = html?.xPath("//div[@id=\"fmimg\"]/span")
            let statu = spans != nil ? "状态：连载中" : "状态：已完结"
            var update: String?
            var lastChapter: String?
            let ps = html?.xPath("//div[@id=\"info\"]/p//text()")
            for p in ps ?? [] {
                let content = p.content ?? ""
                if content.hasPrefix("最后更新") {
                    update = content
                }
                if content.hasPrefix("章节目录") {
                    lastChapter = "最新章节：" + content
                }
            }
            DispatchQueue.main.async {
                self?.model = DetailModel(title: title, statu: statu, update: update, lastChapter: lastChapter, html: html)
            }
        }.cancel()
    }
}


class ChapterViewModel: ObservableObject {
    @Published var model: ReaderModel?
    @Published var isLoading: Bool = false

    func loadData(_ path: String?) {
        self.isLoading = true
        var newPath = path ?? ""
        if !(path?.contains("wapbook") ?? false) {
            newPath = newPath.replacingOccurrences(of: "/aikan", with: "")
            newPath = newPath.replacingOccurrences(of: ".html", with: "")
            let arr = newPath.components(separatedBy: "/")
            let id1 = arr.first ?? ""
            let id2 = arr.last ?? ""
            newPath = "/wapbook\(id1)/\(id2)/"
        }
        newPath = "https://m.aikantxt.la" + newPath
        APIManager.start(.html(newPath)).receive(on: DispatchQueue.global()).sink(receiveCompletion: { (_) in
        }) { [weak self] (html) in
            let contents = html?.xPath("//div[@id=\"nr1\"]//text()")
            var finalStr: String = ""
            for c in contents ?? [] {
                finalStr += c.content ?? ""
            }
            
            let preA = html?.xPath("//a[@id=\"pb_prev\"]")?.first
            let preTitle = preA?.content
            var preHref: String! = preA?.attributes["href"] ?? ""
            if preHref.components(separatedBy: "/").count <= 3 {
                preHref = nil
            }
            let nextA = html?.xPath("//a[@id=\"pb_next\"]")?.first
            let nextTitle = nextA?.content
            var nextHref: String! = nextA?.attributes["href"] ?? ""
            if nextHref.components(separatedBy: "/").count <= 3 {
                nextHref = nil
            }
            DispatchQueue.main.async {
                self?.model = ReaderModel(content: finalStr, nextTitle: nextTitle, nextHref: nextHref, prevTitle: preTitle, prevHref: preHref)
                self?.isLoading = false
            }
        }.cancel()
    }
}
