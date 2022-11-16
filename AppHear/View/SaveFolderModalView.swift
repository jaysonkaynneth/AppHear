//
//  SaveFolderView.swift
//  AppHear
//
//  Created by Jason Kenneth on 17/11/22.
//

import SwiftUI

struct SaveFolderModalView: View {
    var body: some View {
        VStack {
            Text("Select a Folder").font(.custom("Nunito-Bold", size: 18)).foregroundColor(Color(cgColor: .appHearBlue))
            HStack {
                VStack(alignment: .leading){
                    Image("recordings-icon").resizable().frame(width: 39, height: 44, alignment: .leading).padding(.bottom, 16)
                    Text("All Recordings").font(.custom("Nunito-Bold", size: 15)).foregroundColor(Color(cgColor: .appHearBlue))
                    Text("1 Recording").font(.custom("Nunito-Regular", size: 12)).foregroundColor(Color(cgColor: .appHearBlue))
                }.padding()
                    .background(RoundedRectangle(cornerRadius: 20).frame(width:150 , height: 150)
                        .foregroundColor(.white)
                        .shadow(radius: 20)
                    ).padding()
                Spacer()
            }.padding()
            Spacer()
        }.padding()
    }
}

struct SaveFolderModalView_Previews: PreviewProvider {
    static var previews: some View {
        SaveFolderModalView()
    }
}
