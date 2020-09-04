//
//  HotNewsView.swift
//  SwiftUIHotNewsProject
//
//  Created by 北京摩学教育科技有限公司 on 2020/9/3.
//  Copyright © 2020 ZCC. All rights reserved.
//

import SwiftUI

struct HotNewsView: View {
    
    @EnvironmentObject var vm: HotNewsViewModel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            
            ForEach(self.vm.model?.segements ?? []) { m1 in
                
                HStack {
                    List(m1.content ?? []) { model in
                        ClickContentView(model: model).frame(width: kScreenW, height: kScreenH)
                    }
                    
                }

                
            }
            
        }.foregroundColor(Color.black).onAppear {
            self.vm.loadData()
        }

    }
}

struct ClickContentView: View {
    var model: ContentModel
    @State private var _isShow: Bool = false
    
    var body: some View {
        Button(action: {
            self._isShow.toggle()
        }) {
            HStack {
                Text(self.model.num ?? "").font(Font.headline)
                Text(self.model.title ?? "").font(Font.headline).padding(8.0)
                Spacer()
                Text(self.model.subTitle ?? "").font(Font.subheadline)
            }
        }.sheet(isPresented: self.$_isShow) {
            DetailView(model: self.model)
        }
    }
}

struct HotNewsView_Previews: PreviewProvider {
    static var previews: some View {
        HotNewsView().environmentObject(HotNewsViewModel())
    }
}
