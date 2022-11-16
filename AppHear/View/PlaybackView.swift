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
import CloudKit
import AVKit
import AVFoundation
import PartialSheet
import Combine


struct PlaybackView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var files: FetchedResults<File>
    
    @State private var currentValue = 0.0
    @State private var isPlaying = false
    @State private var time: Double = 0
    @State private var transcript = AttributedString("")
    @State private var isSheetPresented = false
    @State var storedURL: URL?
    @StateObject var dictionaryManager : DictionaryManager = DictionaryManager()
    @ObservedObject var audioPlayer = AudioPlayerManager()
    
    //For testing only
    var kalimat = "Roket memakan banyak oksigen dan meminum banyak udara batubara. Roket tidak bisa membaca arah gerak mata angin, pembacaan buku bacaan dibacakan oleh baca"
    //
    
    let audioDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    var audioURL: URL
    var passedFile: File
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func getAudioURL() -> URL {
//        return getDocumentsDirectory().appendingPathComponent("audio.m4a")
        return URL(fileURLWithPath: passedFile.audio!)
    }
    
    
    @State var audiofiles = [AudioFiles]()
    
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
                    
                    Text(passedFile.title!)
                        .font(.custom("Nunito-ExtraBold", size: 22))
                        .foregroundColor(Color(CGColor.appHearBlue))
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
                        ScrollView{
                            Text(dictionaryManager.confirmedText)
                                .onTapGesture {location in
                                    dictionaryManager.extractWord(location: location, transcript: passedFile.transcript!)
                                }
                        }.frame(width: 290)
                            .padding(.top,20)
                        Spacer()
                    }
                }
                
                SliderView()
//                .frame(width: 350, height:8)
                .padding(.top)
                
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
                        isPlaying.toggle()
                        if isPlaying == true{
                            self.audioPlayer.play(audio: self.audioURL)
                        } else {
                            self.audioPlayer.pause()
                        }
                        
                        
                    } label: {
                        Image(isPlaying ? "pause" : "play")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 64, height: 64)
                    }
                    .padding(.leading)
                    .padding(.trailing)
                    
                    Button {
                        //ACTION
                    } label: {
                        Image("forward")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 36, height: 29)
                    }
                    .padding(.leading)
                    Spacer()
                    Button {
                        //ACTION
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
        }.preferredColorScheme(.light)
            .partialSheet(isPresented: $dictionaryManager.isSheetPresented, content: {
                DictionaryModalView(fetchedWord: dictionaryManager.tappedWord.trimTrailingPunctuation())
            })
            .onAppear{
                var attString = AttributedString(passedFile.transcript!)
                var containerForAttString = AttributeContainer()
                containerForAttString.font = .system(size: 16)
                containerForAttString.foregroundColor = Color(CGColor.appHearBlue)
                attString.mergeAttributes(containerForAttString)
                transcript = attString
                dictionaryManager.highlightText(transcript: passedFile.transcript!)
                dictionaryManager.confirmedText.mergeAttributes(containerForAttString)
            }
    }
    
//    func loadAudio() {
//        let pred = NSPredicate(value: true)
//        let sort = NSSortDescriptor(key: "creationDate", ascending: false)
//        let query = CKQuery(recordType: "AudioFiles", predicate: pred)
//        query.sortDescriptors = [sort]
//
//        let operation = CKQueryOperation(query: query)
//        operation.desiredKeys = ["transcript"]
//        operation.resultsLimit = 50
//
//        var newAudio = [AudioFiles]()
//
//        operation.recordMatchedBlock = { record in
//            print(record)
//            var audio = AudioFiles()
//            audio.recordID = record.recordID
//            audio.transcript = record["transcript"]
//            newAudio.append(audio)
//            audiofiles = newAudio
//
//        }
//        CKContainer.default().publicCloudDatabase.add(operation)
//    }
    
//    func fetchAudioAsset(with recordID: CKRecord.ID) {
//
//        CKContainer.default().publicCloudDatabase.fetch(withRecordID: recordID) {(record, err) in
//
//            DispatchQueue.main.async {
//                if let err = err {
//                    print(err.localizedDescription)
//                    return
//                }
//
//                if record != nil { return }
//                guard let audioAsset = record?["audio"] as? CKAsset else { return }
//                guard let audioURL = audioAsset.fileURL else { return }
//
//                do {
//
//                    audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
//
//                } catch {
//                    print(error.localizedDescription)
//                }
//            }
//        }
//    }
    
}
        

//struct PlaybackView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlaybackView()
//    }
//}



//Button(action: viewModel.startRecording) {
//
//}


