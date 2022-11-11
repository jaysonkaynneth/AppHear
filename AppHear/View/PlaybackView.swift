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
import AVFoundation

struct PlaybackView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var files: FetchedResults<File>
    
    @State private var currentValue = 0.0
    @State private var recording = false
    @State private var time: Double = 0
    
    @State var audiofiles = [AudioFiles]()
    @State var audioPlayer: AVAudioPlayer!
    
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
                
                SliderView(value: $currentValue,
                            sliderRange: 0...15802)
                    .frame(width: 350, height:8)
                    .padding(.top)
                    
                
                
                HStack{
                    Text("\(currentValue, specifier: "%.f")")
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
        }.preferredColorScheme(.light)
    }
    
    func loadAudio() {
        let pred = NSPredicate(value: true)
        let sort = NSSortDescriptor(key: "creationDate", ascending: false)
        let query = CKQuery(recordType: "AudioFiles", predicate: pred)
        query.sortDescriptors = [sort]

        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["transcript"]
        operation.resultsLimit = 50

        var newAudio = [AudioFiles]()

        operation.recordMatchedBlock = { record in
            print(record)
            var audio = AudioFiles()
            audio.recordID = record.recordID
            audio.transcript = record["transcript"]
            newAudio.append(audio)
            audiofiles = newAudio
            
        }
        
//        let yourContainer = CKContainer(identifier: "iCloud.samsantech.AppHear")
//        yourContainer.fetchUserRecordID { (userID, error) -> Void in
//             if let userID = userID {
//                 let reference = CKRecord.Reference(recordID: userID, action: .none)
//                 let predicate = NSPredicate(format: "creatorUserRecordID == %@", reference)
//                 let query = CKQuery(recordType: "AudioFiles", predicate: predicate)
//             }
//        }
        
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
    func fetchAudioAsset(with recordID: CKRecord.ID) {

        CKContainer.default().publicCloudDatabase.fetch(withRecordID: recordID) {(record, err) in

            DispatchQueue.main.async {
                if let err = err {
                    print(err.localizedDescription)
                    return
                }

                if record != nil { return }
                guard let audioAsset = record?["audio"] as? CKAsset else { return }
                guard let audioURL = audioAsset.fileURL else { return }

                do {
            
                    audioPlayer = try AVAudioPlayer(contentsOf: audioURL)

                } catch {
                    print(error.localizedDescription)
                }
            }
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

