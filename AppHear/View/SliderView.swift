//
//  Slider.swift
//  AppHear
//
//  Created by Jason Kenneth on 14/11/22.
//

import SwiftUI

fileprivate let labelColor = Color(red: 66/255, green: 84/255, blue: 182/255)

struct SliderView: View
{
    var totalTime: CGFloat = 67
    
    @State var currentProgress: CGFloat = 0
    @State var progressState: CGFloat = 0
    
    @State var leftLabelWidth: CGFloat = 0
    
    @State var rightLabelWidth: CGFloat = 0
    
    @State var seeking = false
    
    enum DragState {
        case inactive
        case pressing
        case dragging(translation: CGSize)
        
        var translation: CGSize {
            switch self {
            case .inactive, .pressing:
                return .zero
            case .dragging(let translation):
                return translation
            }
        }
        
        var isActive: Bool {
            switch self {
            case .inactive:
                return false
            case .pressing, .dragging:
                return true
            }
        }
        
        var isDragging: Bool {
            switch self {
            case .inactive, .pressing:
                return false
            case .dragging:
                return true
            }
        }
    }
    
    @GestureState var dragState = DragState.inactive
    
    var body: some View {
        let minimumLongPressDuration = 0.01
        let longPressDrag = LongPressGesture(minimumDuration: minimumLongPressDuration)
            .sequenced(before: DragGesture())
            .updating(self.$dragState) { value, state, transaction in
                switch value {
                // Long press begins.
                case .first(true):
                    state = .pressing
                // Long press confirmed, dragging may begin.
                case .second(true, let drag):
                    state = .dragging(translation: drag?.translation ?? .zero)
                // Dragging ended or the long press cancelled.
                default:
                    state = .inactive
                }
            }
        
        let progress = Int(round(self.currentProgress * totalTime))
        let progressString = String(format: "%d:%02d", progress / 60, progress % 60)
        
        
        let left = Int(round((1.0 - self.currentProgress) * totalTime))
        let leftString = String(format: "-%d:%02d", left / 60, left % 60)
        
        return GeometryReader { geometry in
            ZStack(alignment: .top) {
                
                VStack {
                    Spacer()
                    
                    HStack {
                        Text(progressString)
                            .font(.system(size: 0.4 * geometry.size.height))
                            .foregroundColor(.blue)
                            .minimumScaleFactor(0.5)
                            .background(
                                GeometryReader { proxy in
                                    Color.clear
                                        .preference(key: WidthPreferenceKey.self, value: proxy.size.width)
                                }
                            )
                            .onPreferenceChange(WidthPreferenceKey.self) { preferences in
                              self.leftLabelWidth = preferences
                            }
                            .offset(x: 0, y: self.leftLabelOffset(geometry.size))
                        
                        Spacer()
                        
                        Text(leftString)
                            .font(.system(size: 0.4 * geometry.size.height))
                            .foregroundColor(.black)
                            .minimumScaleFactor(0.5)
                            .background(
                                GeometryReader { proxy in
                                    Color.clear
                                        .preference(key: WidthPreferenceKey.self, value: proxy.size.width)
                                }
                            )
                            .onPreferenceChange(WidthPreferenceKey.self) { preferences in
                              self.rightLabelWidth = preferences
                            }
                            .offset(x: 0, y: self.rightLabelOffset(geometry.size))
                    }
                }
                
                ZStack(alignment: .center) {
                    HStack(spacing: 0) {
                        RoundedRectangle(cornerRadius: 3 * geometry.size.height)
                            .fill(labelColor.opacity(1))
                        .frame(height: 0.2 * geometry.size.height)
                        .animation(.spring())
                    }
                    
                    ZStack {
                        Circle()
                        .animation(.spring())
                    }
                    .animation(nil)
                    .frame(width: 13, height: 13)
                    .contentShape(Rectangle())
                    .foregroundColor(Color(red: 255/255, green: 176/255, blue: 61/255))
                    .offset(x: (self.currentProgress - 0.5) * (geometry.size.width - geometry.size.height), y: 0)
                    .gesture(
                        longPressDrag
                        .onChanged { _ in
                            self.currentProgress = max(0.0, min(1.0, self.progressState + self.dragState.translation.width / (geometry.size.width - geometry.size.height)))
                        }
                        .onEnded { value in
                            guard case .second(true, let drag?) = value else { return }
                            self.progressState = max(0.0, min(1.0, self.progressState + drag.translation.width / (geometry.size.width - geometry.size.height)))
                            self.currentProgress = self.progressState
                       
                        }
                    )
                    .animation(nil)
                }
                .frame(height: 0.8 * geometry.size.height)
            }
            .padding(.horizontal, geometry.size.height / 2)
        }
            .frame(height: 40)
    }
    
    
    private func leftLabelOffset(_ size: CGSize) -> CGFloat {
        let maxProgress = (self.leftLabelWidth + size.height / 2) / (size.width - size.height)
        return self.dragState.isActive && currentProgress < maxProgress ? 0.25 * size.height : 0
    }
    
    
    private func rightLabelOffset(_ size: CGSize) -> CGFloat {
        let minProgress = 1.0 - (self.rightLabelWidth + size.height / 2) / (size.width - size.height)
        return self.dragState.isActive && currentProgress > minProgress ? 0.25 * size.height : 0
    }
    
    
    fileprivate struct WidthPreferenceKey: PreferenceKey {
        typealias Value = CGFloat
        static var defaultValue: Value = 0

        static func reduce(value: inout Value, nextValue: () -> Value) {
            value = nextValue()
        }
    }
}

struct SliderView_Previews: PreviewProvider {
    static var previews: some View {
        SliderView()
    }
}

