//
//  AddressViewModel.swift
//  WeatherSwiftUIDemo
//
//  Created by 北京摩学教育科技有限公司 on 2020/8/27.
//  Copyright © 2020 zcc. All rights reserved.
//

import SwiftUI

class AddressViewModel: ObservableObject {
    
    @Published var modelArr: [AddressModel]?
    
    func loadData() {
        APIManager.start(.address, modelT: [AddressModel].self) { [weak self] (model) in
            if model != self?.modelArr {
                DispatchQueue.main.async {
                    self?.modelArr = model
                }
            }
        }
    }
    
    func setAddress(model: AddressModel?, block: ((Int?)->Void)?) {
        guard let model = model else { return }
        UserDefaults.standard.setValue(model.addressId, forKey: kAddressKey)
        UserDefaults.standard.synchronize()
        var addressId: Int?
        for i in 0..<(self.modelArr?.count ?? 0) {
            addressId = self.modelArr?[i].addressId
            self.modelArr?[i].isChoice = addressId == model.addressId
        }
        DispatchQueue.main.async {
            block?(addressId)
        }
    }
}
