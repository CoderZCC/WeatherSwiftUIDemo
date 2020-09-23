//
//  SmallView.swift
//  SpecialDayExtension
//
//  Created by 北京摩学教育科技有限公司 on 2020/9/22.
//  Copyright © 2020 zcc. All rights reserved.
//

import SwiftUI

struct SmallView: View {
    var model: SubModel?
    
    var body: some View {
        ZStack {
            kSkin.resizable().aspectRatio(contentMode: .fill)
            VStack(spacing: 2.0) {
                Text(model?.now?.address ?? "北京市").font(.system(size: 12.0)).foregroundColor(Color.white.opacity(0.6))
                
                Text("\(model?.now?.temperature ?? "")°C").font(.custom("DINCond-Bold", size: 55.0)).foregroundColor(.white).modifier(ContentTextModifier())
                
                kThumb.resizable().frame(width: 22.0, height: 22.0)
                
                Text(model?.now?.description ?? "").font(.system(size: 20.0, weight: .semibold)).foregroundColor(.white).modifier(ContentTextModifier())
                
                Text(model?.now?.updateTime ?? "").font(.system(size: 10.0, weight: .semibold)).foregroundColor(Color.white.opacity(0.6))
            }
        }
    }
}
