//
//  SpecialDay.swift
//  SpecialDay
//
//  Created by 北京摩学教育科技有限公司 on 2020/9/22.
//  Copyright © 2020 zcc. All rights reserved.
//

import WidgetKit
import SwiftUI

/// [0, x)
let kRandomInt = Int(arc4random()) % 6

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), imageIndex: kRandomInt)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), imageIndex: kRandomInt)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let num = Int(arc4random()) % 6
        /// 随机数
        let now = Date()
        let timeline = Timeline(entries: [SimpleEntry(date: now, imageIndex: num)], policy: .after(now.addingTimeInterval(60.0 * 30.0)))
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let imageIndex: Int
    
    let _calendar = Calendar.current
    var _specilDay: Date {
        let day = "2018-01-27"
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: day) ?? Date()
    }
    
    var year: Int {
        return self._calendar.dateComponents([.year], from: self._specilDay, to: self.date).year ?? 0
    }
    var day: Int {
        return self._calendar.dateComponents([.day], from: self._specilDay, to: self.date).day ?? 0
    }
    var dateFormatter: String {
        let hour = self._calendar.dateComponents([.hour], from: self._specilDay, to: self.date).hour ?? 0
        return "一起度过\(hour)小时"
    }
}

struct SpecialDayEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .center)) {
            Image("love\(entry.imageIndex)").resizable().aspectRatio(contentMode: .fill)
            VStack {
                Text("我们在一起已经").font(.system(size: 14.0, weight: .semibold)).modifier(ContentTextModifier())
                HStack(alignment: .bottom, spacing: 0.0) {
                    Text("\(entry.day)").font(.custom("DINCond-Bold", size: 60.0)).modifier(ContentTextModifier()).padding(4.0)
                    Text("天").font(.system(size: 12.0, weight: .bold)).modifier(ContentTextModifier()).offset(y: -12.0)
                }
                Text(entry.dateFormatter).font(.system(size: 12.0, weight: .bold)).modifier(ContentTextModifier())
            }
        }.foregroundColor(Color.white.opacity(0.8))
    }
}

// MARK: -文字内容样式
struct ContentTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.shadow(color: .init(UIColor.black.withAlphaComponent(0.4)), radius: 10, x: 0.0, y: 0.0)
    }
}

@main
struct SpecialDay: Widget {
    let kind: String = "SpecialDay"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            SpecialDayEntryView(entry: entry)
        }
        .configurationDisplayName("纪念日")
        .description("记录在一起的日子")
        .supportedFamilies([.systemSmall])
    }
}

struct SpecialDay_Previews: PreviewProvider {
    static var previews: some View {
        SpecialDayEntryView(entry: SimpleEntry(date: Date(), imageIndex: kRandomInt))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
