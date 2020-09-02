//
//  ReaderView.swift
//  SwiftUIReaderProject
//
//  Created by 北京摩学教育科技有限公司 on 2020/9/2.
//  Copyright © 2020 ZCC. All rights reserved.
//

import SwiftUI

struct ReaderView: View {
    
    var detailModel: DetailModel?
    var model: ChapterModel?
    @ObservedObject private var _vm = ChapterViewModel()
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentation
    @State private var _isShowMenu: Bool = false
    @State private var _bgColor: Color = Color(r: 249, g: 243, b: 231)
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.presentation.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark.circle").resizable().renderingMode(.original).frame(width: 26.0, height: 26.0)
                }.padding(.leading, 16.0)
                Spacer()
                Text(self._vm.isLoading ? "加载中..." : "").padding(.trailing, 16.0)
            }
            
            ScrollView(showsIndicators: false) {
                VStack {
                    Text(self._vm.model?.content ?? "加载中").frame(width: kScreenW - 32.0).foregroundColor(Color.black)
                    Spacer().frame(height: 60.0)
                }
            }
            
            ToolBarView(model: self._vm.model, vm: self._vm, isShowMenu: self.$_isShowMenu).frame(width: kScreenW)
            
        }.background(self._bgColor.edgesIgnoringSafeArea(.all)).navigationBarTitle(Text("")).navigationBarHidden(true).onAppear {
            self._vm.loadData(self.model?.href)
        }.sheet(isPresented: self.$_isShowMenu) { () in
            ChapterView(isShowMenu: self.$_isShowMenu, vm: self._vm, model: self.detailModel)
        }
    }
}

struct ToolBarView: View {
    var model: ReaderModel?
    @ObservedObject var vm: ChapterViewModel
    @Binding var isShowMenu: Bool
    
    var body: some View {
        HStack {
            Button(action: {
                self.vm.loadData(self.model?.prevHref)
            }) {
                Text(self.model?.prevTitle ?? "")
                }.foregroundColor(self.model?.prevHref != nil ? Color.black : Color.gray).disabled(self.model?.prevHref == nil)
            
            Button(action: {
                self.isShowMenu.toggle()
            }) {
                Text("目录").frame(width: kScreenW / 3.0, height: 44.0)
            }.foregroundColor(Color.black)
            
            Button(action: {
                self.vm.loadData(self.model?.nextHref)
            }) {
                Text(self.model?.nextTitle ?? "")
            }.foregroundColor(self.model?.nextHref != nil ? Color.black : Color.gray).disabled(self.model?.nextHref == nil)
        }
    }
}

struct ReaderView_Previews: PreviewProvider {
    static var previews: some View {
        ReaderView(model: ChapterModel(title: "第001章", href: "/aikan28861/14862861.html"))
    }
}
