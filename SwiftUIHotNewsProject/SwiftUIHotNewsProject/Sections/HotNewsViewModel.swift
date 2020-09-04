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
    @Published var isLoading: Bool = false
    
    func loadData() {
        self.isLoading = true
        APIManager.start(.html(kHtmlPath)).receive(on: DispatchQueue.main).sink(receiveCompletion: { [weak self] _ in
            if self?.model == nil {
                print("出错,继续请求")
            }
        }) { [weak self] (ji) in
            self?.isLoading = false
            var segements: [SegementModel] = []
            let divs = ji?.xPath("//div[@class=\"cc-cd\"]/div") ?? []
            for div in divs {
                let icon = div.xPath("./div[@class=\"cc-cd-ih\"]//img/@src").first?.content
                let title = div.xPath("./div[@class=\"cc-cd-ih\"]//a/div[@class=\"cc-cd-lb\"]/text()").first?.content
                let subTitle = div.xPath("./div[@class=\"cc-cd-ih\"]//span//text()").first?.content
                let href = div.xPath("./div[@class=\"cc-cd-ih\"]//a/@href").first?.content
                let update = div.xPath("./div[@class=\"cc-cd-if\"]/div[@class=\"i-h\"]").first?.content
                
                var content: [ContentModel] = []
                let aArr = div.xPath(".//div[@class=\"cc-cd-cb-l nano-content\"]/a")
                for a in aArr {
                    let href = a.attributes["href"]
                    let num = a.xPath(".//span//text()").first?.content
                    let title = a.xPath(".//span[@class=\"t\"]/text()").first?.content
                    let subTitle = a.xPath(".//span[@class=\"e\"]/text()").first?.content
                    content.append(ContentModel(num: num, title: title, href: href, subTitle: subTitle))
                }
                segements.append(SegementModel(title: title, href: href, icon: icon, subTitle: subTitle, content: content, update: update))                
            }
            self?.model = HotNewsModel(segements: segements)
        }.cancel()
    }
}
