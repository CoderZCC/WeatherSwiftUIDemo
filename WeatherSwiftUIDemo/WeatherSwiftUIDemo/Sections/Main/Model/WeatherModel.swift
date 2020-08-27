//
//  WeatherModel.swift
//  WeatherSwiftUIDemo
//
//  Created by 北京摩学教育科技有限公司 on 2020/8/25.
//  Copyright © 2020 zcc. All rights reserved.
//

import SwiftUI

struct WeatherModel: Decodable, Equatable {
    
    static func == (lhs: WeatherModel, rhs: WeatherModel) -> Bool {
        return lhs.now?.updateTime == rhs.now?.updateTime
    }
    
    let now: NowModel?
    let threeDays: [ThreeDaysModel]?
    let monthWeather: [MonthWeatherModel]?
    
    enum CodingKeys: String, CodingKey {
        case now, threeDays, monthWeather
    }
    
    var dealArr: [[MonthWeatherModel]] {
        var finalArr: [[MonthWeatherModel]] = []
        var tempArr: [MonthWeatherModel] = []
        self.monthWeather?.forEach({ (model) in
            tempArr.append(model)
            if tempArr.count % 7 == 0 {
                finalArr.append(tempArr)
                tempArr.removeAll()
            }
        })
        return finalArr
    }
}

struct NowModel: Decodable {
    let skin: String?
    let temperature: String?
    let tempRange: String?
    let thubmImage: String?
    let description: String?
    let humidity: String?
    let wind: String?
    let tips: String?
    let aqi: Int?
    let aqiIcon: String?
    let aqiDesc: String?
    let aqiNum: Int?
    let updateTime: String?
    let address: String?
}

struct ThreeDaysModel: Decodable, Identifiable, Hashable {
    var id = UUID()
    
    let time: String?
    let thumbImage: String?
    let description: String?
    let tempRange: String?
    let wind: String?
    let wind_level: String?
    let aqi: Int?
    let aqiNum: Int?
    let aqiDesc: String?
    
    enum CodingKeys: String, CodingKey {
        case time, thumbImage, description, tempRange, wind, wind_level, aqi, aqiNum, aqiDesc
    }
}

struct MonthWeatherModel: Decodable, Identifiable, Hashable {
    var id = UUID()
    
    let day: String?
    let img: String?
    let imgDesc: String?
    let tempRange: String?
    let wind: String?
    
    var isToday: Bool {
        return false
    }
    
    enum CodingKeys: String, CodingKey {
        case day, img, imgDesc, tempRange, wind
    }
}

