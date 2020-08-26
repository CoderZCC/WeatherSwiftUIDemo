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
    case setAddress(cityId: Int)
    case weatherNow
    case weatherThreeDays
}

extension APIEnum {
    
    var path: String {
        switch self {
        case .address:
            return "/api/v1/weatheraddress"
        case .setAddress(_):
            return "/api/v1/weatheraddress"
        case .weatherNow:
            return "/api/v1/weathernow"
        case .weatherThreeDays:
            return "/api/v1/weatherthreedays"
        }
    }
    
    var method: String {
        switch self {
        case .setAddress(_):
            return "POST"
        default:
            return "GET"
        }
    }
    
    var body: [String: Any]? {
        switch self {
        case .setAddress(let cityId):
            return ["cityId": cityId]
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
        return ["Content-Type": "application/json", "device-token": "MTU4NzczMzcyNzUzMzEzMTp0ZXN0"]
    }
}
