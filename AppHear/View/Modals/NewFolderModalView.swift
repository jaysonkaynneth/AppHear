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
    
    @State private var folderName: String = ""
    @State private var emoji: String = ""
    @State private var isEmoji = false
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
                    
                    //
                } label: {
                    Image("save-icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 21)
                        .clipped(antialiased: true)
                }.disabled(folderName.isEmpty)
                    .padding(.trailing)
            } 
            
            
            
            
            Button {
                
            } label: {
                VStack{
                    ZStack {
                        Circle()
                            .strokeBorder(Color(red: 217/255, green: 217/255, blue: 217/255))
                            .frame(width: 124, height: 124)
                        
                        Image(isEmoji ? "\(emoji)" : "placeholder-emoji")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 73, height: 81)
                            .padding(.top, 10)
                            .padding(.leading, 3)
                    }
                    
                    Text("Choose Emoji")
                        .underline()
                        .font(.custom("Nunito-Bold", size: 12)).foregroundColor(Color(cgColor: .appHearBlue))
                    
                }
            }
            
            
            TextField("Folder Name", text: $folderName)
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
