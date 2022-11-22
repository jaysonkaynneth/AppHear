//
//  SaveAlertView.swift
//  AppHear
//
//  Created by Jason Kenneth on 16/11/22.
//

import SwiftUI

struct SaveAlertView: View {
    var body: some View {
        VStack {
            Text("Recording not saved!")
                .font(.custom("Nunito-Regular", size: 15))
                .foregroundColor(.black)
            Text("Are you sure you want to clear this file?")
                .font(.custom("Nunito-Regular", size: 15))
                .foregroundColor(.black)
            
            Button {
                
            } label: {
                VStack {
                    Text("Clear")
                        .font(.custom("Nunito-Bold", size: 18))
                        .foregroundColor(Color(red: 215/255, green: 0/255, blue: 21/255))
                }
                .padding()
                .frame(width: 500)
                .background(.clear)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.gray, lineWidth: 1)
                )
            }
            
            Button {
                
            } label: {
                Text("Cancel")
                    .font(.custom("Nunito-Bold", size: 18))
                    .foregroundColor(Color(cgColor: .appHearBlue))
            }
        }.background(Color(cgColor: .screenColor))
    }
}

struct SaveAlertView_Previews: PreviewProvider {
    static var previews: some View {
        SaveAlertView()
    }
}
