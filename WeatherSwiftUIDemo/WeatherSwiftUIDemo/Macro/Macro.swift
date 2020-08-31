//
//  Macro.swift
//  WeatherSwiftUIDemo
//
//  Created by 北京摩学教育科技有限公司 on 2020/8/25.
//  Copyright © 2020 zcc. All rights reserved.
//

import SwiftUI

let kDebug: Bool = false
//let kDebug: Bool = true

var kWindow: UIWindow?
let kBasePath: String = "http://www.ccserver.top"
let kScreenW = UIScreen.main.bounds.width
let kScreenH = UIScreen.main.bounds.height
let kTopSafeH: CGFloat = kWindow?.safeAreaInsets.top ?? 20.0
let kIphoneX: Bool = kTopSafeH > 20.0
let kNavBarHeight: CGFloat = 44.0 + kTopSafeH

let kImageFilePath = NSHomeDirectory() + "/Documents/images"

let kWeekDays = ["天", "一", "二", "三", "四", "五", "六"]

/// 水平方向间隔
let kHorizontalSapce: CGFloat = 16.0

let kTokenKey: String = "kTokenKey"
/// 地区key
let kAddressKey: String = "kAddressKey"

