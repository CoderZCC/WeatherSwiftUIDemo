//
//  AddressViewModel.swift
//  WeatherSwiftUIDemo
//
//  Created by ZCC on 2020/8/27.
//  Copyright © 2020 zcc. All rights reserved.
//

import SwiftUI

class AddressViewModel: ObservableObject {
    
    @Published var modelArr: [AddressModel]?
    var allAddress: [AddressModel]?
    
    func search(_ input: String) {
        guard let arr = self.allAddress else { return }
        if input.isEmpty {
            self.modelArr = self.allAddress
        } else {
            var newArr: [AddressModel] = []
            for m in arr {
                let name = m.name ?? ""
                if name.contains(input) || input.contains(name) {
                    newArr.append(m)
                }
            }
            self.modelArr = newArr
        }
    }
    
    func loadData() {
        let filePath = Bundle.main.path(forResource: "address", ofType: "json")!
        let d = try! Data(contentsOf: URL(fileURLWithPath: filePath))
        let model = try? JSONDecoder().decode(BaseModel<[AddressModel]>.self, from: d)
        // 查出已选地区
        var finalArr = model?.data
        if let cacheId = UserDefaults.standard.value(forKey: kAddressKey) as? Int {
            for i in 0..<(finalArr?.count ?? 0) {
                let addressId = finalArr?[i].addressId
                finalArr?[i].isChoice = addressId == cacheId
            }
        }
        self.allAddress = finalArr
        self.modelArr = finalArr
        
//        APIManager.start(.address, modelT: [AddressModel].self) { [weak self] (model) in
//            if model != self?.modelArr {
//                // 查出已选地区
//                var finalArr = model
//                if let cacheId = UserDefaults.standard.value(forKey: kAddressKey) as? Int {
//                    for i in 0..<(finalArr?.count ?? 0) {
//                        let addressId = finalArr?[i].addressId
//                        finalArr?[i].isChoice = addressId == cacheId
//                    }
//                }
//                self?.allAddress = finalArr
//                DispatchQueue.main.async {
//                    self?.modelArr = finalArr
//                }
//            }
//        }
    }
    
    func setAddress(model: AddressModel?, block: ((Int?)->Void)?) {
        guard let model = model else { return }
        UserDefaults.standard.setValue(model.addressId, forKey: kAddressKey)
        UserDefaults.standard.synchronize()
        for i in 0..<(self.modelArr?.count ?? 0) {
            let addressId = self.modelArr?[i].addressId
            self.modelArr?[i].isChoice = addressId == model.addressId
        }
        DispatchQueue.main.async {
            block?(model.addressId)
        }
    }
}
