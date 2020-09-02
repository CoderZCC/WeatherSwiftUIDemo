//
//  SwiftUIView.swift
//  SwiftUIReaderProject
//
//  Created by 北京摩学教育科技有限公司 on 2020/9/1.
//  Copyright © 2020 ZCC. All rights reserved.
//

import SwiftUI

class BaseHostingController: UIHostingController<HomeView> {
    
    /// 状态栏类型
    var statusBarStyle: UIStatusBarStyle = .default {
        didSet {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    @objc override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
}
