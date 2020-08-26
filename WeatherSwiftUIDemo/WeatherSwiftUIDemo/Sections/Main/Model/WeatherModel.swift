//
//  WeatherModel.swift
//  WeatherSwiftUIDemo
//
//  Created by 北京摩学教育科技有限公司 on 2020/8/25.
//  Copyright © 2020 zcc. All rights reserved.
//

import SwiftUI

struct WeatherModel: Decodable {
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
