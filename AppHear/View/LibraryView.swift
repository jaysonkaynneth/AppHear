//
//  LibraryView.swift
//  AppHear
//
//  Created by Jason Kenneth on 11/10/22.
//

import SwiftUI

struct LibraryView: View {
    
    @State private var searchText = ""
    
    init() {
            //Use this if NavigationBarTitle is with Large Font
            UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "Nunito-ExtraBold", size: 34)!]
        }
    
    private let recordings: [Recording] = [
        Recording(name: "Fisika", date: Date(), emoji: "😀"),
        Recording(name: "Data Mining", date: Date(), emoji: "🫶"),
        Recording(name: "Algorithm Design", date: Date(), emoji: "😮")
    ]
    
    var body: some View {
        NavigationView{
            VStack{
                    ForEach(recordings){ item in
                        CustomList(name: item.name, date: item.date, emoji: item.emoji)
                    }
                Spacer()
            }.navigationTitle("All Recordings")
                .padding()
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search File") {
                }
            
//                .background(Image("PatokanLibrary")
//                    .resizable()
//                    .edgesIgnoringSafeArea(.all)
//                                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        }
    }
}

struct Recording: Identifiable {
    let id = UUID()
    var name: String
    var date: Date
    var emoji: String
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
