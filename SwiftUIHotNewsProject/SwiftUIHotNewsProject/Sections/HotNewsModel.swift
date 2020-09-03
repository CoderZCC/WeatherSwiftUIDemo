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

struct SegementModel {
    let title: String?
    let href: String?
    let icon: String?
    let subTitle: String?
    let content: [ContentModel]?
    let update: String?
}

struct ContentModel {
    let num: String?
    let title: String?
    let href: String?
    let subTitle: String?
}
