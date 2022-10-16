//
//  VizualizerView.swift
//  AppHear
//
//  Created by Jason Kenneth on 16/10/22.
//

import SwiftUI

struct VizualizerView: View {
    var value: CGFloat
    let numberOfSamples: Int = 30
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(red: 85/255, green: 105/255, blue: 193/255, opacity: 1.0))
            
//            (LinearGradient(gradient: Gradient(colors: [.indigo, .indigo]), startPoint: .topTrailing, endPoint: .bottomLeading))
            
                .frame(width: (UIScreen.main.bounds.width - CGFloat(numberOfSamples) * 10) / CGFloat(numberOfSamples), height: value)
        }
    }
}

struct VizualizerView_Previews: PreviewProvider {
    static var previews: some View {
        VizualizerView(value: 200)
    }
}
