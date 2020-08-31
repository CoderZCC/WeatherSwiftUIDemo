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

struct NoResultModel: Decodable {
    
}

enum APIError: Error {
    /// 网络出错
    case networkError
    /// 请求出错
    case requestError
}

struct APIManager {
    
    static let _cache: NSCache = NSCache<AnyObject, AnyObject>()
    /// 网络请求
    /// - Parameter modelT: model模型
    static func start<T: Decodable>(_ target: APIEnum, modelT: T.Type, handler: ((T?)->Void)? ) {
        if let d = APIManager.read(valueFor: target) as? Data, let model = try? JSONDecoder().decode(BaseModel<T>.self, from: d) {
            handler?(model.data)
            return
        }
        let session = URLSession.shared
        let task = session.dataTask(with: target.request) { (data, rsp, error) in
            if let d = data {
                print(String(data: d, encoding: .utf8) ?? "")
                do {
                    let model = try JSONDecoder().decode(BaseModel<T>.self, from: d)
                    handler?(model.data)
                    APIManager.set(value: d, key: target)
                } catch {
                    print("数据转模型失败:\(error)")
                    handler?(nil)
                }
            } else {
                print("error:\(error?.localizedDescription ?? "")")
                handler?(nil)
            }
        }
        task.resume()
    }
}

extension APIManager {
    
    static func set(value: Any, key: APIEnum) {
        //APIManager._cache.setValue(value, forKey: key.cacheKey)
    }
    
    static func read(valueFor key: APIEnum) -> Any? {
        //return APIManager._cache.value(forKey: key.cacheKey)
        return nil
    }
}
