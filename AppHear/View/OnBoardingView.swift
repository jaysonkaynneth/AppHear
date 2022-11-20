//
//  OnBoardingView.swift
//  AppHear
//
//  Created by Jason Kenneth on 20/11/22.
//

import SwiftUI

struct OnBoardingView: View {
    
    @Binding var showOnBoarding: Bool
    
    var body: some View {
        ZStack {
            Rectangle()
                .ignoresSafeArea()
                .foregroundColor(Color(cgColor: .appHearBlue))
            
            Image("ss-bg-light")
                .resizable()
                .scaledToFit()
                .ignoresSafeArea()
            
            
            TabView {
                OnBoardingContentView(image: "onboarding1", title: "Dapatkan Transcript\nLangsung", subtitle: "Transcript Langsung yang akurat bisa didapatkan ganya dengan sekali klik! Transcript Langsung untuk proses belajar yang lebih mudah.", dismissButton: false, showOnBoarding: $showOnBoarding)
                
                OnBoardingContentView(image: "onboarding2", title: "Pilih Bahasa", subtitle: "Pilih bahasa sesuai kebutuhan untuk mendapatkan transcript yang lebih akurat.", dismissButton: false, showOnBoarding: $showOnBoarding)
                
                OnBoardingContentView(image: "onboarding3", title: "Bagikan Dengan Teman", subtitle: "Belajar dengan teman menjadi lebih menyenangkan dan mudah dengan berbagi Transcript Langsung.", dismissButton: false, showOnBoarding: $showOnBoarding)
                
                OnBoardingContentView(image: "onboarding4", title: "Belajar Kata Baru", subtitle: "Perkaya gudang kata yang dimiliki dengan kamus bahasa yang ada didalam Apphear.", dismissButton: false, showOnBoarding: $showOnBoarding)
                
                OnBoardingContentView(image: "onboarding5", title: "Sambung ke Airpods", subtitle: "Gunakan Airpods sebagai microphone untuk mendapatkan kualitas suara yang lebih baik.", dismissButton: true, showOnBoarding: $showOnBoarding)
            }
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        }
        .preferredColorScheme(.light)
    }
}

struct OnBoardingContentView: View {
    
    let image: String
    let title: String
    let subtitle: String
    let dismissButton: Bool
    
    @Binding var showOnBoarding: Bool
    
    var body: some View {
        VStack {
            Image(image)
                .resizable()
                .scaledToFit()
                .padding(.bottom)
                .frame(width: 298, height: 279)
            
            Text(title)
                .font(.custom("Nunito-Black", size: 25))
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding(.bottom)
            
            Text(subtitle)
                .font(.custom("Nunito-Regular", size: 18))
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .frame(width: 308)
                .padding(.bottom)
            
            if dismissButton {
                Button {
                    showOnBoarding.toggle()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 40)
                            .frame(width: 309, height: 53)
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                        Text("Mulai")
                            .font(.custom("Nunito-ExtraBold", size: 18))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(cgColor: .appHearBlue))
                    }
                }
            }
        }
        .preferredColorScheme(.light)
    }
}

