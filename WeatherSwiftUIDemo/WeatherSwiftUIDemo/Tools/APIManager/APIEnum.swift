//
//  APIEnum.swift
//  WeatherSwiftUIDemo
//
//  Created by 北京摩学教育科技有限公司 on 2020/8/25.
//  Copyright © 2020 zcc. All rights reserved.
//

import UIKit

enum APIEnum {
    case address
    case weather(cityId: Int)
}

extension APIEnum {
    
    var path: String {
        switch self {
        case .address:
            return "/api/v1/weatheraddress"
        case .weather(_):
            return "/api/v1/weather"
        }
    }
    
    var method: String {
        return "GET"
    }
    
    var body: [String: Any]? {
        switch self {
        case .weather(let cityId):
            return ["addressId": cityId]
        default:
            return nil
        }
    }
    
    var request: URLRequest {
        var request: URLRequest!
        if self.method == "GET" {
            var apiPath = self.path
            if let body = self.body {
                apiPath += ("?" + body.compactMap { (key, value) -> String in
                    return "\(key)=\(value)"
                }.joined(separator: "&"))
            }
            request = URLRequest(url: URL(string: kBasePath + apiPath)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30.0)
        } else if method == "POST" {
            request = URLRequest(url: URL(string: kBasePath + self.path)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30.0)
            if let body = self.body {
                request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
            }
        }
        request.httpMethod = self.method
        for item in self.headers {
            request.setValue(item.value, forHTTPHeaderField: item.key)
        }
        
        return request
    }
    
    var headers: [String: String] {     
        var userToken: String!
        if let t = UserDefaults.standard.value(forKey: kTokenKey) as? String {
            userToken = t
        } else {
            userToken = (String(Date().timeIntervalSince1970).replacingOccurrences(of: ".", with: "") + ":" + UIDevice.current.name).data(using: String.Encoding.utf8)?.base64EncodedString() ?? ""
        }
        userToken = "MTU4NzczMzcyNzUzMzEzMTp0ZXN0"
        return ["Content-Type": "application/json", "device-token": userToken]
    }
}
