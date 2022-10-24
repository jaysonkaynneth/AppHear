//
//  PlaybackView.swift
//  AppHear
//
//  Created by Jason Kenneth on 19/10/22.
//

//
//  RecordView.swift
//  AppHear
//
//  Created by Jason Kenneth on 16/10/22.
//

import SwiftUI
import Speech

struct PlaybackView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var recording = false
    @State private var time: Double = 0
    
    var body: some View {
        NavigationView {
            VStack{
                HStack{
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image("left-chevron")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 12, height: 16)
                            .clipped(antialiased: true)
                            .padding(.leading)
                    }
                    Spacer()
                    
                    Text("Typography S1")
                        .font(.custom("Nunito-ExtraBold", size: 22))
                        .foregroundColor(Color(red: 66/255, green: 84/255, blue: 182/255, opacity: 1.0))
                        .multilineTextAlignment(.center)
                    Spacer()
                    Button {
                        //
                    } label: {
                        Image("export")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 23, height: 21)
                            .clipped(antialiased: true)
                        
                    }.padding(.trailing)
                }.padding(.top)
                ZStack{
                    Image("pb-textbox")
                        .resizable()
                        .scaledToFit()
                        .shadow(radius: 10)
                
                    VStack{
                        Image("text-placeholder")
                            .resizable()
                            .frame(width: 290, height: 165)
                            .scaledToFit()
                            .padding(.top, 50)
                        Spacer()
                    }
                }
                
                Slider(value: $time, in: 0...15802)
                    .padding(.leading)
                    .padding(.trailing)
                HStack{
                    Text("\(time, specifier: "%.f")")
                        .padding(.leading)
                    Spacer()
                    Text("1:58:02") .font(.custom("Nunito-Medium", size: 12))
                        .padding(.trailing)
                }
        
                HStack {
                    
                    Button {
                        
                    } label: {
                        Image("yellow-play")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 33, height: 33)
                    }
                    .padding(.leading)
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image("backward")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 36, height: 29)
                    }
                    .padding(.trailing)
                    
                    Button {
                        recording.toggle()
                    } label: {
                        Image(recording ? "pause" : "play")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 64, height: 64)
                    }
                    .padding(.leading)
                    .padding(.trailing)
                    
                    Button {
                        
                    } label: {
                        Image("forward")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 36, height: 29)
                    }
                    .padding(.leading)
                    Spacer()
                    Button {
                        
                    } label: {
                        Image("yellow-trash")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 33, height: 33)
                    }
                    .padding(.trailing)
                }
            }
            .navigationBarHidden(true)
        .navigationBarTitle("")
        }
    }
}



struct PlaybackView_Previews: PreviewProvider {
    static var previews: some View {
        PlaybackView()
    }
}

//Button(action: viewModel.startRecording) {
//
//}

