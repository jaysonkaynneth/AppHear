//
//  RecordView.swift
//  AppHear
//
//  Created by Jason Kenneth on 16/10/22.
//

import SwiftUI

struct RecordView: View {
    var body: some View {
        VStack{
            HStack{
                Image("down-chevron")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 12, height: 16)
                    .clipped(antialiased: true)
                    .padding(.trailing, 50)
                Text("04/10/22 09:41")
                    .font(.custom("Nunito-ExtraBold", size: 22))
                    .foregroundColor(Color(red: 66/255, green: 84/255, blue: 182/255, opacity: 1.0))
                    .multilineTextAlignment(.center)
                
                Button {
                    print("Delete")
                } label: {
                    Image("id-lang-icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 23, height: 21)
                        .clipped(antialiased: true)
                    
                } .padding(.leading, 40)
                Button {
                    print("Delete")
                } label: {
                    Image("save-icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 21)
                        .clipped(antialiased: true)
                }
            }.padding(.top)
            ZStack{
                Image("rec-textbox")
                    .resizable()
                    .scaledToFit()
                    .shadow(radius: 10)
                    .padding()
                Image("rec-empty")
                    .resizable()
                    .frame(width: 210, height: 268)
                    .scaledToFit()
                    .padding()
            }
            Button {
                print("Delete")
            } label: {
                Image("purple-record-dummy")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 337, height: 76.5)
            }

        }
    }
}

struct RecordView_Previews: PreviewProvider {
    static var previews: some View {
        RecordView()
    }
}
