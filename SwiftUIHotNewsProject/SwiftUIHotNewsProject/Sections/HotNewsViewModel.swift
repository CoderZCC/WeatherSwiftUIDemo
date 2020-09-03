//
//  HotNewsViewModel.swift
//  SwiftUIHotNewsProject
//
//  Created by 北京摩学教育科技有限公司 on 2020/9/3.
//  Copyright © 2020 ZCC. All rights reserved.
//

import UIKit

class HotNewsViewModel: ObservableObject {
    
    @Published var model: HotNewsModel?
    
    func loadData() {
        
        APIManager.start(.html(kHtmlPath)).receive(on: DispatchQueue.main).sink(receiveCompletion: {_ in }) { (ji) in
            
            
            
        }.cancel()
    }
}
