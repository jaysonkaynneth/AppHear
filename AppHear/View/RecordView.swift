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
import PartialSheet

struct RecordView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var files: FetchedResults<File>
    
    @State var recording = false
    @State var speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "id-ID"))
    @State var locale : Locale?
    @State var recognitionRequest      : SFSpeechAudioBufferRecognitionRequest?
    @State var recognitionTask         : SFSpeechRecognitionTask?
    @State var defaultTaskHint: SFSpeechRecognitionTaskHint?
    @State private var transcript: String = ""
    @State private var isRecording: Bool = false
    @State private var showingExporter = false
    @State var confirmedText: AttributedString = ""
    @State var audioRecorder : AVAudioRecorder!
    @State var isDirty = true
    @State var audioURL: URL!
    @State var recordTitle = ""
    @State var isNotSaved = true
    @State var isPresented = false
    @State var isAlerted = false
    @State var notSaveAlert = false
    @State var isSharing = false
    @State var namaTim = ["Alicia Audrey", "Piter Wongso", "Jason Kenneth", "Mega Govania", "Stefanny Sianturi", "Ganesh Ekatata Buana"]
    
    @State var rpsSession: MultipeerSessionManager?
    @Environment(\.managedObjectContext) private var viewContext
    
    let audioEngine = AVAudioEngine()
    let searchWords = ["makan", "minum", "tendang", "buat", "guling", "lepas"]
    
    @ObservedObject var mic = MicMonitor(numberOfSamples: 50)
    
    var speechManager = SpeechRecManager()
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    if isNotSaved == false {
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        notSaveAlert = true
                    }
                    
                } label: {
                    Image("down-chevron")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 12, height: 16)
                        .clipped(antialiased: true)
                }
                .partialSheet(isPresented: $isNotSaved, content: SaveAlertView.init)
                .alert("Recording not saved!\nAre you sure you want to clear this file?", isPresented: $notSaveAlert) {
                    
                    Button("Clear", role: .destructive) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                
                TextField(SwiftUI.LocalizedStringKey("title"), text: $recordTitle, prompt: Text("ID \(getCurrentDay())").font(.custom("Nunito-ExtraBold", size: 22)).foregroundColor(Color(cgColor: .appHearBlue)))
                    .font(.custom("Nunito-ExtraBold", size: 22))
                    .foregroundColor(Color(cgColor: .appHearBlue))
                    .multilineTextAlignment(.center)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .frame(width: 240, height: 38, alignment: .center)
                    .padding(.leading, 20)
                
                Button {
                    //                    rpsSession = MultipeerSessionManager(username: UIDevice.current.name)
                    isSharing.toggle()
                } label: {
                    Image("connection-icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 23, height: 21)
                        .clipped(antialiased: true)
                }.sheet(isPresented: $isSharing){
                    //                    MultipeerModalView().environmentObject(rpsSession!)
                    MultipeerModalView().environmentObject(MultipeerSessionManager(username: UIDevice.current.name))
                }
                
                Button {
                    let inputNode = audioEngine.inputNode
                    
                    self.audioEngine.stop()
                    inputNode.removeTap(onBus: 0)
                    self.recognitionRequest?.endAudio()
                    self.recognitionRequest = nil
                    self.recognitionTask = nil
                    
                    self.audioRecorder = nil
                    
                    recording = false
                    isRecording = false
                    isPresented = true
                    isNotSaved = false
                    isAlerted = true
                    
                } label: {
                    Image("save-icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 21)
                        .clipped(antialiased: true)
                }
                .sheet(isPresented: $isPresented){
                    SaveRecordingModalView(fileName: (recordTitle.isEmpty ? "ID \(getCurrentDay())" : recordTitle), fileTranscript: transcript, fileAudio: audioURL.absoluteString)
                }.disabled(audioURL == nil || isRecording == true)
                        
                
                
            }.padding(.top)
            
            ZStack{
                
                Image("rec-textbox")
                    .resizable()
                    .scaledToFit()
                    .shadow(radius: 10)
                    .padding()
                
                if (transcript == ""){
                    VStack {
                        Image("rec-empty")
                            .resizable()
                            .frame(width: 154, height: 218)
                            .scaledToFit()
                            .padding()
                        Text("Mulai Rekam")
                            .font(.custom("Nunito-Bold", size: 20)).foregroundColor(Color(cgColor: .appHearBlue))
                    }
                    
                } else {
                    ScrollView {
                        Text(transcript).font(.system(size: 16, weight: .regular, design: .default))
                    }.padding(.horizontal, 55).padding(.vertical, 40).lineSpacing(5.0)
                }
                
            }
            
            
            ZStack {
                visualizerView()
                Rectangle()
                    .fill(.white)
                    .frame(width: 88, height: 100)
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
        .ignoresSafeArea(.keyboard)
        //        .partialSheet(isPresented: $isPresented, content: SaveRecordingModalView.init)
        .onTapGesture {
            self.endTextEditing()
        }
    }
    
    private func soundLevel(level: Float) -> CGFloat {
        if isRecording == false{
            let level = 1
            return CGFloat(level * 10)
        } else {
            let level = max(0.2, CGFloat(level) + 25)
            return CGFloat(level * 4)
        }
        
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
    
    func getCurrentDay() -> String{
            let time = Date()
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "dd/MM/yy HH:mm "
            let stringDate = timeFormatter.string(from: time)
            return stringDate
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
        
        audioURL = getAudioURL()
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
        recognitionRequest.addsPunctuation = true
        recognitionRequest.contextualStrings = namaTim
        
        let lang = UserDefaults.standard.string(forKey: "lang")
        if lang == "id"{
            locale = Locale.init(identifier: "id-ID")
        }
        else if lang == "en"{
            locale = Locale.init(identifier: "en-EN")
        }
        speechRecognizer = SFSpeechRecognizer(locale: locale!)
        
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
        if recordTitle != ""{
            return getDocumentsDirectory().appendingPathComponent("\(recordTitle).m4a")
        }
        else {
            let tempIndex = UserDefaults.standard.integer(forKey: "index") + 1
            UserDefaults.standard.setValue(tempIndex, forKey: "index")
            return getDocumentsDirectory().appendingPathComponent("Audio\(tempIndex).m4a")
        }
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


struct RecordView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RecordView()
            //            AnimationSheetView()
        }
        .attachPartialSheetToRoot()
        .navigationViewStyle(StackNavigationViewStyle())
    }
}


