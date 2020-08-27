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
    @State var _isLoading: Bool = false
    
    var body: some View {
        VStack {
            HStack(spacing: 10.0) {
                Text(self._vm.model?.now?.address ?? "").font(Font.system(size: 20.0)).fontWeight(.semibold)
                Button(action: {
                    print("aaa")
                    
                }) {
                    Image(systemName: "plus.circle.fill")
                }
            }.frame(height: kNavBarHeight).offset(y: 10.0)
            
            ScrollView {
                VStack(alignment: .leading) {
                    AqiView(vm: self._vm)
                    Spacer(minLength: 10.0).frame(width: kScreenW - 32.0)
                    WeatherView(vm: self._vm)
                    
                    HStack(spacing: 10.0) {
                        Text(self._vm.model?.now?.humidity ?? "").fontWeight(.semibold)
                        Text(self._vm.model?.now?.wind ?? "").fontWeight(.semibold)
                    }.font(Font.system(size: 20.0))
                    
                    Spacer(minLength: 20.0)
                    TipsView(vm: self._vm)
                    
                    Spacer(minLength: 16.0)
                    FutureView(vm: self._vm)
                    
                    Spacer(minLength: 16.0)
                    CalendarView(vm: self._vm)
                }
            }
            
        }.foregroundColor(Color.white).background(WebImage(self._vm.model?.now?.skin, configuration: { $0.resizable() }).scaledToFill()).edgesIgnoringSafeArea(.all).statusBar(hidden: false).onAppear {
            
            self._vm.loadData()
            NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: OperationQueue.current) { (_) in
                self._vm.loadData()
            }
        }
    }
}

// MARK: -天气信息
struct WeatherView: View {
    @ObservedObject var vm: WeatherViewModel
    
    var body: some View {
        HStack(spacing: 14.0) {
            Text(self.vm.model?.now?.temperature ?? "").font(Font.custom("DINCond-Bold", size: 130.0))
            WebImage(self.vm.model?.now?.thubmImage).scaledToFit().frame(width: 100.0, height: 100.0).offset(x: 0.0, y: 12.0)
            Text(self.vm.model?.now?.description ?? "").font(Font.system(size: 30.0)).fontWeight(.semibold).offset(x: 0.0, y: 30.0)
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
                    if self.vm.model?.now?.aqiNum == 0 {
                        Circle().fill(Color(r: 126, g: 186, b: 25))
                    } else if self.vm.model?.now?.aqiNum == 1 {
                        Circle().fill(Color(r: 205, g: 161, b: 15))
                    } else if self.vm.model?.now?.aqiNum == 2 {
                        Circle().fill(Color(r: 237, g: 134, b: 10))
                    } else if self.vm.model?.now?.aqiNum == 3 {
                        Circle().fill(Color(r: 216, g: 32, b: 21))
                    } else if self.vm.model?.now?.aqiNum == 4 {
                        Circle().fill(Color(r: 76, g: 60, b: 134))
                    }
                }.frame(width: 30.0, height: 30.0)
                WebImage(self.vm.model?.now?.aqiIcon) { (img) -> Image in
                    return img.resizable()
                }.frame(width: 15.0, height: 15.0)
            }
            Text("\(self.vm.model?.now?.aqi ?? 0)").fontWeight(.semibold)
            Text(self.vm.model?.now?.aqiDesc ?? "").fontWeight(.semibold)
        }.padding(.init(top: 0.0, leading: 8.0, bottom: 0.0, trailing: 16.0)).frame(height: 42.0).background(Color.black.opacity(0.3)).cornerRadius(21.0)
    }
}

// MARK: -今日天气提示
struct TipsView: View {
    @ObservedObject var vm: WeatherViewModel
    
    var body: some View {
        HStack {
            ZStack {
                Text("今日天气提示").fontWeight(.semibold).frame(width: 124.0, height: 30.0)
            }.background(Color.black.opacity(0.3)).cornerRadius(15.0)
            
            Text(self.vm.model?.now?.tips ?? "").fontWeight(.semibold)
            }.font(Font.system(size: 16.0))
    }
}

let testModel = [TestModel(name: "zcc"), TestModel(name: "ws")]

// MARK: -未来三天
struct FutureView: View {
    @ObservedObject var vm: WeatherViewModel
    
    var body: some View {
        VStack {
            Text("预告").fontWeight(.semibold).modifier(ContentTextModifier()).padding(.top, 10.0)
            VStack {
                ForEach(self.vm.model?.threeDays ?? []) {model in
                    FutureContentView(model: model)
                }
            }.padding(.init(top: 0.0, leading: 20.0, bottom: 10.0, trailing: 20.0))
        }.background(Color.black.opacity(0.3)).cornerRadius(8.0)
    }
}

// MARK: -未来三天内容
struct FutureContentView: View {
    var model: ThreeDaysModel
    var body: some View {
        HStack(spacing: 12.0) {
            Text(model.time ?? "").fontWeight(.semibold).modifier(ContentTextModifier())
            WebImage(model.thumbImage, configuration: { $0.resizable() }).frame(width: 28.0, height: 28.0).scaledToFit()
            Text(model.description ?? "").fontWeight(.semibold).modifier(ContentTextModifier())
            Text(model.tempRange ?? "").fontWeight(.semibold).modifier(ContentTextModifier())
            Text(model.wind ?? "").fontWeight(.semibold).modifier(ContentTextModifier())
            Text(model.wind_level ?? "").fontWeight(.semibold).modifier(ContentTextModifier())
        }
    }
}

// MARK: -天气日历
struct CalendarView: View {
    @ObservedObject var vm: WeatherViewModel
    
    var body: some View {
        
        VStack {
            Text("天气日历")
        }
        

        
    }
}

// MARK: -文字内容样式
struct ContentTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.font(Font.system(size: 16.0))
    }
}

struct WeatherMainView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherMainView()
    }
}
