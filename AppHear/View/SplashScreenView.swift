//
//  SplashScreenView.swift
//  AppHear
//
//  Created by Jason Kenneth on 17/11/22.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var opacity = 0.1
    var body: some View {
        if isActive == true {
            ContentView(viewModel: ContentViewModel())
        } else {
            ZStack {
                Image("ss-bg")
                    .resizable()
                    .scaledToFit()
                    .ignoresSafeArea()
                
                ZStack {
                    Image("ss-logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 98)
                }.opacity(opacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 1.5)) {
                            self.opacity = 1
                        }
                    }
            }
            .preferredColorScheme(.light)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2 ) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
