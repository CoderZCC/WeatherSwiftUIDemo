//
//  WebImage.swift
//  WeatherSwiftUIDemo
//
//  Created by 北京摩学教育科技有限公司 on 2020/8/25.
//  Copyright © 2020 zcc. All rights reserved.
//

import SwiftUI

struct WebImage<Placeholder: View>: View {
    
    /// 图片加载地址
    var imgPath: String?
    /// 图片加载器
    @ObservedObject private var _imageLoader = ImageLoader()
    /// 展位
    private var _placeholder: Placeholder?
    
    init(imgPath: String?, placeholder: Placeholder?) {
        self.imgPath = imgPath
        self._placeholder = placeholder
        self._imageLoader.loadUrl = URL(string: imgPath ?? "")
    }
    
    var body: some View {
        finalImage.onAppear(perform: self.load).onDisappear(perform: self.cancel)
    }
    
    private var finalImage: some View {
        Group {
            if self._imageLoader.image != nil {
                Image(uiImage: self._imageLoader.image!)
            } else {
                self._placeholder
            }
        }
    }
    
    func load() {
        self._imageLoader.load()
    }
    
    func cancel() {
        self._imageLoader.cancel()
    }
}

class ImageLoader: ObservableObject {
    
    @Published var image: UIImage?
    var loadUrl: URL?
    private var _task: URLSessionTask?
    private var _isLoading: Bool = false
    
    
    func load() {
        if self._isLoading { return }
        guard let url = self.loadUrl else { return }
        self._isLoading = true
        self._task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let d = data, let img = UIImage(data: d) {
                DispatchQueue.main.async {
                    self.image = img
                }
            } else {
                print("error:\(error?.localizedDescription ?? "")")
            }
            self._isLoading = false
        }
        self._task?.resume()
    }
    
    func cancel() {
        self._isLoading = false
        self._task?.cancel()
    }
    
    deinit {
        self.cancel()
    }
}

struct WebImage_Previews: PreviewProvider {
    static var previews: some View {
        WebImage(imgPath: "https://h5tq.moji.com/tianqi/assets/images/skin/day_1.jpg", placeholder: Text("加载中..."))
    }
}
