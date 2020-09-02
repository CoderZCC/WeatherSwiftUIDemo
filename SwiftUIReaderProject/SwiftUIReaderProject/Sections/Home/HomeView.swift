//
//  HomeView.swift
//  SwiftUIReaderProject
//
//  Created by 北京摩学教育科技有限公司 on 2020/9/1.
//  Copyright © 2020 ZCC. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject private var _vm = HomeViewModel()
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            VStack {
                List(self._vm.model?.hotContents ?? []) { model in
                    NavigationLink(destination: DetailView(model: model)) {
                        HomeContentView(model: model)
                    }
                }.navigationBarTitle("首页")
            }
        }.themeColor(self.colorScheme).onAppear {
            self._vm.loadData()
        }
    }
}

struct HomeContentView: View {
    var model: HotModel
    
    var body: some View {
        HStack(alignment: .top, spacing: 10.0) {
            WebImage(model.cover, configuration: { $0.resizable() }).frame(width: 130.0, height: 200.0).cornerRadius(8.0).shadow(color: Color.black, radius: 8.0, x: 0.0, y: 1.0)
            VStack(alignment: .leading, spacing: 4.0) {
                Text(model.title ?? "").font(Font.title).lineLimit(2)
                Text(model.author ?? "").font(Font.headline).lineLimit(1)
                Spacer()
                Text(model.desc ?? "").font(Font.subheadline).lineLimit(4)
            }
        }.frame(height: 200.0)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environment(\.colorScheme, .dark)
    }
}
