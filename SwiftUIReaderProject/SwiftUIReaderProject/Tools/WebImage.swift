//
//  WebImage.swift
//  WeatherSwiftUIDemo
//
//  Created by ZCC on 2020/8/25.
//  Copyright © 2020 zcc. All rights reserved.
//

import SwiftUI

let kImageFilePath = NSHomeDirectory() + "/Documents/images"

struct WebImage: View {
    
    /// 图片加载器
    @ObservedObject var _imageLoader: _ImageLoader
    /// 展位
    private var _placeholder: Text?
    private let _configuration: (Image) -> Image
    
    init(_ imgPath: String?, placeholder: Text? = Text("加载中..."), configuration: @escaping (Image) -> Image = { $0 }) {
        
        self._configuration = configuration
        self._imageLoader = _ImageLoader(loadPath: imgPath)
        self._placeholder = placeholder
    }
    
    var body: some View {
        finalImage.onDisappear(perform: self.cancel)
    }
    
    private var finalImage: some View {
        Group {
            if self._imageLoader.cacheImage != nil {
                self._configuration(Image(uiImage: self._imageLoader.cacheImage!))
            } else {
                if self._imageLoader.image != nil {
                    self._configuration(Image(uiImage: self._imageLoader.image!))
                } else {
                    self._placeholder
                }
            }
        }
    }
    
    func load() {
        self._imageLoader.load()
    }
    
    func cancel() {
        self._imageLoader.cancel()
    }
    
    func _loadFromCache(imgPath: String?) -> UIImage? {
        guard let imgPath = imgPath else { return nil }
        if let img = _ImageCache.read(valueFor: imgPath) as? UIImage {
            return img
        } else {
            let filePath = kImageFilePath + (imgPath.components(separatedBy: "/").last ?? "1.png")
            let file = FileManager.default
            if file.isReadableFile(atPath: filePath) {
                if let img = UIImage(contentsOfFile: filePath) {
                    return img
                }
            }
        }
        return nil
    }
}

class _ImageLoader: ObservableObject {
    
    @Published var image: UIImage?
    /// 加载地址
    var loadPath: String?
    /// 缓存图片
    var cacheImage: UIImage? {
        // 读取内存
        if let img = _ImageCache.read(valueFor: self.loadPath ?? "") as? UIImage {
            self.cancel()
            return img
        }
        // 读取本地
        let filePath = kImageFilePath + (self.loadPath?.components(separatedBy: "/").last ?? "1.png")
        let file = FileManager.default
        if file.isReadableFile(atPath: filePath) {
            if let img = UIImage(contentsOfFile: filePath) {
                self.cancel()
                return img
            }
        }
        return nil
    }
    
    private var _task: URLSessionTask?
    private var _isLoading: Bool = false
    
    init(loadPath: String?) {
        self.loadPath = loadPath
        self.load()
    }
    
    func load() {
        if self.cacheImage != nil || self._isLoading { return }
        guard let path = self.loadPath, let url = URL(string: path) else { return }
        self._isLoading = true
        // 请求网络
        self._task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let d = data, let img = UIImage(data: d) {
                // 缓存到本地
                let filePath = kImageFilePath + (path.components(separatedBy: "/").last ?? "1.png")
                NSData(data: d).write(toFile: filePath, atomically: true)
                // 缓存到内存
                _ImageCache.set(value: img, key: url.absoluteString)
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

struct _ImageCache {
    static let _cache = NSCache<AnyObject, AnyObject>()
    
    static func set(value: Any, key: String) {
        _ImageCache._cache.setObject(value as AnyObject, forKey: key as AnyObject)
    }
    
    static func read(valueFor key: String) -> Any? {
        return _ImageCache._cache.object(forKey: key as AnyObject)
    }
    
    static func delete(valueFor key: String) {
        return _ImageCache._cache.removeObject(forKey: key as AnyObject)
    }
}

struct WebImage_Previews: PreviewProvider {
    static var previews: some View {
        WebImage( "https://h5tq.moji.com/tianqi/assets/images/skin/day_1.jpg", placeholder: Text("加载中..."))
    }
}
