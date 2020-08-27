//
//  Color-ext.swift
//  WeatherSwiftUIDemo
//
//  Created by 北京摩学教育科技有限公司 on 2020/8/26.
//  Copyright © 2020 zcc. All rights reserved.
//

import SwiftUI

extension Color {
    
    /// 设置颜色
    /// - Parameters:
    ///   - r: 0.0-255.0
    ///   - g: 0.0-255.0
    ///   - b: 0.0-255.0
    init(r: Double, g: Double, b: Double) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0)
    }
    
    static var random: Color {
        return Color(r: Double(arc4random() % 255), g: Double(arc4random() % 255), b: Double(arc4random() % 255))
    }
}
