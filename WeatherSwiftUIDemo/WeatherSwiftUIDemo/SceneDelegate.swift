//
//  SceneDelegate.swift
//  WeatherSwiftUIDemo
//
//  Created by ZCC on 2020/8/25.
//  Copyright © 2020 zcc. All rights reserved.
//

import UIKit
import SwiftUI

@UIApplicationMain
class SceneDelegate: UIResponder, UIWindowSceneDelegate, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        if #available(iOS 14.0, *) {
            self.test()
        }
        
        let contentView = WeatherView()
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
            
            kWindow = window
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        for context in URLContexts {
            print(context.url) // https://www.jianshu.com/u/bc4a806f89c5
        }
    }
}

import WidgetKit
extension SceneDelegate {
    
    @available(iOS 14.0, *)
    func test() {
        WidgetCenter.shared.getCurrentConfigurations { (result) in
            switch result {
            case .success(let infoArr):
                for info in infoArr where info.kind == "TodayWeather" {
                    
                    print(info)
//                    print(info.configuration)
//                    print(info.kind)
                }
            case .failure(let error):
                print("error:\(error)")
            }
        }
    }
}
