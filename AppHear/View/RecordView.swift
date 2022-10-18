//
//  RecordView.swift
//  AppHear
//
//  Created by Jason Kenneth on 16/10/22.
//

import SwiftUI
import Speech

struct RecordView: View {
    
    @State private var recording = false
    
    @ObservedObject private var mic = MicMonitor(numberOfSamples: 30)
    
    private var speechManager = SpeechRecManager()
    
    var body: some View {
        VStack{
            HStack{
                Image("down-chevron")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 12, height: 16)
                    .clipped(antialiased: true)
                    .padding(.trailing, 50)
                Text("04/10/22 09:41")
                    .font(.custom("Nunito-ExtraBold", size: 22))
                    .foregroundColor(Color(red: 66/255, green: 84/255, blue: 182/255, opacity: 1.0))
                    .multilineTextAlignment(.center)
                
                Button {
                   //
                } label: {
                    Image("id-lang-icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 23, height: 21)
                        .clipped(antialiased: true)
                    
                } .padding(.leading, 40)
                Button {
                   
                } label: {
                    Image("save-icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 21)
                        .clipped(antialiased: true)
                }
            }.padding(.top)
            ZStack{
                Image("rec-textbox")
                    .resizable()
                    .scaledToFit()
                    .shadow(radius: 10)
                    .padding()
                Image("rec-empty")
                    .resizable()
                    .frame(width: 210, height: 268)
                    .scaledToFit()
                    .padding()
            }
            HStack {
                visualizerView()
                Button {
                    addItem()
                } label: {
                    Image(recording ? "pause" : "purple-record")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 76, height: 76.5)
                }
                visualizerView()
                  
            }
        }.navigationBarHidden(true)
            .navigationBarTitle("")
    }
    
    private func soundLevel(level: Float) -> CGFloat {
        let level = max(0.2, CGFloat(level) + 50 / 2)
        return CGFloat(level * (100 / 25))
    }

    private func visualizerView() -> some View {
        VStack {
            HStack(spacing: 4) {
                ForEach(mic.soundSample, id: \.self) { (level) in
                    VizualizerView(value: self.soundLevel(level: level))
                }
            }
        }
    }
    
    private func addItem() {
        if speechManager.isRecording {
            self.recording = false
            mic.stopMonitoring()
            speechManager.stopRecording()
        } else {
            self.recording = true
            mic.startMonitoring()
            speechManager.start { (speechText) in
                guard let text = speechText, !text.isEmpty else {
                    self.recording = false
                    return
                }
            }
        }
        speechManager.isRecording.toggle()
    }
}



struct RecordView_Previews: PreviewProvider {
    static var previews: some View {
        RecordView()
    }
}

//Button(action: viewModel.startRecording) {
//
//}
