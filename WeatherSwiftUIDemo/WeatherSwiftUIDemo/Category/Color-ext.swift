//
//  Color-ext.swift
//  WeatherSwiftUIDemo
//
//  Created by ZCC on 2020/8/26.
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

extension View {
    
    /// background
    /// - Parameters:
    ///   - colorScheme: 当前主题
    ///   - dark: dark
    ///   - light: light
    /// - Returns: 颜色
    @discardableResult
    func bgColor(_ colorScheme: ColorScheme, dark: Any, light: Any) -> some View {
        var c: Color!
        if colorScheme == .dark {
            c = self._createColor(color: dark)
        } else {
            c = self._createColor(color: light)
        }
        return self.background(c)
    }
    
    /// foregroundColor
    /// - Parameters:
    ///   - colorScheme: 当前主题
    ///   - dark: dark
    ///   - light: light
    /// - Returns: 颜色
    @discardableResult
    func foreColor(_ colorScheme: ColorScheme, dark: Any, light: Any) -> some View {
        var c: Color!
        if colorScheme == .dark {
            c = self._createColor(color: dark)
        } else {
            c = self._createColor(color: light)
        }
        return self.foregroundColor(c)
    }
    
    func _createColor(color: Any) -> Color {
        var c: Color!
        if color is Int {
            let num = color as! Int
            let r = Double((num & 0xFF0000) >> 16)
            let g = Double((num & 0x00FF00) >> 8)
            let b = Double((num & 0x0000FF))
            c = Color(r: r, g: g, b: b)
        } else if color is Color {
            c = color as? Color
        }
        return c
    }
}
