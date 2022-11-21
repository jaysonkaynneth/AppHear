//
//  SaveRecordingModalView.swift
//  AppHear
//
//  Created by Jason Kenneth on 16/11/22.
//

import SwiftUI

struct SaveRecordingModalView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    
    @State var fileName: String = ""
    @State var nameEdited = false
    @State var fileTranscript: String = ""
    @State var fileAudio: String = ""
    @State var chosenFolder: RecordFolder?
    @State var showFolders = false
    
    
    var body: some View {
        VStack {
            Text("Save Recording") .font(.custom("Nunito-Bold", size: 18))
                .foregroundColor(Color(cgColor: .appHearBlue))
                .padding(.bottom)
            HStack{
                Text("File Name")
                    .font(.custom("Nunito-Semibold", size: 15))
                    .foregroundColor(Color(cgColor: .appHearBlue))
                    .padding(.leading, 35)
        
                Spacer()
            }
            
            TextField("File Name", text: $fileName)
                .padding()
                .frame(width: 309, height: 39)
                .background(RoundedRectangle(cornerRadius: 19.5)
                    .stroke(Color(red: 217/255, green: 217/255, blue: 217/255)))
                .padding(.bottom)
                .font(.custom("Nunito-Semibold", size: 17))
                .foregroundColor(.gray)
                .onTapGesture {
                    nameEdited.toggle()
                }
                .autocorrectionDisabled()
            
            HStack{
                Text("Folder Name")
                    .font(.custom("Nunito-Semibold", size: 15))
                    .foregroundColor(Color(cgColor: .appHearBlue))
                    .padding(.leading, 35)
                Spacer()
            }
            
            Button {
                showFolders.toggle()
            } label: {
                ZStack {
                    HStack{
                        Text(chosenFolder?.title ?? "Choose Folder")
                            .font(.custom("Nunito-Semibold", size: 17))
                            .foregroundColor(.gray)
                            
                            .padding(.leading, 42)
                        Spacer()
                    }
                    RoundedRectangle(cornerRadius: 19.5)
                        .stroke(Color(red: 217/255, green: 217/255, blue: 217/255))
                        .frame(width: 309, height: 39)
                }
            }.sheet(isPresented: $showFolders){
                SaveFolderModalView(selectedFolder: $chosenFolder)
            }
        
            Button {
                
                let file =  File(context: moc)
                file.title = fileName
                file.transcript = fileTranscript
                file.audio = fileAudio
                file.date = Date()
                file.folder = chosenFolder?.title
                file.emoji = chosenFolder?.emoji
                file.isdeleted = false
                
                try? moc.save()
                
                presentationMode.wrappedValue.dismiss()
                
            } label: {
                if nameEdited == false {
                    ZStack {
                        RoundedRectangle(cornerRadius: 40)
                            .fill(Color(cgColor: .gradient2))
                            .frame(width: 309,height: 45)
                        
                        Text("Save")
                            .font(.custom("Nunito-Semibold", size: 15))
                            .foregroundColor(.white)
                    }
                }
                
                else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 40)
                            .fill(Color(cgColor: .appHearBlue))
                            .frame(width: 309,height: 45)
                        
                        Text("Save")
                            .font(.custom("Nunito-Semibold", size: 15))
                            .foregroundColor(.white)
                    }
                }
                
            }
            Spacer()
        }.padding().onTapGesture(perform: endTextEditing)
    }
}

struct SaveRecordingModalView_Previews: PreviewProvider {
    static var previews: some View {
        SaveRecordingModalView()
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
