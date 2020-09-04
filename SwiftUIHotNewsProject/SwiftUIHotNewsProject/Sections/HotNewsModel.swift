//
//  ContentModel.swift
//  SwiftUIHotNewsProject
//
//  Created by 北京摩学教育科技有限公司 on 2020/9/3.
//  Copyright © 2020 ZCC. All rights reserved.
//

import UIKit

struct HotNewsModel {
    let segements: [SegementModel]?
}

struct SegementModel: Identifiable {
    var id = UUID()
    
    let title: String?
    let href: String?
    let icon: String?
    let subTitle: String?
    let content: [ContentModel]?
    let update: String?
}

struct ContentModel: Identifiable {
    var id = UUID()
    
    let num: String?
    let title: String?
    let href: String?
    let subTitle: String?
}
