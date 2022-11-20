//
//  OnBoardingView.swift
//  AppHear
//
//  Created by Jason Kenneth on 20/11/22.
//

import SwiftUI

struct OnBoardingView: View {
    
    @State private var tabSelection = 1
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
            
            
            TabView(selection: $tabSelection) {
                OnBoardingContentView(image: "onboarding1", title: "Dapatkan Transcript\nLangsung", subtitle: "Transcript Langsung yang akurat bisa didapatkan ganya dengan sekali klik! Transcript Langsung untuk proses belajar yang lebih mudah.",  nextButton1: true, nextButton2: false, nextButton3: false, nextButton4: false, dismissButton: false, showOnBoarding: $showOnBoarding, tabSelection: $tabSelection).tag(1)
                
                OnBoardingContentView(image: "onboarding2", title: "Pilih Bahasa", subtitle: "Pilih bahasa sesuai kebutuhan untuk mendapatkan transcript yang lebih akurat.", nextButton1: false, nextButton2: true, nextButton3: false, nextButton4: false, dismissButton: false, showOnBoarding: $showOnBoarding, tabSelection: $tabSelection).tag(2)
                
                OnBoardingContentView(image: "onboarding3", title: "Bagikan Dengan Teman", subtitle: "Belajar dengan teman menjadi lebih menyenangkan dan mudah dengan berbagi Transcript Langsung.", nextButton1: false, nextButton2: false, nextButton3: true, nextButton4: false, dismissButton: false, showOnBoarding: $showOnBoarding, tabSelection: $tabSelection).tag(3)
                
                OnBoardingContentView(image: "onboarding4", title: "Belajar Kata Baru", subtitle: "Perkaya gudang kata yang dimiliki dengan kamus bahasa yang ada didalam Apphear.", nextButton1: false, nextButton2: false, nextButton3: false, nextButton4: true, dismissButton: false, showOnBoarding: $showOnBoarding, tabSelection: $tabSelection).tag(4)
                
                OnBoardingContentView(image: "onboarding5", title: "Sambung ke Airpods", subtitle: "Gunakan Airpods sebagai microphone untuk mendapatkan kualitas suara yang lebih baik.", nextButton1: false, nextButton2: false, nextButton3: false, nextButton4: false, dismissButton: true, showOnBoarding: $showOnBoarding, tabSelection: $tabSelection).tag(5)
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
    let nextButton1: Bool
    let nextButton2: Bool
    let nextButton3: Bool
    let nextButton4: Bool
    let dismissButton: Bool

    @Binding var showOnBoarding: Bool
    @Binding var tabSelection: Int
    
    var body: some View {
        VStack {
            Image(image)
                .resizable()
                .scaledToFit()
                .padding(.bottom)
                .frame(width: 300, height: 300)
            
            Text(title)
                .font(.custom("Nunito-Black", size: 25))
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding(.bottom)
                .frame(width: 314, height: 100)
            
            Text(subtitle)
                .font(.custom("Nunito-Regular", size: 18))
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .frame(width: 308, height: 100)
                .padding(.bottom)
            
            if nextButton1 {
                Button {
                    self.tabSelection = 2
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 40)
                            .frame(width: 309, height: 53)
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                        Text("Lanjut")
                            .font(.custom("Nunito-ExtraBold", size: 18))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(cgColor: .appHearBlue))
                    }
                    .padding()
                }
            }
            
            if nextButton2 {
                Button {
                    self.tabSelection = 3
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 40)
                            .frame(width: 309, height: 53)
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                        Text("Lanjut")
                            .font(.custom("Nunito-ExtraBold", size: 18))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(cgColor: .appHearBlue))
                    }
                }
                .padding()
            }
            
            if nextButton3 {
                Button {
                    self.tabSelection = 4
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 40)
                            .frame(width: 309, height: 53)
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                        Text("Lanjut")
                            .font(.custom("Nunito-ExtraBold", size: 18))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(cgColor: .appHearBlue))
                    }
                }
                
            }
            
            if nextButton4 {
                Button {
                    self.tabSelection = 5
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 40)
                            .frame(width: 309, height: 53)
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                        Text("Lanjut")
                            .font(.custom("Nunito-ExtraBold", size: 18))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(cgColor: .appHearBlue))
                    }
                }
                .padding()
            }
            
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
                .padding()
            }
        }
        .preferredColorScheme(.light)
    }
}

