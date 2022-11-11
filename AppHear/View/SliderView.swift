//
//  SliderView.swift
//  AppHear
//
//  Created by Jason Kenneth on 26/10/22.
//

import SwiftUI

struct SliderView: View {
    
    @Environment(\.managedObjectContext) var moc
    @Binding var value: Double
    @State var lastCoordinateValue: CGFloat = 0.0
    var sliderRange: ClosedRange<Double> = 0...100
    
    var body: some View {
        GeometryReader { read in
            let size = read.size.height * 0.8
            let radius = read.size.height * 0.5
            let minValue = read.size.width * 0.0001
            let maxValue = (read.size.width * 1) - size
            let scale = (maxValue - minValue) / (sliderRange.upperBound - sliderRange.lowerBound)
            let lower = sliderRange.lowerBound
            let sliderVal = (self.value - lower) * scale + minValue
            
            ZStack {
                RoundedRectangle(cornerRadius: radius)
                    .foregroundColor(Color(red: 66/255, green: 84/255, blue: 182/255))
                    .frame(height: 8)
                HStack {
                    Circle()
                        .foregroundColor(Color(red: 255/255, green: 176/255, blue: 61/255))
                        .frame(width: 13, height: 13)
                        .offset(x: sliderVal)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { slider in
                                    if (abs(slider.translation.width) < 0.1) {
                                        self.lastCoordinateValue = sliderVal
                                    }
                                    if slider.translation.width > 0 {
                                        let nextCoordinateValue = min(maxValue, self.lastCoordinateValue + slider.translation.width)
                                        self.value = ((nextCoordinateValue - minValue) / scale)  + lower
                                    } else {
                                        let nextCoordinateValue = max(minValue, self.lastCoordinateValue + slider.translation.width)
                                        self.value = ((nextCoordinateValue - minValue) / scale) + lower
                                    }
                                    
                                }
                        )
                    Spacer()
                }
            }
        }
    }
}
