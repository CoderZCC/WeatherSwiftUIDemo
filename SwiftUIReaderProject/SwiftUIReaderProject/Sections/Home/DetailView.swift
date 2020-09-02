//
//  DetailView.swift
//  SwiftUIReaderProject
//
//  Created by 北京摩学教育科技有限公司 on 2020/9/1.
//  Copyright © 2020 ZCC. All rights reserved.
//

import SwiftUI

struct DetailView: View {
    var model: HotModel
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject private var _vm = DetailViewModel()
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                DetailHeaderView(listModel: self.model, detailModel: self._vm.model)
                DetailClickView(model: self._vm.model)
            }.frame(width: kScreenW).navigationBarTitle(Text(self.model.title ?? "详情"), displayMode: .inline).themeColor(self.colorScheme).onAppear {
                self._vm.loadData(self.model.href)
            }
        }
    }
}

// MARK: -头部
struct DetailHeaderView: View {
    
    var listModel: HotModel
    var detailModel: DetailModel?
    
    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 10.0) {
                WebImage(self.listModel.cover, configuration: { $0.resizable() }).frame(width: 130.0, height: 200.0).cornerRadius(8.0).shadow(color: Color.black, radius: 8.0, x: 0.0, y: 1.0)
                VStack(alignment: .leading, spacing: 4.0) {
                    Text((self.listModel.title ?? "")).font(Font.title).lineLimit(2)
                    Spacer()
                    Text("作者：" + (self.listModel.author ?? "")).font(Font.headline).lineLimit(1)
                    Text(self.detailModel?.statu ?? "").font(Font.headline)
                    Text(self.detailModel?.update ?? "").font(Font.headline).frame(width: kScreenW - 130.0 - 16.0 - 10.0 - 16.0, alignment: .leading)
                    Text(self.detailModel?.lastChapter ?? "").font(Font.headline).frame(width: kScreenW - 130.0 - 16.0 - 10.0 - 16.0, alignment: .leading)
                }
            }
            Text(self.listModel.desc ?? "").frame(width: kScreenW - 32.0).padding(.bottom, 20.0)
        }
    }
    
}

// MARK: -按钮组
struct DetailClickView: View {
    var model: DetailModel?
    @State var _isShowMenu: Bool = false
    
    var body: some View {
        VStack(spacing: 10.0) {
            HStack {
                NavigationLink(destination: ReaderView(detailModel: self.model, model: self.model?.lastModel)) {
                    
                    Text("开始阅读").foregroundColor(Color.white).frame(width: (kScreenW - 32.0) / 2.0, height: 40.0)
                    
                }.cornerRadius(4.0).background(Color(r: 85, g: 172, b: 231))
                
                NavigationLink(destination: ChapterView(isShowMenu: self.$_isShowMenu, vm: ChapterViewModel(), model: self.model)) {
                    
                    Text("查看目录").foregroundColor(Color.white).frame(width: (kScreenW - 32.0) / 2.0, height: 40.0)
                    
                }.cornerRadius(4.0).background(Color(r: 85, g: 172, b: 231))
            }
            
//            HStack {
//                Button(action: {
//
//                }) {
//                    Text("加入书架").foregroundColor(Color.white).frame(width: (kScreenW - 32.0) / 2.0, height: 40.0)
//                }.cornerRadius(4.0).background(Color(r: 85, g: 172, b: 231))
//                Button(action: {
//
//                }) {
//                    Text("点击下载").foregroundColor(Color.white).frame(width: (kScreenW - 32.0) / 2.0, height: 40.0)
//                }.cornerRadius(4.0).background(Color(r: 85, g: 172, b: 231))
//            }
        }
    }
}


struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(model: HotModel(href: "https://www.aikantxt.la/aikan28861/", cover: "https://www.aikantxt.la/files/article/image/28/28861/28861s.jpg", title: "最强医圣林奇", desc: "林奇瞧准位置，真气喷涌，朝着一处穴位拍去。啪的一声，真气涌入穴位之中，顿时止住了疼痛，这一瞬间，胖子觉的这脸被打的舒服极了，那感觉让他忍不住轻呼道：“爽！实在是太爽了！”只是这一幕，让刚才那些蹲在地..", author: "阿会")).environment(\.colorScheme, .dark)
    }
}
