//
//  APIManager.swift
//  SwiftUIHotNewsProject
//
//  Created by 北京摩学教育科技有限公司 on 2020/9/3.
//  Copyright © 2020 ZCC. All rights reserved.
//
import SwiftUI
import Combine
import Ji

enum APIEnum {
    case html(_ path: String?)
    
    var url: URL{
        switch self {
        case .html(let path):
            let new = path ?? kHtmlPath
            return URL(string: new.hasPrefix("http") ? new : kHtmlPath + new)!
        }
    }
}

struct APIManager {
    
    /// 开始请求
    /// - Parameter target: target
    /// - Returns: AnyPublisher
    static func start(_ target: APIEnum) -> AnyPublisher<Ji?, Never> {
        let bgQueue = DispatchQueue.global()
        if kDebug {
            let filePath = Bundle.main.path(forResource: "", ofType: "html") ?? ""
            return filePath.publisher.map({ (_) -> Ji? in
                return Ji(htmlString: try! String(contentsOfFile: filePath))
            }).subscribe(on: bgQueue).eraseToAnyPublisher()
        } else {
            return URLSession.shared.dataTaskPublisher(for: target.url).timeout(60.0, scheduler: bgQueue).map { (output) -> Ji? in
                return Ji(htmlData: output.data)
            }.replaceError(with: nil).subscribe(on: bgQueue).eraseToAnyPublisher()
        }
    }
}
