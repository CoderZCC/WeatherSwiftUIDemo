//
//  WebImage.swift
//  WeatherSwiftUIDemo
//
//  Created by 北京摩学教育科技有限公司 on 2020/8/25.
//  Copyright © 2020 zcc. All rights reserved.
//

import SwiftUI

struct WebImage: View {
    
    var imgPath: String?
    /// 图片
    @State private var _image: UIImage = UIImage(named: "default")!
    
    var body: some View {
        Image(uiImage: self._image).resizable().onAppear(perform: self._downloadImage)
    }
    
    private func _downloadImage() {
        print("加载图片:\(self.imgPath ?? "")")
        guard let imgPath = self.imgPath, let url = URL(string: imgPath) else { return }
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let d = data, let img = UIImage(data: d) {
                self._image = img
            } else {
                print("error:\(error?.localizedDescription ?? "")")
            }
        }.resume()
    }
}

struct WebImage_Previews: PreviewProvider {
    static var previews: some View {
        WebImage(imgPath: "https://h5tq.moji.com/tianqi/assets/images/skin/day_1.jpg")
    }
}
