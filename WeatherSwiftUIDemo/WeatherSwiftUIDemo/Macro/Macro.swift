//
//  Macro.swift
//  WeatherSwiftUIDemo
//
//  Created by 北京摩学教育科技有限公司 on 2020/8/25.
//  Copyright © 2020 zcc. All rights reserved.
//

import SwiftUI

var kWindow: UIWindow?
let kBasePath: String = "http://www.ccserver.top"
let kScreenW = UIScreen.main.bounds.width
let kScreenH = UIScreen.main.bounds.height
let kNavBarHeight: CGFloat = 44.0 + (kWindow?.safeAreaInsets.top ?? 20.0)

let kTopSafeH: CGFloat = 20.0

let kImageFilePath = NSHomeDirectory() + "/Documents/images"

let kMonthDays = ["天", "一", "二", "三", "四", "五", "六"]
