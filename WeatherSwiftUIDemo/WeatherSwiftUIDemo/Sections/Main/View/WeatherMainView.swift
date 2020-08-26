//
//  WeatherMainView.swift
//  WeatherSwiftUIDemo
//
//  Created by 北京摩学教育科技有限公司 on 2020/8/25.
//  Copyright © 2020 zcc. All rights reserved.
//

import SwiftUI

struct WeatherMainView: View {
    
    /// @State只标注值类型,class是引用类型
    @ObservedObject private var _vm = WeatherViewModel()
    
    var body: some View {
        VStack {
                        
            Spacer(minLength: 30.0)
            
            HStack {
                Text(self._vm.model?.address ?? "").font(Font.system(size: 20.0)).fontWeight(.semibold)
                Button(action: {
                    print("aaa")
                }) {
                    Image(systemName: "plus.circle.fill")
                }
            }
            
            ScrollView {
                VStack(alignment: .leading) {
                    AqiView(vm: self._vm)
                    Spacer(minLength: 10.0)
                    WeatherView(vm: self._vm)
                    
                    HStack {
                        Text(self._vm.model?.humidity ?? "").fontWeight(.semibold)
                        Text(self._vm.model?.wind ?? "").fontWeight(.semibold)
                    }.font(Font.system(size: 20.0))
                    
                    Spacer(minLength: 20.0)
                    TipsView(vm: self._vm)
                    
                }.frame(width: kScreenW, height: nil, alignment: .center).padding(.init(top: 0.0, leading: -16.0, bottom: 0.0, trailing: 0.0))
            }
            }.foregroundColor(Color.red).background(WebImage<Text>(imgPath: "https://h5tq.moji.com/tianqi/assets/images/skin/day_1.jpg", placeholder: nil).scaledToFill()).onAppear(perform: self._vm.loadData).edgesIgnoringSafeArea(.all)
    }
}


// MARK: -天气信息
struct WeatherView: View {
    @ObservedObject var vm: WeatherViewModel
    
    var body: some View {
        HStack {
            Text(self.vm.model?.temperature ?? "33").font(Font.custom("DINCond-Bold", size: 130.0))
            WebImage<Text>(imgPath: "https://h5tq.moji.com/tianqi/assets/images/weather/w1.png", placeholder: nil).scaledToFit().frame(width: 100.0, height: 100.0, alignment: .center).offset(x: 0.0, y: 12.0)
            Text(self.vm.model?.description ?? "晴").font(Font.system(size: 30.0)).fontWeight(.semibold).offset(x: 0.0, y: 30.0)
        }
    }
}

// MARK: -天气状况
struct AqiView: View {
    @ObservedObject var vm: WeatherViewModel
    
    var body: some View {
        HStack {
            ZStack {
                Group {
                    Circle().fill(Color.green)
                }.frame(width: 30.0, height: 30.0, alignment: .center)
                WebImage<Text>(imgPath: self.vm.model?.aqiIcon, placeholder: nil).frame(width: 16.0, height: 16.0, alignment: .center).scaledToFit()
            }
            Text("\(self.vm.model?.aqiNum ?? 0)").foregroundColor(Color.white).fontWeight(.semibold)
            Text(self.vm.model?.aqiDesc ?? "").foregroundColor(Color.white).fontWeight(.semibold)
        }.padding(.init(top: 0.0, leading: 8.0, bottom: 0.0, trailing: 16.0)).frame(width: nil, height: 42.0, alignment: .center).background(Color(r: 52.0, g: 70.0, b: 78.0)).cornerRadius(26.0)
    }
}

// MARK: -今日天气提示
struct TipsView: View {
    @ObservedObject var vm: WeatherViewModel
    
    var body: some View {
        HStack {
            ZStack {
                Text("今日天气提示").fontWeight(.semibold).frame(width: 124.0, height: 30.0, alignment: .center)
            }.background(Color(r: 52.0, g: 70.0, b: 78.0)).cornerRadius(15.0)
            
            Text(self.vm.model?.tips ?? "").fontWeight(.semibold)
        }.foregroundColor(Color.red).font(Font.system(size: 16.0))
    }
}

struct WeatherMainView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherMainView()
    }
}
