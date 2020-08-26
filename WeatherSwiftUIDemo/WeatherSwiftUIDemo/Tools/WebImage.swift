//
//  WebImage.swift
//  WeatherSwiftUIDemo
//
//  Created by 北京摩学教育科技有限公司 on 2020/8/25.
//  Copyright © 2020 zcc. All rights reserved.
//

import SwiftUI

struct WebImage: View {
    
    /// 图片加载器
    @ObservedObject var _imageLoader: ImageLoader
    /// 展位
    private var _placeholder: Text?
    
    init(imgPath: String?, placeholder: Text? = Text("加载中...")) {
        self._placeholder = placeholder
        self._imageLoader = ImageLoader(loadPath: imgPath)
    }
    
    var body: some View {
        finalImage.onDisappear(perform: self.cancel)
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
    var loadPath: String?
    
    private var _task: URLSessionTask?
    private var _isLoading: Bool = false
    
    init(loadPath: String?) {
        self.loadPath = loadPath
        self.load()
    }
    
    func load() {
        if self._isLoading { return }
        guard let path = self.loadPath, let url = URL(string: path) else { return }
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
        self._task = nil
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
