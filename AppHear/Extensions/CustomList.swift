//
//  LibraryView.swift
//  AppHear
//
//  Created by Jason Kenneth on 14/10/22.
//

import SwiftUI

struct CustomList: View {
    @State var name: String
    @State var date = Date()
    @State var emoji: String
    @State var files: File
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        print(documentsDirectory)
        return documentsDirectory
    }
    
    func getAudioURL() -> URL {
        return URL(string: files.audio!)!
//        return getDocumentsDirectory().appendingPathComponent("audio.m4a")
    }
    
    var body: some View {
        NavigationLink {
            PlaybackView(audioURL: getAudioURL(), passedFile: files)
                .navigationBarHidden(true)
                .navigationBarTitle("")
        } label: {
            ZStack(alignment: .leading){
                HStack {
                    VStack(alignment: .leading){
                        Text(name)
                            .foregroundColor(Color(red: 66/255, green: 84/255, blue: 182/255, opacity: 1.0))
                            .font(.custom("Nunito-ExtraBold", size: 18))
                            
                        Text(Date().dateFormat)
                            .foregroundColor(Color(red: 139/255, green: 139/255, blue: 139/255, opacity: 1.0))
                            .font(.custom("Nunito-ExtraBold", size: 13))
                    }
                    Spacer()
                    
                    Text(emoji)
                        .foregroundColor(.black)
                        .font(.system(size: 33))
                }.padding()
            }
            .padding(.leading)
            .padding(.trailing)
        }.background(RoundedRectangle(cornerRadius: 20)
            .fill(.white)
            .frame(width: 335)
            .padding(.leading)
            .shadow(radius: 5))
    }
    
}

extension Date {
    var dateFormat: String {
        self.formatted(.dateTime
            .day(.twoDigits)
            .month(.twoDigits)
            .year()
        )
    }
}



