//
//  APIManager.swift
//  SwiftUIReaderProject
//
//  Created by 北京摩学教育科技有限公司 on 2020/9/1.
//  Copyright © 2020 ZCC. All rights reserved.
//

import SwiftUI
import Combine
import Ji

enum APIEnum {
    case html(_ htmlPath: String)
    
    var path: String {
        switch self {
        case .html(let path):
            path.hasPrefix("http") ? path: kHtmlPath + path
            return path
        }
    }
}

struct APIManager {
    
    /// 开始请求
    /// - Parameter target: html
    /// - Returns: AnyPublisher
    static func start(_ target: APIEnum) -> AnyPublisher<Ji?, URLError> {
        let request = URLRequest(url: URL(string: target.path)!)
        let bgQueue = DispatchQueue.global()
        //let publisher = URLSession.shared.dataTaskPublisher(for: request).retry(3).timeout(10.0, scheduler: bgQueue).map({ $0.data }).decode(type: BaseModel.self, decoder: JSONDecoder()).subscribe(on: bgQueue).eraseToAnyPublisher()
        if kDebug {
//            let home = Bundle.main.path(forResource: "home", ofType: "html")!
//            return home.publisher.mapError({ (_) -> URLError in
//                return URLError(.badURL)
//            }).map { (filePath) -> Ji? in
//                var htmlStr: String = (try? String(contentsOf: URL(fileURLWithPath: home))) ?? ""
//                htmlStr = htmlStr.replacingOccurrences(of: "charset=gbk", with: "charset=utf8")
//                return Ji(htmlString: htmlStr)
//            }.subscribe(on: bgQueue).eraseToAnyPublisher()
            
            
            var filePath: String!
            switch target {
            case .html(let path):
                if path == kHtmlPath {
                    filePath = Bundle.main.path(forResource: "home", ofType: "html")!
                } else if path.hasPrefix("https://m.aikantxt.la/") {
                    filePath = Bundle.main.path(forResource: "chapters", ofType: "html")!
                } else {
                    filePath = Bundle.main.path(forResource: "detail", ofType: "html")!
                }
            }
            return filePath.publisher.mapError({ (_) -> URLError in
                return URLError(.badURL)
            }).map { (_) -> Ji? in
                var htmlStr: String = (try? String(contentsOf: URL(fileURLWithPath: filePath))) ?? ""
                htmlStr = htmlStr.replacingOccurrences(of: "gbk", with: "utf8")
                htmlStr = htmlStr.replacingOccurrences(of: "<br/>", with: "\n")
                htmlStr = htmlStr.replacingOccurrences(of: "&nbsp;", with: " ")
                htmlStr = htmlStr.replacingOccurrences(of: "&gt;", with: ">")
                return Ji(htmlString: htmlStr)
            }.subscribe(on: bgQueue).eraseToAnyPublisher()
        } else {
            return URLSession.shared.dataTaskPublisher(for: request).timeout(10.0, scheduler: bgQueue).map { (output) -> Ji? in
                var htmlStr = String(data: output.data, encoding: kStringCoding) ?? ""
                htmlStr = htmlStr.replacingOccurrences(of: "gbk", with: "utf8")
                htmlStr = htmlStr.replacingOccurrences(of: "<br/>", with: "\n")
                htmlStr = htmlStr.replacingOccurrences(of: "&nbsp;", with: " ")
                htmlStr = htmlStr.replacingOccurrences(of: "&gt;", with: ">")
                return Ji(htmlString: htmlStr)
            }.subscribe(on: bgQueue).eraseToAnyPublisher()
        }
    }
}
