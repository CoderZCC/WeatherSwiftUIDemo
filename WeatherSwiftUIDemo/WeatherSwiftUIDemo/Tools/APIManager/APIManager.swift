//
//  APIManager.swift
//  WeatherSwiftUIDemo
//
//  Created by 北京摩学教育科技有限公司 on 2020/8/25.
//  Copyright © 2020 zcc. All rights reserved.
//

import UIKit

struct BaseModel<T: Decodable>: Decodable {
    let code: Int?
    let message: String?
    let data: T?
}

enum APIError: Error {
    /// 网络出错
    case networkError
    /// 请求出错
    case requestError
}

struct APIManager {
        
    /// 网络请求
    /// - Parameter modelT: model模型
    static func start<T: Decodable>(_ target: APIEnum, modelT: T.Type, handler: ((T?)->Void)? ) {
        let filePath = Bundle.main.path(forResource: "test", ofType: "json")!
        let d = try! Data(contentsOf: URL(fileURLWithPath: filePath))
        let model = try? JSONDecoder().decode(BaseModel<T>.self, from: d)
        handler?(model?.data)
        
        let session = URLSession.shared
        session.dataTask(with: target.request) { (data, rsp, error) in
            if let d = data {
                print(String(data: d, encoding: .utf8) ?? "")
                do {
                    let model = try JSONDecoder().decode(BaseModel<T>.self, from: d)
                    handler?(model.data)
                } catch {
                    print("数据转模型失败:\(error)")
                    handler?(nil)
                }
            } else {
                print("error:\(error?.localizedDescription ?? "")")
                handler?(nil)
            }
        }.resume()
    }
}
