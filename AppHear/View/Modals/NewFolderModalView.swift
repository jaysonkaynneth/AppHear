//
//  NewFolderModalView.swift
//  AppHear
//
//  Created by Jason Kenneth on 17/11/22.
//

import SwiftUI

struct NewFolderModalView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var files: FetchedResults<File>
    @FetchRequest(sortDescriptors: []) var folders: FetchedResults<RecordFolder>
    
    @State private var folderName: String = ""
    @State private var emoji: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image("red-x")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22, height: 22)
                        .clipped(antialiased: true)
                    
                }.padding(.leading)
                
                Spacer()
                
                Text("New Folder")
                    .font(.custom("Nunito-Bold", size: 18)).foregroundColor(Color(cgColor: .appHearBlue))
                
                Spacer()
                
                Button {
                    
                    let folder =  RecordFolder(context: moc)
                    
                    folder.title = folderName
                    folder.emoji = emoji
                    folder.count = 0
                
                    try? moc.save()
                    
                } label: {
                    Image("save-icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 21)
                        .clipped(antialiased: true)
                }.disabled(folderName.isEmpty)
                    .padding(.trailing)
            } 
            
            VStack(alignment: .center){
                ZStack {
                    Circle()
                        .strokeBorder(Color(red: 217/255, green: 217/255, blue: 217/255))
                        .frame(width: 124, height: 124)
                    
                    if (emoji == ""){
                        Image("placeholder-emoji")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 73, height: 81)
                            .padding(.top, 10)
                            .padding(.leading, 3)
                    }
                    else if emoji != ""{
                        Text(emoji)
                            .font(.system(size: 72))
                            .scaledToFit()
                            .frame(width: 73, height: 81)
                    }
                    
                }
                
                ZStack{
                    Text("Choose Emoji")
                        .underline()
                        .font(.custom("Nunito-Bold", size: 12)).foregroundColor(Color(cgColor: .appHearBlue))
                    EmojiTextField(text: $emoji, placeholder: "").frame(width: 80, height: 28, alignment: .center).underline()
                }
                
               
                    
                }
            
            TextField("Folder Name", text: $folderName)
                .font(.custom("Nunito-Bold", size: 17)).foregroundColor(Color(cgColor: .appHearBlue))
                .padding()
                .frame(width: 309, height: 39)
                .background(RoundedRectangle(cornerRadius: 19.5)
                    .stroke(Color(red: 217/255, green: 217/255, blue: 217/255)))
                .padding(.bottom)
            
            Spacer()
            
        }.padding(.top)
    }
}

struct NewFolderModalView_Previews: PreviewProvider {
    static var previews: some View {
        NewFolderModalView()
    }
}
