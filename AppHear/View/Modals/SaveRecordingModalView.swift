//
//  SaveRecordingModalView.swift
//  AppHear
//
//  Created by Jason Kenneth on 16/11/22.
//

import SwiftUI

struct SaveRecordingModalView: View {
    
    @State var fileName: String = ""
    @State var folderName: String = ""
    
    
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
            
            HStack{
                Text("Folder Name")
                    .font(.custom("Nunito-Semibold", size: 15))
                    .foregroundColor(Color(cgColor: .appHearBlue))
                    .padding(.leading, 35)
                Spacer()
            }
            
            Button {
              
            } label: {
                ZStack {
                    HStack{
                        Text("Folder Name")
                            .font(.custom("Nunito-Semibold", size: 17))
                            .foregroundColor(.gray)
                            
                            .padding(.leading, 42)
                        Spacer()
                    }
                    RoundedRectangle(cornerRadius: 19.5)
                        .stroke(Color(red: 217/255, green: 217/255, blue: 217/255))
                        .frame(width: 309, height: 39)
                }
            }   
            
       
            
            Button {
                
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 40)
                        .fill(Color(cgColor: .gradient2))
                        .frame(width: 309,height: 45)
                    
                    Text("Save")
                        .font(.custom("Nunito-Semibold", size: 15))
                        .foregroundColor(.white)
                }
            }
        }.padding()
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
