//
//  AddressModel.swift
//  WeatherSwiftUIDemo
//
//  Created by 北京摩学教育科技有限公司 on 2020/8/27.
//  Copyright © 2020 zcc. All rights reserved.
//

import SwiftUI

struct AddressModel: Decodable, Hashable, Identifiable {
    var id = UUID()
    let addressId: Int?
    let name: String?
    let parentId: Int?
    let parentName: String?
    
    var isChoice: Bool = false
    
    /// 自定义字段属性 需要遵守Codingkey  2.每个字段都要枚举
    enum CodingKeys: String, CodingKey {
        case addressId = "id"
        case name, parentId, parentName
    }
}
