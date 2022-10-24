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
    
    var body: some View {
        NavigationLink {
            PlaybackView()
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



