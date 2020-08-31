//
//  WeatherAddressView.swift
//  WeatherSwiftUIDemo
//
//  Created by ZCC on 2020/8/27.
//  Copyright © 2020 zcc. All rights reserved.
//

import SwiftUI

struct AddressView: View {
    
    @Binding var isShow: Bool
    @ObservedObject var weatherVM: WeatherViewModel
    @ObservedObject private var _vm = AddressViewModel()
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        return NavigationView {
            List {
                SearchView(vm: self._vm)
                Section(header: Text("北京")) {
                    ForEach(self._vm.modelArr ?? []) { model in
                        Button(action: {
                            if model.isChoice {
                                self.isShow.toggle()
                            } else {
                                self._vm.setAddress(model: model) { (_) in
                                    self.weatherVM.loadData()
                                    self.isShow.toggle()
                                }
                            }
                        }) {
                            AddressContentView(model: model)
                        }
                    }
                }
            }.navigationBarTitle("选择地区")
        }.foreColor(self.colorScheme, dark: Color.white, light: Color.black).onAppear(perform: self._vm.loadData)
    }
}

struct SearchView: View {
    
    @ObservedObject var vm: AddressViewModel
    @State var _input: String = ""
    
    var body: some View {
        VStack {
            TextField("搜索", text: self.$_input, onCommit:  {
                self.vm.search(self._input)
            }).keyboardType(.default).textFieldStyle(RoundedBorderTextFieldStyle())
        }
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
    
    @State var isShow: Bool = true
    @ObservedObject private var _vm = WeatherViewModel()
    
    static var previews: some View {
        AddressView(isShow: AddressView_Previews().$isShow, weatherVM: AddressView_Previews()._vm).environment(\.colorScheme, .dark)
    }
}
