//
//  WeatherViewModel.swift
//  WeatherSwiftUIDemo
//
//  Created by 北京摩学教育科技有限公司 on 2020/8/25.
//  Copyright © 2020 zcc. All rights reserved.
//

import SwiftUI

class WeatherViewModel: ObservableObject {
    
    // 能够被自动观察的对象属性，自动监视这个属性，一旦发生了改变，会自动修改与该属性绑定的界面
    @Published var model: WeatherModel?
    
    func loadData() {
//        let filePath = Bundle.main.path(forResource: "test", ofType: "json")!
//        let d = try! Data(contentsOf: URL(fileURLWithPath: filePath))
//        let model = try? JSONDecoder().decode(BaseModel<WeatherModel>.self, from: d)
//        self.model = model?.data
        
        guard let addressId = UserDefaults.standard.value(forKey: kAddressKey) as? Int else { return }
        APIManager.start(.weather(cityId: addressId), modelT: WeatherModel.self) { [weak self] (model) in
            if model != self?.model {
                DispatchQueue.main.async {
                    self?.model = model
                }
            }
        }
    }
}
