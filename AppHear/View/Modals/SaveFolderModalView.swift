//
//  SaveFolderView.swift
//  AppHear
//
//  Created by Jason Kenneth on 17/11/22.
//

import SwiftUI

struct SaveFolderModalView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @FetchRequest(sortDescriptors: []) var folders: FetchedResults<RecordFolder>
    @Binding var selectedFolder : RecordFolder?
    
    private func folderSelected(folder: RecordFolder){
        selectedFolder = folder
        print(selectedFolder!.title!)
    }
    
    var body: some View {
        VStack {
            Text("Select a Folder").font(.custom("Nunito-Bold", size: 18)).foregroundColor(Color(cgColor: .appHearBlue))
            
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2)) {
                    
                    ForEach(folders) { folders in
                        Button {
                            folderSelected(folder: folders)
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            ZStack{
                                Rectangle().foregroundColor(.white).frame(width: 165, height: 142).cornerRadius(20, antialiased: true).shadow(color: Color(cgColor: .buttonShadow), radius: 5.0).overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color(cgColor: .buttonBorder), lineWidth: 2))
                                
                                VStack(alignment: .leading){
                                    Text(folders.emoji!)
                                        .font(.system(size: 46))
                                        .scaledToFit()
                                        .frame(width: 50, height: 50, alignment: .leading)
                                        .padding(.bottom, 16)
                                    Text(folders.title!).font(.custom("Nunito-Bold", size: 15)).foregroundColor(Color(cgColor: .appHearBlue))
                                    Text("\(folders.count) Recordings").font(.custom("Nunito-Regular", size: 12)).foregroundColor(Color(cgColor: .appHearBlue))
                                }.padding(.trailing, 50)
                            }
                        }
                    }
                }.padding(.top, 30)
                
            }.frame(width: 360).offset(y: -20)
            
            Spacer()
        }.padding()
    }
}

//struct SaveFolderModalView_Previews: PreviewProvider {
//    static var previews: some View {
//        SaveFolderModalView()
//    }
//}
