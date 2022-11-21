//
//  SearchBarView.swift
//  AppHear
//
//  Created by Piter Wongso on 21/11/22.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText : String
    var containerText : String = "Search Folder"
    var body: some View {
        HStack{
            Image(systemName: "magnifyingglass")
                .bold()
                .foregroundColor(.white)
                
            ZStack(alignment: .leading) {
                if searchText.isEmpty {
                    Text(containerText)
                        .foregroundColor(.white)
                }
                TextField("", text: $searchText)
                    .foregroundColor(.white)
                    .autocorrectionDisabled(true)
            }
            .overlay(
                Image(systemName: "xmark.circle.fill")
                    .padding()
                    .foregroundColor(.white)
                    .offset(x:10)
                    .opacity(searchText.isEmpty ? 0 : 1)
                    .onTapGesture {
                        endTextEditing()
                        searchText = ""
                    }
                ,alignment: .trailing
            )
            
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .foregroundColor(.white)
                .opacity(0.5)
        )
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(searchText: .constant(""))
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
}
