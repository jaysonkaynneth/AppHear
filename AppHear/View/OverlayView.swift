//
//  OverlayView.swift
//  AppHear
//
//  Created by Jason Kenneth on 20/10/22.
//

import SwiftUI

struct OverlayView: View {
    
    @State private var isPresented = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.primary.opacity(0.5))
                .ignoresSafeArea()
            
            VStack {
                
                Spacer()
                ZStack {
                    Image("lang-popup")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 197, height: 68)
                    HStack {
                        Button {
                            isPresented.toggle()
                   
                        } label: {
                            Image("id-lang-icon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 34, height: 31)
                                .padding(.leading)
                                .padding(.bottom)
                        }
                        .fullScreenCover(isPresented: $isPresented, content: RecordView.init)
                        
                        Button {
                            isPresented.toggle()
                   
                        } label: {
                            Image("en-lang-icon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 34, height: 31)
                                .padding(.leading, 50)
                                .padding(.bottom)
                        }
                        .fullScreenCover(isPresented: $isPresented, content: RecordView.init)                    }
                }
                
                ZStack {
                    
                    Rectangle().fill(.clear).frame(width: 390, height: 144, alignment: .center).offset(y: 4)
                }
            }
        }.ignoresSafeArea()
    }
}


struct OverlayView_Previews: PreviewProvider {
    static var previews: some View {
        OverlayView()
    }
}
