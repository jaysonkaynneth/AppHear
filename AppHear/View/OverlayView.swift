//
//  OverlayView.swift
//  AppHear
//
//  Created by Jason Kenneth on 20/10/22.
//

import SwiftUI

struct OverlayView: View {
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
                        NavigationLink {
                            RecordView()
                        } label: {
                            Image("id-lang-icon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 34, height: 31)
                                .padding(.leading)
                                .padding(.bottom)
                        }
                        
                        NavigationLink {
                            RecordView()
                        } label: {
                            Image("en-lang-icon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 34, height: 31)
                                .padding(.leading, 50)
                                .padding(.bottom)
                        }
                    }
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
