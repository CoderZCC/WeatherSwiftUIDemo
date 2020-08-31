//
//  WeatherAddressView.swift
//  WeatherSwiftUIDemo
//
//  Created by 北京摩学教育科技有限公司 on 2020/8/27.
//  Copyright © 2020 zcc. All rights reserved.
//

import SwiftUI

struct AddressView: View {
    
    @Binding var isShow: Bool
    @ObservedObject private var _vm = AddressViewModel()
    
    var body: some View {
        return NavigationView {
            List {
                Section(header: Text("北京")) {
                    ForEach(self._vm.modelArr ?? []) { model in
                        Button(action: {
                            self._vm.setAddress(model: model) { (_) in
                                self.isShow.toggle()
                            }
                        }) {
                            AddressContentView(model: model)
                        }
                    }
                }
            }
            .navigationBarTitle("设置地区")
        }.onAppear(perform: self._vm.loadData)
    }
}

struct AddressContentView: View {
    var model: AddressModel
    
    var body: some View {
        HStack {
            Text(self.model.name ?? "1")
            Spacer()
            Group {
                if self.model.isChoice {
                    Image(systemName: "checkmark")
                }
            }
        }
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
//        AddressView()
        Text("")
    }
}
