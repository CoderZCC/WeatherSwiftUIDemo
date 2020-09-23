//
//  SmallView.swift
//  SpecialDayExtension
//
//  Created by 北京摩学教育科技有限公司 on 2020/9/22.
//  Copyright © 2020 zcc. All rights reserved.
//

import SwiftUI

struct MediumView: View {
    var model: SubModel?
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .center)) {
            kSkin.resizable().aspectRatio(contentMode: .fill)
            VStack {
                HStack(alignment: .center, spacing: 16.0) {
                    
                    SmallContentView(now: model?.now)
                    
                    VStack(spacing: 10.0) {
                        Text("\(model?.now?.aqi ?? 0) \(model?.now?.aqiDesc ?? "")" ).font(.system(size: 14.0, weight: .semibold)).padding(EdgeInsets(top: 2.0, leading: 6.0, bottom: 2.0, trailing: 6.0)).background(model?.now?.bgColor).cornerRadius(6.0)
                        
                        Text(model?.now?.humidity ?? "").font(.system(size: 14.0, weight: .semibold))
                        
                        Text(model?.now?.wind ?? "").font(.system(size: 14.0, weight: .semibold))
                    }
                    VStack {
                        DayMediumView(model: model?.threeDays?.first, image: kThumb1)
                        DayMediumView(model: model?.threeDays?[1], image: kThumb2)
                        DayMediumView(model: model?.threeDays?.last, image: kThumb3)
                    }
                }
            }
            
        }.foregroundColor(.white)
    }
}

struct DayMediumView: View {
    var model: DayModel?
    var image: Image
    
    var body: some View {
        HStack(spacing: 4.0) {
            Text(self.model?.time ?? "a").font(.system(size: 14.0, weight: .semibold))
            image.resizable().frame(width: 26.0, height: 26.0)
            Text(self.model?.tempRange ?? "a").font(.custom("DINCond-Bold", size: 14.0))
        }
    }
}
