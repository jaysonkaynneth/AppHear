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
            ZStack(alignment: .center){
                Rectangle().foregroundColor(.white).frame(width: 350, height: 71, alignment: .center).cornerRadius(20, antialiased: true).shadow(color: Color(cgColor: .buttonShadow), radius: 5.0).overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(cgColor: .buttonBorder), lineWidth: 2)).padding(.leading, 18)
                
                HStack (alignment: .center){
                    VStack(alignment: .leading){
                        Text(name)
                            .foregroundColor(Color(red: 66/255, green: 84/255, blue: 182/255, opacity: 1.0))
                            .font(.custom("Nunito-ExtraBold", size: 18))
                            
                        Text(Date().dateFormat)
                            .foregroundColor(Color(red: 139/255, green: 139/255, blue: 139/255, opacity: 1.0))
                            .font(.custom("Nunito-ExtraBold", size: 15))
                    }.padding(.leading, 20)
                    Spacer()
                    Text(emoji)
                        .foregroundColor(.black)
                        .font(.system(size: 33))
                }.padding()
            }
            .padding(.leading)
            .padding(.trailing)
        }
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



