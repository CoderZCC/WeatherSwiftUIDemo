//
//  DataTest.swift
//  WeatherSwiftUIDemo
//
//  Created by 北京摩学教育科技有限公司 on 2020/8/26.
//  Copyright © 2020 zcc. All rights reserved.
//

import SwiftUI
import Combine

struct Test {
    var count: Int
//    var imgPath: String?
}

class TestModel: ObservableObject {
    @Published var model: Test?
    @Published var imgPath: String?
    
    func loadData() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.model = Test(count: 10)
            self.imgPath = "https://"
        }
    }
}

struct DataTest: View {
    @ObservedObject var model = TestModel()
    
    var body: some View {
        VStack {
            Button.init(action: {
                self.model.model!.count += 1
            }) {
                Text("已点击:\(self.model.model?.count ?? 0)次")
            }
            SecondTest(model: self.model, imgPath: self.model.imgPath ?? "")
        }.onAppear {
            self.model.loadData()
        }
    }
}

struct SecondTest: View {
    @ObservedObject var model: TestModel
    @State var imgPath: String
    
    var body: some View {
        VStack {
            Text("竟然点击了:\(self.model.model?.count ?? 0)次")
            Text(self.imgPath)
        }
    }
}

struct DataTest_Previews: PreviewProvider {
    static var previews: some View {
        DataTest()
    }
}
