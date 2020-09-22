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
        ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
            kSkin.resizable().aspectRatio(contentMode: .fill)
            VStack(spacing: 0.0) {
                Text(model?.now?.address ?? "北京市").font(.system(size: 12.0)).padding(.top, 2.0).padding(.bottom, 4.0)
                
                HStack(spacing: 6.0) {
                    kThumb.resizable().frame(width: 55.0, height: 55.0)
                    VStack(alignment: .leading, spacing: 4.0) {
                        Text(model?.now?.description ?? "").font(.system(size: 14.0, weight: .semibold)).padding(.trailing, 26.0)
                        
                        Text("\(model?.now?.temperature ?? "")°").font(.system(size: 12.0, weight: .semibold))
                        
                        Text("\(model?.now?.aqiNum ?? 0)  \(model?.now?.aqiDesc ?? "")" ).font(.system(size: 10.0, weight: .semibold)).padding(EdgeInsets(top: 1.0, leading: 6.0, bottom: 1.0, trailing: 6.0)).background(model?.now?.bgColor).cornerRadius(6.0)
                    }
                }.padding(.bottom, 12.0)
                
                HStack(spacing: 6.0) {
                    DayView(model: model?.threeDays?.first)
                    DayView(model: model?.threeDays?[1])
                    DayView(model: model?.threeDays?.last)
                }
            }
        }.foregroundColor(.white).modifier(ContentTextModifier())
    }
    
}

struct DayView: View {
    var model: DayModel?
    
    var body: some View {
        VStack(spacing: 4.0) {
            Text(self.model?.time ?? "a").font(.system(size: 12.0, weight: .semibold))
            kThumb1.resizable().frame(width: 20.0, height: 20.0)
            Text(self.model?.tempRange ?? "a").font(.system(size: 12.0, weight: .semibold))
        }
    }
}

