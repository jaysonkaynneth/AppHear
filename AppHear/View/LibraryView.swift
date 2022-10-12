//
//  LibraryView.swift
//  AppHear
//
//  Created by Jason Kenneth on 11/10/22.
//

import SwiftUI

struct LibraryView: View {
    
    
    var body: some View {
        NavigationView{
            VStack{
                Text("Whats Up!").font(Font.custom("Nunito Black", size: 17))
                
                Text("Whats Up!")
            }.navigationTitle("All Recordings")
                .onAppear{for family in UIFont.familyNames.sorted() {
                    let names = UIFont.fontNames(forFamilyName: family)
                    print("Family: \(family) Font names: \(names)")
                    }
                }
        }
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
