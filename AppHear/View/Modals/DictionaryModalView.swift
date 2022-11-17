//
//  DictionaryModalView.swift
//  AppHear
//
//  Created by Piter Wongso on 11/11/22.
//

import Foundation
import SwiftUI
import ActivityIndicatorView

struct DictionaryModalView: View {
    var fetchedWord : String = ""
    @StateObject var dictionaryManager : DictionaryManager = DictionaryManager()
    @State var text: String = "some text"
    @State var word: String = "gambar"
    @State var lema: String = "gam.bar"
    @State var nomina: String = "n[Nomina: kata benda]"

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if dictionaryManager.isFetching{
                VStack{
                    ActivityIndicatorView(isVisible: $dictionaryManager.isFetching, type: .rotatingDots(count: 5))
                        .frame(width: 40,height: 40)
                        .foregroundColor(Color(CGColor.appHearOrange))
                    Text("Loading contents")
                        .foregroundColor(Color(CGColor.appHearOrange))
                }
            }else{
                ScrollView{
                    VStack(alignment: .leading){
                        Text(fetchedWord)
                            .font(Font.custom("Nunito-Bold", size: 32))
                            .foregroundColor(Color(CGColor.appHearOrange))
                        ForEach(dictionaryManager.word, id: \.self){ pertama in
                            ForEach(pertama.data , id: \.self) { kedua in
                                Text("/\(kedua.lema)/")
                                Text("")
                                ForEach(kedua.arti, id: \.self){ ketiga in
                                    Text(ketiga.kelasKata)
                                    Text(ketiga.deskripsi)
                                }
                            }
                        }.font(Font.custom("Nunito-Bold", size: 14))
                            .foregroundColor(Color(CGColor.appHearBlue))
                    }
                }
            }
        }
        .frame(height: dictionaryManager.isFetching ? 100 : 300)
        .onAppear{
            dictionaryManager.fetch(kata: fetchedWord)
        }
        .padding(.horizontal, 10)
    }
}
