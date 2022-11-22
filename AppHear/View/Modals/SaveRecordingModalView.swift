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
    @State var newFileName: String = ""
    @State var fileTranscript: String = ""
    @State var fileAudio: String = ""
    @State var chosenFolder: RecordFolder?
    @State var showFolders = false
    @State var isSaved = false
    
    
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
            ZStack(alignment: .leading){
                if (fileName.starts(with: "ID") || fileName.starts(with: "EN")){
                    if newFileName.isEmpty{
                        Text(fileName)
                            .foregroundColor(.gray)
                            .padding(.leading)
                    }
                    TextField("", text: $newFileName)
                        .padding()
                        .foregroundColor(.black)
                        .autocorrectionDisabled()
                    
                }else {
                    TextField("", text: $newFileName)
                        .padding()
                        .autocorrectionDisabled()
                }
            }
            .frame(width: 309, height: 39).background(RoundedRectangle(cornerRadius: 19.5)
            .stroke(Color(red: 217/255, green: 217/255, blue: 217/255)))
            .padding(.bottom)
            .font(.custom("Nunito-Semibold", size: 17))
            .foregroundColor(.black)
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
                        if chosenFolder != nil{
                            Text((chosenFolder?.title)!)
                                .font(.custom("Nunito-Semibold", size: 17))
                                .foregroundColor(.black)
                                .padding(.leading, 42)
                        }
                        else{
                            Text("Choose Folder")
                                .font(.custom("Nunito-Semibold", size: 17))
                                .foregroundColor(.gray)
                                .padding(.leading, 42)
                        }
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
                
                if (newFileName != ""){
                    file.title = newFileName
                }
                else{
                    file.title = fileName
                }
                file.transcript = fileTranscript
                file.audio = fileAudio
                file.date = Date()
                file.folder = chosenFolder?.title
                file.emoji = chosenFolder?.emoji
                file.isdeleted = false
                
                try? moc.save()
                isSaved.toggle()
                
            } label: {
                if (chosenFolder == nil) {
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
                
            }.alert("Rekaman berhasil disimpan!", isPresented: $isSaved) {
                Button("Tutup", role: .cancel){
                    presentationMode.wrappedValue.dismiss()
                }
            }
            Spacer()
        }
        .background(Color(cgColor: .screenColor))
        .padding().onTapGesture(perform: endTextEditing)
            .onAppear{
                if !(fileName.starts(with: "ID") || fileName.starts(with: "EN")){
                    newFileName = fileName
                }
            }
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
