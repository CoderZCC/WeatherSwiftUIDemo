//
//  HomeModel.swift
//  SwiftUIReaderProject
//
//  Created by 北京摩学教育科技有限公司 on 2020/9/1.
//  Copyright © 2020 ZCC. All rights reserved.
//
import SwiftUI
import Ji

struct HomeModel {
    let hotContents: [HotModel]?
    
}

struct HotModel: Identifiable {
    var id = UUID()
    
    let href: String?
    let cover: String?
    let title: String?
    let desc: String?
    let author: String?
}

struct DetailModel {
    
    let title: String?
    /// 是否连载
    let statu: String?
    let update: String?
    let lastChapter: String?
    /// 上拉加载使用
    let html: Ji?
    
    /// 上次读到
    var lastModel: ChapterModel {
        var dls = self.html?.xPath("//div[@id=\"list\"]//dl")?.first?.children ?? []
        if !dls.isEmpty {
            dls = Array(dls[11...])
        }
        let href = dls.first?.xPath(".//a").first?.attributes["href"]
        let title = dls.first?.xPath(".//a//text()").first?.content
        
        return ChapterModel(title: title, href: href)
    }
}

struct ChapterModel: Identifiable {
    var id = UUID()
    let title: String?
    let href: String?
}

struct ReaderModel {
    let content: String?
    let nextTitle: String?
    let nextHref: String?

    let prevTitle: String?
    let prevHref: String?
}
