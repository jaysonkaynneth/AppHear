//
//  RecordView.swift
//  AppHear
//
//  Created by Jason Kenneth on 16/10/22.
//

import SwiftUI
import CoreData
import Speech
import AVFoundation
import CloudKit

struct RecordView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var files: FetchedResults<File>
    
    @State var recording = false
    @State private var speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "id-ID"))
    @State var recognitionRequest      : SFSpeechAudioBufferRecognitionRequest?
    @State var recognitionTask         : SFSpeechRecognitionTask?
    @State var defaultTaskHint: SFSpeechRecognitionTaskHint?
    @State private var transcript: String = ""
    @State private var isRecording: Bool = false
    @State private var showingExporter = false
    @State var confirmedText: AttributedString = ""
    @State var audioRecorder : AVAudioRecorder!
    @State var isDirty = true
    
    @State var recordTitle = ""

    let audioEngine = AVAudioEngine()
    let searchWords = ["makan", "minum", "tendang", "buat", "guling", "lepas"]
    
    @ObservedObject var mic = MicMonitor(numberOfSamples: 50)
    
    var speechManager = SpeechRecManager()
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    presentationMode.wrappedValue.dismiss()
                  
                } label: {
                    Image("down-chevron")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 12, height: 16)
                        .clipped(antialiased: true)
                }
                
                TextField(SwiftUI.LocalizedStringKey("title"), text: $recordTitle, prompt: Text("Insert Title"))
                    .font(.custom("Nunito-ExtraBold", size: 22))
                    .foregroundColor(Color(cgColor: .appHearBlue))
                    .multilineTextAlignment(.center)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .frame(width: 240, height: 38, alignment: .center)
                    .padding(.leading, 20)
                
                Button {
                    //ACTION
                } label: {
                    Image("connection-icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 23, height: 21)
                        .clipped(antialiased: true)
                    
                }
                Button {
                    //ACTION
                    let audioURL = getAudioURL()
                    let inputNode = audioEngine.inputNode
                    let file =  File(context: moc)
                    
                    file.transcript = (transcript)
                    file.audio = audioURL.absoluteString
                    file.title = recordTitle
                    file.date = Date()
                    
                    try? moc.save()
                    self.audioEngine.stop()
                    inputNode.removeTap(onBus: 0)
                    self.recognitionRequest = nil
                    self.recognitionTask = nil
                    
                    recording = false
                    isRecording = false
                    
                    doSubmission()
                    print(recordTitle)
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
            }
        }
        .navigationBarHidden(true)
        .navigationBarTitle("")
        .preferredColorScheme(.light)
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
    
    //INI TEMPORARY YAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    
    func buttonAction(){
        highlightText()
        setupSpeech()
        if audioEngine.isRunning {
            self.audioEngine.stop()
            self.recognitionRequest?.endAudio()
            isRecording = false
            self.audioRecorder.stop()
            self.audioRecorder = nil
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

        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioURL = getAudioURL()
            print(audioURL.absoluteString)
        
        let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
        
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
                self.audioRecorder = nil
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
                audioRecorder = try AVAudioRecorder(url: audioURL, settings: settings)
                audioRecorder.record()
                try self.audioEngine.start()
            } catch {
                print("fail starting audio recorder")
            }
        
//        do {
//            try self.audioEngine.start()
//        } catch {
//            print("audioEngine couldn't start because of an error.")
//        }
        
        transcript = "Recording speech.."
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    func getAudioURL() -> URL {
        return getDocumentsDirectory().appendingPathComponent("\(recordTitle) + .m4a")
        //return getDocumentsDirectory().appendingPathComponent("\(title).m4a")
    }
    
    func doSubmission () {
        let audioRecord = CKRecord(recordType: "AudioFiles")
        audioRecord["transcript"] = transcript as CKRecordValue

        let audioURL = getAudioURL()
        let audioAsset = CKAsset(fileURL: audioURL)
        audioRecord["audio"] = audioAsset
        
        CKContainer.default().publicCloudDatabase.save(audioRecord) { record, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else {
                    print("\(String(describing: record?.recordID))")
                }
            }
        }
        
    }
    
    //INI TEMPORARY YAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    
    
}




