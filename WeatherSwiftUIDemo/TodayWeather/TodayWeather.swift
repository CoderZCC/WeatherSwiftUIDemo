//
//  TodayWeather.swift
//  TodayWeather
//
//  Created by 北京摩学教育科技有限公司 on 2020/9/22.
//  Copyright © 2020 zcc. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

var kSkin: Image = Image("day_1")
var kThumb: Image = Image("w1")
var kThumb1: Image = Image("w1")
var kThumb2: Image = Image("w1")
var kThumb3: Image = Image("w1")

struct BaseModel: Decodable {
    let data: SubModel?
}

struct SubModel: Decodable {
    let now: WeatherModel?
    let threeDays: [DayModel]?
}

struct WeatherModel: Decodable {
    let skin: String?
    let thubmImage: String?
    
    let temperature: String?
    let tempRange: String?
    let description: String?
    let humidity: String?
    let wind: String?
    let tips: String?
    let aqi: Int?
    let aqiDesc: String?
    let aqiNum: Int?
    let updateTime: String?
    let address: String?
    
    var weekday: String {
        return "今天 星期三"
    }
    
    var bgColor: Color {
        switch self.aqiNum ?? 0 {
        case 0:
            return Color(red: 126.0 / 255.0, green: 186.0 / 255.0, blue: 25.0 / 255.0)
        case 1:
            return Color(red: 205.0 / 255.0, green: 161.0 / 255.0, blue: 15.0 / 255.0)
        case 2:
            return Color(red: 237.0 / 255.0, green: 134, blue: 10.0 / 255.0)
        case 3:
            return Color(red: 216.0 / 255.0, green: 32, blue: 21.0 / 255.0)
        default:
            return Color(red: 76.0 / 255.0, green: 60.0 / 255.0, blue: 134.0 / 255.0)
        }
    }
}

struct DayModel: Decodable {
    let thumbImage: String?
    
    let time: String?
    let description: String?
    let tempRange: String?
    let wind: String?
    let wind_level: String?
    let aqi: Int?
    let aqiNum: Int?
    let aqiDesc: String?
}

let kDayModel = DayModel(thumbImage: "https://h5tq.moji.com/tianqi/assets/images/weather/w1.png", time: "今天", description: "多云", tempRange: "17°/26°", wind: "东北风", wind_level: "一级", aqi: 23, aqiNum: 0, aqiDesc: "优")
let kWeatherModel = WeatherModel(skin: "https://h5tq.moji.com/tianqi/assets/images/skin/day_1.jpg", thubmImage: "https://h5tq.moji.com/tianqi/assets/images/weather/w1.png", temperature: "26", tempRange: "17°/26°", description: "多云", humidity: "湿度 31%", wind: "东风3级", tips: "冷热适宜，感觉很舒适。", aqi: 24, aqiDesc: "优", aqiNum: 0, updateTime: "今天14:00更新", address: "北京市朝阳区")
let kSubModel = SubModel(now: kWeatherModel, threeDays: [kDayModel, kDayModel, kDayModel])
let kDefaultModel = SimpleEntry(date: Date(), configuration: ConfigurationIntent(), model: kSubModel)

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        kDefaultModel
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        completion(kDefaultModel)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let apiPath: String = "http://www.ccserver.top/api/v1/weather?addressId=276"
        var request = URLRequest(url: URL(string: apiPath)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60.0)
        request.addValue("MTU4NzczMzcyNzUzMzEzMTp0ZXN0", forHTTPHeaderField: "device-token")
        
        URLSession.shared.dataTask(with: request) { (data, rsp, error) in
            var finalModel: SubModel?
            if let d = data, let m = try? JSONDecoder().decode(BaseModel.self, from: d) {
                finalModel = m.data
                
                self._download(finalModel?.now?.skin) { (imgData)  in
                    if let imgData = imgData, let img = UIImage(data: imgData) {
                        kSkin = Image(uiImage: img)
                    }
                }
                self._download(finalModel?.now?.thubmImage) { (imgData) in
                    if let imgData = imgData, let img = UIImage(data: imgData) {
                        kThumb = Image(uiImage: img)
                    }
                }
                self._download(finalModel?.threeDays?.first?.thumbImage) { (imgData) in
                    if let imgData = imgData, let img = UIImage(data: imgData) {
                        kThumb1 = Image(uiImage: img)
                    }
                }
                self._download(finalModel?.threeDays?[1].thumbImage) { (imgData) in
                    if let imgData = imgData, let img = UIImage(data: imgData) {
                        kThumb2 = Image(uiImage: img)
                    }
                }
                self._download(finalModel?.threeDays?.last?.thumbImage) { (imgData) in
                    if let imgData = imgData, let img = UIImage(data: imgData) {
                        kThumb3 = Image(uiImage: img)
                    }
                }
            }
            let now = Date()
            let timeline = Timeline(entries: [SimpleEntry(date: now, configuration: configuration, model: finalModel ?? kSubModel)], policy: .after(now.addingTimeInterval(60.0 * 60.0)))
            completion(timeline)
        }.resume()
    }
    
    func _download(_ path: String?, block: ((Data?)->Void)?) {
        if let p = path, let url = URL(string: p) {
            URLSession.shared.dataTask(with: url) { (data, rsp, error) in
                block?(data)
            }.resume()
        } else {
            block?(nil)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let model: SubModel?
}

struct TodayWeatherEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family: WidgetFamily
    
    var body: some View {
        switch family {
        case .systemSmall:
            SmallView(model: entry.model)
        case .systemMedium:
            MediumView(model: entry.model)
        default:
            SmallView(model: entry.model)
        }
    }
}

struct MediumView: View {
    var model: SubModel?
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .center)) {
            kSkin.resizable().aspectRatio(contentMode: .fill)
            Text(model?.now?.address ?? "北京市").font(.system(size: 12.0, weight: .semibold)).position(x: 50.0, y: 50.0)
            
            VStack {
                
                HStack {
                    kThumb.resizable().frame(width: 65.0, height: 65.0)
                    
                    VStack(alignment: .leading, spacing: 4.0) {
                        Text(model?.now?.weekday ?? "").font(.system(size: 14.0, weight: .semibold))
                        
                        Text(model?.now?.description ?? "").font(.system(size: 22.0, weight: .semibold))
                        
                        Text("\(model?.now?.temperature ?? "")°").font(.system(size: 18.0, weight: .semibold))
                        
                        Text("\(model?.now?.aqiNum ?? 0)  空气质量\(model?.now?.aqiDesc ?? "")" ).font(.system(size: 14.0, weight: .semibold)).padding(EdgeInsets(top: 2.0, leading: 6.0, bottom: 2.0, trailing: 6.0)).background(model?.now?.bgColor).cornerRadius(6.0)
                    }
                    Spacer().frame(width: 30.0)
                    VStack {
                        DayMediumView(model: model?.threeDays?.first)
                        DayMediumView(model: model?.threeDays?[1])
                        DayMediumView(model: model?.threeDays?.last)
                    }
                }

            }
            
        }.foregroundColor(.white)
    }
}

struct DayMediumView: View {
    var model: DayModel?
    
    var body: some View {
        HStack(spacing: 4.0) {
            Text(self.model?.time ?? "a").font(.system(size: 14.0, weight: .semibold))
            kThumb1.resizable().frame(width: 26.0, height: 26.0)
            Text(self.model?.tempRange ?? "a").font(.system(size: 14.0, weight: .semibold))
        }
    }
}


// MARK: -文字内容样式
struct ContentTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.shadow(color: .init(UIColor.black.withAlphaComponent(0.5)), radius: 10, x: 0.0, y: 0.0)
    }
}

@main
struct TodayWeather: Widget {
    let kind: String = "TodayWeather"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            TodayWeatherEntryView(entry: entry)
        }
        .configurationDisplayName("今日天气")
        .description("显示您所在地区的天气")
    }
}

struct TodayWeather_Previews: PreviewProvider {
    static var previews: some View {
        TodayWeatherEntryView(entry: kDefaultModel)
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
