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
                Text("Whats Up!").font(.custom("Nunito-VariableFont_wght", size: 17)).fontWeight(.regular).foregroundColor(Color.black)
                Text("Whats Up!")
            }.navigationTitle("All Recordings")
        }
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
