//
//  HotNewsView.swift
//  SwiftUIHotNewsProject
//
//  Created by 北京摩学教育科技有限公司 on 2020/9/3.
//  Copyright © 2020 ZCC. All rights reserved.
//

import SwiftUI

struct HotNewsView: View {
    @ObservedObject var vm = HotNewsViewModel()
    
    var body: some View {
        List([""], id: \.self) { model in
            Text("dassa")
        }.onAppear {
            

        }
    }
}

struct HotNewsView_Previews: PreviewProvider {
    static var previews: some View {
        HotNewsView()
    }
}
