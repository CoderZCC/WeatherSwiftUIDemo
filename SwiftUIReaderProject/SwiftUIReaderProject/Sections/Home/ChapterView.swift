//
//  ChapterView.swift
//  SwiftUIReaderProject
//
//  Created by 北京摩学教育科技有限公司 on 2020/9/2.
//  Copyright © 2020 ZCC. All rights reserved.
//

import SwiftUI

struct ChapterView: View {
    /// 阅读页面传值
    @Binding var isShowMenu: Bool
    @ObservedObject var vm: ChapterViewModel
    
    var model: DetailModel?
    @Environment(\.colorScheme) var colorScheme
    private let _limit = 20
    @State private var _page = 0
    @State private var _chapters: [ChapterModel] = []
    @State private var _isEnd: Bool = false
    @State private var _isReverse: Bool = false
    
    var body: some View {
        VStack {
            List{
                Section(header: HStack {
                    Text(self.model?.title ?? "加载中")
                    Spacer()
                    Button(action: {
                        self._isReverse.toggle()
                        self._isEnd = false
                        self._page = 0
                        self._chapters.removeAll()
                        self._loadData()
                    }) {
                        Text(self._isReverse ? "正序" : "倒序")
                    }
                }.frame(height: 44.0)) {
                    ForEach(self._chapters) { model in
                        if self.isShowMenu {
                            Button(action: {
                                self.isShowMenu = false
                                self.vm.loadData(model.href)
                            }) {
                                Text(model.title ?? "").frame(height: 40.0)
                            }
                        } else {
                            NavigationLink(destination: ReaderView(detailModel: self.model, model: model)) {
                                Text(model.title ?? "").frame(height: 40.0)
                            }
                        }
                    }
                    Text(self._isEnd ? "没有更多数据了" : "加载中...").onAppear {
                        self._loadData()
                    }
                }
            }
        }.themeColor(self.colorScheme).navigationBarTitle(Text(self.model?.title ?? "章节"), displayMode: .inline)
    }
    
    func _loadData() {
        DispatchQueue.global().async {
            var dls = self.model?.html?.xPath("//div[@id=\"list\"]//dl")?.first?.children ?? []
            if !dls.isEmpty {
                dls = Array(dls[11...])
            }
            dls = self._isReverse ? dls.reversed() : dls
            let start = (self._page * self._limit)
            let end = min(start + self._limit, dls.count)
            self._isEnd = end == dls.count
            if end == dls.count {
                return
            }
            var chapters: [ChapterModel] = []
            for dl in dls[start..<end] {
                let href = dl.xPath(".//a").first?.attributes["href"]
                let title = dl.xPath(".//a//text()").first?.content
                chapters.append(ChapterModel(title: title, href: href))
            }
            self._page += 1
            DispatchQueue.main.async {
                self._chapters += chapters
            }
        }
    }
}

struct ChapterView_Previews: PreviewProvider {
    @State var _i: Bool = false
    static var previews: some View {
        ChapterView(isShowMenu: ChapterView_Previews().$_i, vm: ChapterViewModel(), model: DetailModel(title: "title", statu: "", update: "", lastChapter: "", html: nil)).environment(\.colorScheme, .light)
    }
}
