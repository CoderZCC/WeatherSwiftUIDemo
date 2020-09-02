//
//  Macro.swift
//  SwiftUIReaderProject
//
//  Created by 北京摩学教育科技有限公司 on 2020/9/1.
//  Copyright © 2020 ZCC. All rights reserved.
//

import SwiftUI

let kDebug = false
let kStringCoding = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(UInt32(CFStringEncodings.GB_18030_2000.rawValue)))
let kHtmlPath: String = "https://www.aikantxt.la/"
let kScreenW = UIScreen.main.bounds.width
let kScreenH = UIScreen.main.bounds.height
var kRootVC: BaseHostingController?
