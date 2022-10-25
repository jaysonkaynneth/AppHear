//
//  RecordView.swift
//  AppHear
//
//  Created by Jason Kenneth on 16/10/22.
//

import SwiftUI
import CoreData
import Speech

struct RecordView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \File.create, ascending: true)], animation: .default) private var files: FetchedResults<File>
    
    @State private var recording = false
    
    @ObservedObject private var mic = MicMonitor(numberOfSamples: 50)
    
    private var speechManager = SpeechRecManager()
    
    var body: some View {
        VStack{
            HStack{
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image("down-chevron")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 12, height: 16)
                        .clipped(antialiased: true)
                        .padding(.trailing, 50)
                }
                Text("04/10/22 09:41")
                    .font(.custom("Nunito-ExtraBold", size: 22))
                    .foregroundColor(Color(red: 66/255, green: 84/255, blue: 182/255, opacity: 1.0))
                    .multilineTextAlignment(.center)
                
                Button {
                    //ACTION
                } label: {
                    Image("id-lang-icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 23, height: 21)
                        .clipped(antialiased: true)
                    
                } .padding(.leading, 40)
                Button {
                    //ACTION
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
                
                List {
                    ForEach(files) { file in
                        Text(file.text ?? "-")
                    }
                }
              
                
//                Image("")
//                    .resizable()
//                    .frame(width: 210, height: 268)
//                    .scaledToFit()
//                    .padding()
            }
            ZStack {
                visualizerView()
                Rectangle()
                    .fill(.white)
                    .frame(width: 88, height: 150)
                Button {
                    startRecording()
                } label: {
                    Image(recording ? "pause" : "purple-record")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 76, height: 76.5)
                        
                }
//                visualizerView()
            }
        }.navigationBarHidden(true)
            .navigationBarTitle("")
    }
    
    private func soundLevel(level: Float) -> CGFloat {
        let level = max(0.2, CGFloat(level) + 25)
        return CGFloat(level * 4)
    }

    private func visualizerView() -> some View {
        VStack {
            HStack(spacing: 4) {
                ForEach(mic.soundSample, id: \.self) { (level) in
                    VizualizerView(value: self.soundLevel(level: level))
                }.frame(height: 76)
            }
        }
    }
    
    private func startRecording() {
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
                DispatchQueue.main.async {
                    withAnimation {
                        let newItem = File(context: viewContext)
                        newItem.id = UUID()
                        newItem.text = text
                        newItem.create = Date()
                        
                        do {
                            try viewContext.save()
                        } catch {
                            print(error)
                        }
                    }
                }
            }
        }
        speechManager.isRecording.toggle()
    }
}



//Button(action: viewModel.startRecording) {
//
//}
