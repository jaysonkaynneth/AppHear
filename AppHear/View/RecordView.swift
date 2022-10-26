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
    
    @State var recording = false
 
    //start of doom
    @State private var speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "id-ID"))
    @State var recognitionRequest      : SFSpeechAudioBufferRecognitionRequest?
    @State var recognitionTask         : SFSpeechRecognitionTask?
    @State var defaultTaskHint: SFSpeechRecognitionTaskHint?
    let audioEngine             = AVAudioEngine()
    @State private var transcript: String = ""
    @State private var isRecording: Bool = false
    @State private var showingExporter = false
    @State var confirmedText: AttributedString = ""
    let searchWords = ["makan", "minum", "tendang", "buat", "guling", "lepas"]
    //end of doom
    
    @ObservedObject var mic = MicMonitor(numberOfSamples: 50)
    
    var speechManager = SpeechRecManager()
    
//    @Binding var transcript: String
    
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
                    Image("connection-icon")
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
                
                if (transcript == ""){
                    Image("rec-empty")
                        .resizable()
                        .frame(width: 210, height: 268)
                        .scaledToFit()
                        .padding()
                }
                else{
                    ScrollView {
                        Text(transcript).font(.system(size: 16, weight: .regular, design: .default))
                    }.padding(.horizontal, 55).padding(.vertical, 40).lineSpacing(5.0)
                }
                
//                List {
//                    ForEach(files) { file in
//                        Text(file.text ?? "-")
//                    }
//                }
              
            }
            
            
            ZStack {
                visualizerView()
                Rectangle()
                    .fill(.white)
                    .frame(width: 88, height: 150)
                Button {
                    recording.toggle()
                    visualize()
                    buttonAction()
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
    
    private func visualize() {
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
    
    //INI TEMPORARY YA
    
    func buttonAction(){
        highlightText()
        setupSpeech()
        if audioEngine.isRunning {
            self.audioEngine.stop()
            self.recognitionRequest?.endAudio()
            isRecording = false
        } else {
            self.startRecording()
        }
    }


    func setupSpeech() {

        isRecording = false
    //        self.speechRecognizer?.delegate = self

        SFSpeechRecognizer.requestAuthorization { (authStatus) in

            var isButtonEnabled = false

            switch authStatus {
            case .authorized:
                isButtonEnabled = true

            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")

            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")

            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            @unknown default:
                fatalError()
            }

            OperationQueue.main.addOperation() {
                isRecording = isButtonEnabled
            }
        }
    }
    

    func highlightText(){
        confirmedText = ""

        let transcriptWords = transcript.components(separatedBy: " ")

        for word in transcriptWords {

            let attributedString: AttributedString = AttributedString(word)
            var isMatched = false

            for searchw in searchWords{
                var attributedWord: AttributedString = AttributedString(searchw)

                if word.contains(searchw){
                    var container = AttributeContainer()
                    container.foregroundColor = .black
                    container.backgroundColor = .orange
                    attributedWord.mergeAttributes(container)
                    confirmedText += AttributedString(" ") + attributedWord
                    isMatched = true
                }

            }

if isMatched == false{
confirmedText += AttributedString(" ") + attributedString
}
}
}

        func startRecording() {

        // Clear all previous session data and cancel task
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }

        // Create instance of audio session to record voice
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.record, mode: AVAudioSession.Mode.measurement, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        self.defaultTaskHint = .unspecified
        self.recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
            
        let inputNode = audioEngine.inputNode

        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }

        recognitionRequest.shouldReportPartialResults = true
    //            recognitionRequest.taskHint.addsPunctuation = true
        
        self.recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in

            var isFinal = false

            if result != nil {

                transcript = result?.bestTranscription.formattedString ?? "No transcript is made"
                isFinal = (result?.isFinal)!
            }

            if error != nil || isFinal {

                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)

                self.recognitionRequest = nil
                self.recognitionTask = nil

                isRecording = false
                
            }
            
        })

        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }

        self.audioEngine.prepare()

        do {
            try self.audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }

        transcript = "Recording speech.."
    }
    
    //INI TEMPORARY YA
    
    
}




