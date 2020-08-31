//
//  WeatherMainView.swift
//  WeatherSwiftUIDemo
//
//  Created by ZCC on 2020/8/25.
//  Copyright © 2020 zcc. All rights reserved.
//

import SwiftUI

struct WeatherView: View {
    
    /// 全局存储
    /// @State只标注值类型,class是引用类型
    @ObservedObject private var _vm = WeatherViewModel()
    @State private var _isShow: Bool = false
    
    var body: some View {
        
        self.contentView.opacity(1.0).animation(Animation.easeInOut(duration: 0.4)).onAppear {
            self.loadData()
        }
    }
    
    var contentView: some View {
        VStack {
            Button(action: {
                self._isShow.toggle()
            }) {
                Image("location")
                Text(self._vm.model?.now?.address ?? "").font(Font.system(size: 20.0)).fontWeight(.semibold)
                Image(systemName: "list.bullet")
            }.sheet(isPresented: self.$_isShow) {
                AddressView(isShow: self.$_isShow, weatherVM: self._vm)
            }.frame(width: kScreenW - kHorizontalSapce * 2.0, height: kNavBarHeight, alignment: .leading).offset(y: 20.0)
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    AqiView(model: self._vm.model?.now)
                    Spacer(minLength: 10.0).frame(width: kScreenW - kHorizontalSapce * 2.0)
                    WeatherMsgView(model: self._vm.model?.now)
                    
                    HStack(spacing: 20.0) {
                        Text(self._vm.model?.now?.humidity ?? "").fontWeight(.semibold)
                        Text(self._vm.model?.now?.wind ?? "").fontWeight(.semibold)
                    }.font(Font.system(size: 20.0))
                    
                    Spacer(minLength: 20.0)
                    TipsView(model: self._vm.model?.now)
                    
                    Spacer(minLength: 16.0)
                    FutureView(models: self._vm.model?.threeDays)
                    
                    Spacer(minLength: 16.0)
                    CalendarView(model: self._vm.model)
                }
            }
        }.foregroundColor(Color.white).background(WebImage(self._vm.model?.now?.skin, configuration: { $0.resizable() }).scaledToFill()).edgesIgnoringSafeArea(.all).statusBar(hidden: false)
    }
    
    func loadData() {
        self._isShow = !self._vm.isAddressId
        self._vm.loadData()
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: OperationQueue.current) { (_) in
            self._vm.loadData()
        }
    }
}

// MARK: -天气信息
struct WeatherMsgView: View {
    var model: NowModel?
    
    var body: some View {
        HStack(spacing: 16.0) {
            Text(self.model?.temperature ?? "").font(Font.custom("DINCond-Bold", size: 130.0))
            WebImage(self.model?.thubmImage).scaledToFit().frame(width: 100.0, height: 100.0).offset(x: 0.0, y: 12.0)
            Text(self.model?.description ?? "").font(Font.system(size: 30.0)).fontWeight(.semibold).offset(x: 0.0, y: 30.0)
        }
    }
}

// MARK: -天气状况
struct AqiView: View {
    var model: NowModel?
    
    var body: some View {
        HStack(spacing: 10.0) {
            ZStack {
                Group {
                    if self.model?.aqiNum == 0 {
                        Circle().fill(Color(r: 126, g: 186, b: 25))
                    } else if self.model?.aqiNum == 1 {
                        Circle().fill(Color(r: 205, g: 161, b: 15))
                    } else if self.model?.aqiNum == 2 {
                        Circle().fill(Color(r: 237, g: 134, b: 10))
                    } else if self.model?.aqiNum == 3 {
                        Circle().fill(Color(r: 216, g: 32, b: 21))
                    } else if self.model?.aqiNum == 4 {
                        Circle().fill(Color(r: 76, g: 60, b: 134))
                    }
                }.frame(width: 30.0, height: 30.0)
                WebImage(self.model?.aqiIcon) { (img) -> Image in
                    return img.resizable()
                }.frame(width: 15.0, height: 15.0)
            }
            Text("\(self.model?.aqi ?? 0)" + " " + (self.model?.aqiDesc ?? "")).fontWeight(.semibold)
        }.padding(.init(top: 0.0, leading: 8.0, bottom: 0.0, trailing: 16.0)).frame(height: 42.0).background(Color.black.opacity(0.3)).cornerRadius(21.0)
    }
}

// MARK: -今日天气提示
struct TipsView: View {
    var model: NowModel?
    
    var body: some View {
        HStack(spacing: 18.0) {
            Text("今日天气提示").fontWeight(.semibold).frame(width: 124.0, height: 30.0).background(Color.black.opacity(0.3)).cornerRadius(15.0)
            Text(self.model?.tips ?? "").fontWeight(.semibold)
        }.frame(maxWidth: kScreenW - kHorizontalSapce * 2.0, alignment: .leading).font(Font.system(size: 16.0))
    }
}

// MARK: -未来三天
struct FutureView: View {
    var models: [ThreeDaysModel]?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("预告").fontWeight(.semibold).modifier(ContentTextModifier()).padding(.top, 10.0).padding(.leading, kHorizontalSapce)
            
            ForEach(self.models ?? []) {model in
                FutureContentView(model: model)
            }
            Spacer(minLength: 10.0)
            
        }.background(Color.black.opacity(0.3)).cornerRadius(8.0)
    }
}

// MARK: -未来三天内容
struct FutureContentView: View {
    var model: ThreeDaysModel
    var body: some View {
        HStack(spacing: 16.0) {
            Text(model.time ?? "").fontWeight(.semibold).modifier(ContentTextModifier())
            WebImage(model.thumbImage, configuration: { $0.resizable() }).frame(width: 28.0, height: 28.0).scaledToFit()
            Text(model.description ?? "").fontWeight(.semibold).modifier(ContentTextModifier())
            Text(model.tempRange ?? "").fontWeight(.semibold).modifier(ContentTextModifier())
            Text(model.wind ?? "").fontWeight(.semibold).modifier(ContentTextModifier())
            Text(model.wind_level ?? "").fontWeight(.semibold).modifier(ContentTextModifier())
        }.padding(.init(top: 2.0, leading: kHorizontalSapce, bottom: 0.0, trailing: kHorizontalSapce))
    }
}

// MARK: -天气日历
struct CalendarView: View {
    var model: WeatherModel?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("天气日历").fontWeight(.semibold).padding(.top, 10.0).padding(.leading, kHorizontalSapce)
            HStack(spacing: 0.0) {
                ForEach(kWeekDays.indices) { i in
                    Text("星期\(kWeekDays[i])").font(Font.system(size: 14.0)).fontWeight(.semibold).frame(width: (kScreenW - kHorizontalSapce * 2.0) / CGFloat(kWeekDays.count), height: 40.0, alignment: .center)
                }
            }
            ForEach((self.model?.dealArr ?? []).indices, id: \.self) { i in
                HStack(spacing: 0.0) {
                    ForEach((self.model?.dealArr ?? [])[i].indices, id: \.self) { j in
                        MonthContentView(model: self.model?.dealArr[i][j])
                    }
                }
            }
        }.background(Color.black.opacity(0.3)).cornerRadius(8.0)
    }
}

// MARK: -天气日历内容
struct MonthContentView: View {
    var model: MonthWeatherModel?
    
    var body: some View {
        VStack {
            Text(self.model?.day ?? "").font(Font.system(size: 16.0)).fontWeight(.semibold)
            WebImage(self.model?.img, placeholder: Text(self.model?.imgDesc ?? "加载中...")) { (img) -> Image in
                return img.resizable()
            }.frame(width: 30.0, height: 30.0, alignment: .center)
            Text(self.model?.tempRange ?? "").font(Font.system(size: 14.0)).fontWeight(.semibold)
            Text(self.model?.wind ?? "").font(Font.system(size: 14.0)).fontWeight(.semibold)
        }.frame(width: (kScreenW - kHorizontalSapce * 2.0) / CGFloat(kWeekDays.count), height: 150.0).border(Color.white.opacity(0.2), width: 0.5)
    }
}

// MARK: -文字内容样式
struct ContentTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.font(Font.system(size: 16.0))
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}
